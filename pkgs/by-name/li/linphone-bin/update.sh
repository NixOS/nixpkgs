#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl common-updater-scripts

set -euo pipefail

URL="https://download.linphone.org/releases/linux/app/"
version=$(curl -s "$URL" | grep -oP 'Linphone-\K\d+\.\d+\.\d+(?=-x86_64\.AppImage)' | sort -V | tail -n 1)

if [[ -z "$version" ]]; then
  echo "Error: version not found"
  exit 1
fi

update-source-version linphone-bin "$version"
