#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts curl jq

set -euo pipefail

scriptDir=$(cd "${BASH_SOURCE[0]%/*}" && pwd)
nixpkgs=$(realpath "$scriptDir"/../../../..)

# All architectures are released together, therefore we get the latest version from the linux release
# NOTE: for some reason, the darwin RELEASES (ie. /darwin/RELEASES) file returns a frozen version...
echo >&2 "=== Obtaining version data from release.axocdn.com..."
version=$(curl -fsSL https://api.gitkraken.dev/releases/production/linux/x64/RELEASES | jq -r '.name')

# Hardcoded URLs to compute hashes
declare -A tarballs=(
  ["x86_64-linux"]="https://api.gitkraken.dev/releases/production/linux/x64/${version}/gitkraken-amd64.tar.gz"
  ["x86_64-darwin"]="https://api.gitkraken.dev/releases/production/darwin/x64/${version}/GitKraken-v${version}.zip"
  ["aarch64-darwin"]="https://api.gitkraken.dev/releases/production/darwin/arm64/${version}/GitKraken-v${version}.zip"
)

for arch in "${!tarballs[@]}"; do
  # We precalculate the hash before calling update-source-version because it attempts to calculate each architecture's
  # package's hash by running `nix-build --system <architecture> -A gitkraken.src` which causes cross compiling headaches
  echo >&2 "=== Downloading ${arch} package and computing its hash..."
  hash=$(nix-hash --sri --type sha256 "$(nix-prefetch-url --print-path --unpack "${tarballs[${arch}]}" | tail -n1)")
  echo >&2 "=== Updating package.nix for ${arch}..."
  # update-source-version expects to be at the root of nixpkgs
  (cd "${nixpkgs}" && update-source-version gitkraken "${version}" "${hash}" --system="${arch}" --ignore-same-version)
done

echo >&2 "=== Done!"
