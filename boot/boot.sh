#! @bash@/bin/sh -e

set -e

. @out@/bin/env.sh

echo "--- Nix ---"

echo "mounting /proc..."
mount -n -t proc none /proc

echo "checking /dev/root..."
e2fsck -y /dev/root || test "$?" -le 1

echo "remounting / writable..."
mount -n -o remount,rw /dev/root /

echo "mounting /mnt/host..."
mount -n -t hostfs none /mnt/host

echo "setting up hostname..."
hostname uml

echo "enabling loopback interface..."
ifconfig lo 127.0.0.1

echo "enabling ethernet interface..."
ifconfig eth0 $(cat /etc/networking/local-ip) up || true

echo "setting up routing table..."
route add default gw $(cat /etc/networking/gateway-ip) || true

echo "boot done."
