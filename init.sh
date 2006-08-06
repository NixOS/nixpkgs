#! @bash@/bin/sh -e

exec ./fill-disk.sh | @busybox@/bin/tee /tmp/install-log
