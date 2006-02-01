#! @bash@/bin/sh -e

set -e

. @out@/bin/env.sh

echo "--- Nix ---"

echo "mounting /proc..."
mount -n -t proc none /proc

echo "mounting /sys..."
mount -n -t sysfs none /sys

echo "mounting /dev/pts..."
mount -n -t devpts none /dev/pts

#echo "checking /dev/root..."
#e2fsck -y /dev/root || test "$?" -le 1

echo "remounting / writable..."
mount -n -o remount,rw /dev/root /

echo "starting udev..."
@udev@/sbin/udevstart

echo "setting up hostname..."
hostname nixos

echo "cleaning utmp and wtmp..."
echo "" > /var/run/utmp
echo "" > /var/log/wtmp

echo "setting hotplug..."
cat /etc/sysconfig/hotplug > /proc/sys/kernel/hotplug

echo "loading USB controller modules..."
@module_init_tools@/sbin/modprobe uhci-hcd

echo "enabling loopback interface..."
ifconfig lo 127.0.0.1

echo "enabling ethernet interface..."
ifconfig eth0 $(cat /etc/networking/local-ip) up || true

echo "setting up routing table..."
route add default gw $(cat /etc/networking/gateway-ip) || true

echo "boot done."
