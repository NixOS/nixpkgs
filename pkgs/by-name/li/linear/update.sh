#!/usr/bin/env nix-shell
#!nix-shell -i bash -p coreutils curl gnugrep jq common-updater-scripts
#shellcheck shell=bash

set -euo pipefail

releases_url="https://releases.linear.app"
version_pattern='filename="Linear-\K[0-9]+(\.[0-9]+)*(?=-universal\.dmg")'
version="$(curl -fsSLI "$releases_url/mac" | grep -ioP "$version_pattern")"

if [[ -z $version ]]; then
  echo "Could not find the latest Linear version in release headers" >&2
  exit 1
fi

hash="$(nix store prefetch-file --json "$releases_url/Linear-${version}-universal.dmg" | jq -r .hash)"

update-source-version linear "$version" "$hash" --ignore-same-version
