#! @bash@/bin/sh -e

export PATH=@nix@/bin:@bash@/bin:@coreutils@/bin:@findutils@/bin:@utillinux@/bin:@utillinux@/sbin:@sysvinit@/bin:@sysvinit@/sbin:@e2fsprogs@/bin:@e2fsprogs@/sbin

echo "remounting / read-only..."
mount -n -o remount,rw /dev/root / || echo "(failed)" # ignore errors

echo "syncing..."
sync || echo "(failed)" # ignore errors

echo "shutting down..."
halt -d -f
