#! @bash@/bin/sh -e

. @out@/bin/env.sh

echo "unmount file systems..."
umount -avt noproc,nonfs,nosmbfs,nodevfs || echo "(failed)" # ignore errors

echo "syncing..."
sync || echo "(failed)" # ignore errors

echo "shutting down..."
halt -d -f
