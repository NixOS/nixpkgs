#! @bash@/bin/sh -e

. @out@/bin/env.sh

echo "remounting / read-only..."
mount -n -o remount,rw /dev/root / || echo "(failed)" # ignore errors

echo "syncing..."
sync || echo "(failed)" # ignore errors

echo "shutting down..."
halt -d -f
