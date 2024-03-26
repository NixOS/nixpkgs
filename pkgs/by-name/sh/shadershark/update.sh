#!/usr/bin/env nix-shell
#! nix-shell -i bash -p curl common-updater-scripts

set -e

repo_url="$1"; shift

data="$(curl "$repo_url/tags")"

rev="$(echo "$data" | grep '/rev/v' | sed 's;.*/rev/v\([^"]*\)[^$]*;\1;' | head -n 1)"
echo "new rev: $rev"

update-source-version shadershark "$rev" \
  --print-changes
