#! @bash@/bin/sh -e

export PATH=@nix@/bin:@bash@/bin:@coreutils@/bin:@findutils@/bin:@utillinux@/bin:@utillinux@/sbin:@sysvinit@/bin:@sysvinit@/sbin:@e2fsprogs@/bin:@e2fsprogs@/sbin

echo "--- Nix ---"

echo "mounting /proc..."
mount -n -t proc none /proc

echo "checking /dev/root..."
e2fsck -y /dev/root || test "$?" -le 1

echo "remounting / writable..."
mount -n -o remount,rw /dev/root /

echo "mounting /mnt/host..."
mount -n -t hostfs none /mnt/host

echo "boot done."
