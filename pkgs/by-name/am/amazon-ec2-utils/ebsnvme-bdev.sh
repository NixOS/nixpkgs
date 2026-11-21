#!/usr/bin/env bash
# Prints the device name an EBS volume is attached as, such as xvda, as ebsnvme-id -u does.

# ebsnvme-id waits up to the kernel's default admin command timeout, 60 seconds.
id_ctrl=$(@timeout@ 60 @nvme@ amzn id-ctrl "$1") || exit
while read -r field _ value; do
  case $field in
    vid) vid=$value ;;
    bdev) bdev=${value#/dev/} ;;
  esac
done <<<"$id_ctrl"
@logger@ -t ebsnvme-bdev "$1: vid=$vid bdev=$bdev" || :
[[ $vid == 0x1d0f && -n $bdev ]] && echo "$bdev"
