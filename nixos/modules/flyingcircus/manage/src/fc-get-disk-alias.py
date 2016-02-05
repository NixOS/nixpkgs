"""Retrieve an alias for a disk device (not a partition).

This detects the typical Flying Circus disk roles: root, tmp, and swap.

Provides an alias for udev to link to, resulting in e.g.
/dev/disk/device-by-alias/root

"""
import sys
import subprocess
import os.path
import re

if len(sys.argv) != 2:
    sys.exit()

kernel_name = sys.argv[1]

if not re.fullmatch('[a-z]+', kernel_name):
    sys.exit()

device_path = '/dev/{}'.format(kernel_name)
if not os.path.exists(device_path):
    sys.exit()


def check_root(line):
    if 'MOUNTPOINT="/"' in line:
        return 'root'


def check_tmp(line):
    if 'MOUNTPOINT="/tmp"' in line:
        return 'tmp'


def check_swap(line):
    if 'MOUNTPOINT="[SWAP]"' in line:
        return 'swap'


diskinfo = subprocess.check_output(
    ['lsblk', '-pP', device_path]).decode('ascii')

for line in diskinfo.splitlines():
    for candidate in [check_root, check_tmp, check_swap]:
        alias = candidate(line)
        if alias:
            print('disk/device-by-alias/{}'.format(alias))
            sys.exit()
