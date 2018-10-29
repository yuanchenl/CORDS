pkill -f 'cep-*'
CURR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#Delete all the CORDS trace files
#Delete ceph workload directories
rm -rf cordslog*
rm -rf trace*
rm -rf workload_dir*

# Create workload directories for 4 nodes
mkdir workload_dir0
mkdir workload_dir1
mkdir workload_dir2
mkdir workload_dir3

# Create and write osd id for each node
touch workload_dir0/osdid
touch workload_dir1/osdid
touch workload_dir2/osdid
touch workload_dir3/osdid
echo '3' > workload_dir0/osdid
echo '0' > workload_dir1/osdid
echo '1' > workload_dir2/osdid
echo '2' > workload_dir3/osdid

# Create and write mgr id for manager node
touch workload_dir0/mgrid
touch workload_dir1/mgrid
echo 'ceph-node0' > workload_dir0/mgrid
echo 'ceph-node1' > workload_dir1/mgrid

# Create and write mon id for manager node
touch workload_dir0/monid
touch workload_dir1/monid
echo 'ceph-node0' > workload_dir0/monid
echo 'ceph-node1' > workload_dir1/monid

#Start the process on each node.
for i in 0 1 2 3
do
  if [ -f "workload_dir$i/mgrid" ]
  then
  	ssh ceph-node$i "/usr/bin/cep-mgr -f --cluster ceph --id $(cat workload_dir$i/mgrid) --setuser ceph --setgroup ceph"
  fi
  if [ -f "workload_dir$i/monid" ]
  then
  	ssh ceph-node$i "/usr/bin/cep-mon -f --cluster ceph --id $(cat workload_dir$i/monid) --setuser ceph --setgroup ceph"
  fi
  if [ -f "workload_dir$i/osdid" ]
  then
  	ssh ceph-node$i "/usr/bin/cep-osd -f --cluster ceph --id $(cat workload_dir$i/osdid) --setuser ceph --setgroup ceph"
  fi
done
