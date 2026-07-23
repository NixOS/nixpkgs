#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl xq-xml common-updater-scripts

set -eu

ROOT="$(dirname "$(readlink -f "$0")")"
NIX_DRV="$ROOT/package.nix"
if [ ! -f "$NIX_DRV" ]; then
  echo "ERROR: cannot find package.nix in $ROOT"
  exit 1
fi

LATEST_VERSION="$(curl -Ls https://www.mowglii.com/itsycal/versionhistory.html | xq -m -q 'h4' -a 'id' | head -n1)"

if [ -z "$LATEST_VERSION" ]; then
    echo "ERROR: Failed to scrape the latest version."
    exit 1
fi

update-source-version itsycal "$LATEST_VERSION" --file="$NIX_DRV"
