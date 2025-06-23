#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash nix-update common-updater-scripts coreutils

set -ex

latestRev=`git ls-remote -b https://github.com/PCSX2/pcsx2_patches main | cut -f1`

update-source-version pcsx2 \
  --ignore-same-version \
  --rev=$latestRev \
  --source-key=pcsx2_patches
nix-update --version=unstable pcsx2
