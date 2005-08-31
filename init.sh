#! @bash@/bin/sh -e

exec ./fill-disk.sh | @coreutils@/bin/tee /tmp/install-log
