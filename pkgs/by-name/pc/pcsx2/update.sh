#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash nix-update common-updater-scripts coreutils jq

set -ex

latestPatchesRev=`git ls-remote -b https://github.com/PCSX2/pcsx2_patches main | cut -f1`

update-source-version pcsx2 \
  --ignore-same-version \
  --rev=$latestPatchesRev \
  --source-key=pcsx2_patches

latestVersion="`curl "https://api.github.com/repos/PCSX2/pcsx2/releases/latest" \
  | jq -r ".tag_name[1:]"`"

nix-update pcsx2 --version=$latestVersion
