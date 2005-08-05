#! @bash@/bin/sh -e

export PATH=@bash@/bin:@coreutils@/bin:@findutils@/bin:@utillinux@/bin:@utillinux@/sbin:@e2fsprogs@/sbin

sysvinitPath=@sysvinitPath@
bootPath=@bootPath@

mount -t proc proc /proc
mount -t sysfs sys /sys

#mount -t /dev/hdc /installimage

# make a complete /dev filesystem
# ripped permissions and everything from anaconda (loader2/devices.h)

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

#mknod -m 0660 /dev/sda b 8 0
#mknod -m 0660 /dev/sda1 b 8 1
#mknod -m 0660 /dev/sda2 b 8 2
#mknod -m 0660 /dev/sda3 b 8 3

echo "dev"
cd /dev; echo *

mkfs.ext2 /dev/hda1
mkswap /dev/hda2

## Probe for CD device which contains our CD here and mount /nix and
## /nixpkgs from it inside the ramdisk. Anaconda uses kudzu for this.
## Find out how Knoppix and SUSE do this...

$(./install-disk.sh)
