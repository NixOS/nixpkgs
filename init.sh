#! @bash@/bin/sh -e

export PATH=/bin:/sbin:@bash@/bin:@findutils@/bin:@busybox@/bin:@busybox@/sbin:@e2fsprogs@/sbin:@grub@/sbin:@sysvinitPath@/sbin:@eject@/bin:@dhcp@/sbin:@modutils@/sbin

echo mounting special filesystems

mount -t proc proc /proc
mount -t sysfs sys /sys

# make a complete /dev filesystem
# ripped permissions and everything from anaconda (loader2/devices.h)

echo making device nodes

# consoles

#mknod -m 0600 /dev/console c 5 1
mknod -m 0600 /dev/ttyS0 c 4 64
mknod -m 0600 /dev/ttyS1 c 4 65
mknod -m 0600 /dev/ttyS2 c 4 66
mknod -m 0600 /dev/ttyS3 c 4 67

# base UNIX devices
mknod -m 0600 /dev/mem c 1 1
mknod -m 0666 /dev/null c 1 3
mknod -m 0666 /dev/zero c 1 5

# tty
mknod -m 0600 /dev/tty c 5 0
mknod -m 0600 /dev/tty0 c 4 0
mknod -m 0600 /dev/tty1 c 4 1
mknod -m 0600 /dev/tty2 c 4 2
mknod -m 0600 /dev/tty3 c 4 3
mknod -m 0600 /dev/tty4 c 4 4
mknod -m 0600 /dev/tty5 c 4 5
mknod -m 0600 /dev/tty6 c 4 6
mknod -m 0600 /dev/tty7 c 4 7
mknod -m 0600 /dev/tty8 c 4 8
mknod -m 0600 /dev/tty9 c 4 9

mkdir -m 0755 /dev/pts
mknod -m 0666 /dev/ptmx c 5 2

# random

mknod -m 0644 /dev/random c 1 8
mknod -m 0644 /dev/urandom c 1 9

mknod -m 0660 /dev/hda b 3 0
mknod -m 0660 /dev/hda1 b 3 1
mknod -m 0660 /dev/hda2 b 3 2
mknod -m 0660 /dev/hda3 b 3 3

mknod -m 0660 /dev/hdb b 3 64
mknod -m 0660 /dev/hdb1 b 3 65
mknod -m 0660 /dev/hdb2 b 3 66
mknod -m 0660 /dev/hdb3 b 3 67

mknod -m 0660 /dev/hdc b 22 0
mknod -m 0660 /dev/hdc1 b 22 1
mknod -m 0660 /dev/hdc2 b 22 2
mknod -m 0660 /dev/hdc3 b 22 3

mknod -m 0660 /dev/hdd b 22 64
mknod -m 0660 /dev/hdd1 b 22 65
mknod -m 0660 /dev/hdd2 b 22 66
mknod -m 0660 /dev/hdd3 b 22 67

#mknod -m 0660 /dev/sda b 8 0
#mknod -m 0660 /dev/sda1 b 8 1
#mknod -m 0660 /dev/sda2 b 8 2
#mknod -m 0660 /dev/sda3 b 8 3

mknod -m 0600 /dev/initctl p

echo starting emergency shell on tty2

exec ./ramdisk-login.sh /dev/tty2 &
exec ./login.sh
