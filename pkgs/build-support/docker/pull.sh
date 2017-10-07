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

until docker ps 2>/dev/null; do
  printf '.'
  sleep 1
done

rm -r $out

docker pull ${imageId}

# Save & extract the image. We need to fix the timestamps of the _outer_ layer.
mkdir archive
docker save ${imageId} | tar -x -C archive

LAST_LAYER_ID=$(jq '.[0].Layers[-1]' -r < archive/manifest.json | awk -F'/' '{ print $1 }')

# Reset that outer layer's timestamp to 1
# Use -h to change the symlink in the outer layer to the layer.tar.
touch -h -t 197001010000.01 archive/$LAST_LAYER_ID{,/*}

# Repackage
cd archive
tar -c * > $out
