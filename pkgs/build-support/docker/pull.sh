source $stdenv/setup

mkdir -p /var/lib/docker
mkfs.ext4 /dev/vda
mount -t ext4 /dev/vda /var/lib/docker

modprobe virtio_net
dhclient eth0

mkdir -p /etc/ssl/certs/
cp "$certs" "/etc/ssl/certs/"

# from https://github.com/tianon/cgroupfs-mount/blob/master/cgroupfs-mount
mount -t tmpfs -o uid=0,gid=0,mode=0755 cgroup /sys/fs/cgroup
cd /sys/fs/cgroup
for sys in $(awk '!/^#/ { if ($4 == 1) print $1 }' /proc/cgroups); do
  mkdir -p $sys
  if ! mountpoint -q $sys; then
    if ! mount -n -t cgroup -o $sys cgroup $sys; then
      rmdir $sys || true
    fi
  fi
done

# run docker daemon
dockerd -H tcp://127.0.0.1:5555 -H unix:///var/run/docker.sock &

until $(curl --output /dev/null --silent --connect-timeout 2 http://127.0.0.1:5555); do
  printf '.'
  sleep 1
done

rm -r $out

docker pull ${imageId}
docker save ${imageId} > $out
