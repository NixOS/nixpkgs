#!/bin/bash
# Udev helper to create aliases for whole-disk block devices (e.g.,
# /dev/disk/device-by-alias/root -> /dev/sda). We need this to point GRUB to the
# device where the root partition resides.
set -e

kernel_dev="${1?no kernel device name given}"
device="/dev/${kernel_dev}"
p="disk/device-by-alias"

lsblk -pP $device | while read line; do
    case $line in
        *MOUNTPOINT=\"/\"*)
            echo "${p}/root"
            exit;;
        *MOUNTPOINT=\"/tmp\"*)
            echo "${p}/tmp"
            exit;;
        *MOUNTPOINT=\"\[SWAP\]\"*)
            echo "${p}/swap"
            exit;;
    esac
done
