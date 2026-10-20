#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts curl jq
# shellcheck shell=bash

set -euo pipefail

scriptDir=$(cd "${BASH_SOURCE[0]%/*}" && pwd)
nixpkgs=$(realpath "$scriptDir"/../../../..)

echo >&2 "=== Obtaining the latest GitSquid release..."
version=$(curl -fsSL https://api.github.com/repos/TheMax98000/gitsquid-releases/releases/latest | jq -r '.tag_name | ltrimstr("v")')

declare -A appimages=(
  ["x86_64-linux"]="https://github.com/TheMax98000/gitsquid-releases/releases/download/v${version}/GitSquid_${version}_amd64.AppImage"
  ["aarch64-linux"]="https://github.com/TheMax98000/gitsquid-releases/releases/download/v${version}/GitSquid_${version}_aarch64.AppImage"
)

for arch in "${!appimages[@]}"; do
  echo >&2 "=== Downloading ${arch} package and computing its hash..."
  hash=$(nix-hash --to-sri --type sha256 "$(nix-prefetch-url "${appimages[${arch}]}")")
  echo >&2 "=== Updating package.nix for ${arch}..."
  (cd "$nixpkgs" && update-source-version gitsquid "$version" "$hash" --system="$arch" --ignore-same-version)
done

echo >&2 "=== Done!"
