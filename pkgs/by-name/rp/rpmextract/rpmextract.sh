#!@shell@ -e
# shellcheck shell=bash

if [ "$1" = "" ]; then
  echo "usage: rpmextract package_name..." 1>&2
  exit 1
fi

for i in "$@"; do
  @rpm@/bin/rpm2cpio "$i" | @cpio@/bin/cpio -idv
done
