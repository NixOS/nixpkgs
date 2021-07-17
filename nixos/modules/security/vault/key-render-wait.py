#!/usr/bin/env python3
# Waits for the specified keys to be created or modified

import sys
import argparse
import inotify_simple
from typing import List
from pathlib import Path

parser = argparse.ArgumentParser()
parser.add_argument("-t", "--temp-files", type=str, help="Temporary key filenames to watch", default="")
parser.add_argument("-s", "--sink-files", type=str, help="Sink key filenames to watch", default="")
parser.add_argument("-d", "--keydir", type=str, help="The location of the keys", default="/run/vault-keys")
parser.add_argument("-m", "--modify", action="store_true", help="Tracks modification rather than creation or deletion", default=False)
args = parser.parse_args()

EXIST_FLAGS = inotify_simple.flags.CREATE | inotify_simple.flags.MOVED_TO
MODIFY_FLAGS = EXIST_FLAGS | inotify_simple.flags.MODIFY | inotify_simple.flags.DELETE

# Wait for all keys to come into existence
def wait_for_existence(files: List[str]):
    root = Path(args.keydir)
    inotify = inotify_simple.INotify()
    inotify.add_watch(root, EXIST_FLAGS)

    exist_map = dict((k, root.joinpath(k).exists()) for k in files)

    while True:
        if all(exist_map.values()):
            break
        for event in inotify.read():
            if event.name in exist_map:
                exist_map[event.name] = True

    print("All keys now confirmed to be present.")

def wait_for_modification(files: List[str]):
    root = Path(args.keydir)
    inotify = inotify_simple.INotify()
    inotify.add_watch(root, MODIFY_FLAGS)

    while True:
        exit = False
        for event in inotify.read():
            if event.name in files:
                exit = True
        if exit:
            break

    print("Key modified or deleted. Process will now exit.")

# temporary key names are i.e ".sso-site-private.tmp"
temp_files = args.temp_files.split(",")
sink_files = args.sink_files.split(",")

root = Path(args.keydir)

if args.modify:
    wait_for_modification(temp_files)
else:
    if all(list(map(lambda f: root.joinpath(f).exists(), sink_files))):
        print("All sink files already present. Skipping existence check.")
        exit(0)
    wait_for_existence(temp_files)
