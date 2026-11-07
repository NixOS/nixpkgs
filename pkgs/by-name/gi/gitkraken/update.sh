#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts curl jq

set -euo pipefail

scriptDir=$(cd "${BASH_SOURCE[0]%/*}" && pwd)
nixpkgs=$(realpath "$scriptDir"/../../../..)

# All architectures are released together, therefore we get the latest version from the Linux x86_64 release
echo >&2 "=== Obtaining latest version..."
version=$(curl -fsSL https://api.gitkraken.dev/releases/production/linux/x64/RELEASES | jq -r '.name')
echo >&2 "Latest version: $version"

# Hardcoded URLs to compute hashes
declare -A tarballs=(
  ["x86_64-linux"]="https://api.gitkraken.dev/releases/production/linux/x64/${version}/gitkraken-amd64.tar.gz"
  ["aarch64-linux"]="https://api.gitkraken.dev/releases/production/linux/arm64/${version}/gitkraken-aarch64.tar.gz"
  ["aarch64-darwin"]="https://api.gitkraken.dev/releases/production/darwin/arm64/${version}/GitKraken-v${version}.zip"
)

for system in "${!tarballs[@]}"; do
  # We precalculate the hash before calling update-source-version because it attempts to calculate each architecture's
  # package's hash by running `nix-build --system <architecture> -A gitkraken.src` which causes cross compiling headaches
  echo >&2 "=== Downloading ${system} package and computing its hash..."
  hash=$(nix-hash --sri --type sha256 "$(nix-prefetch-url --print-path --unpack "${tarballs[${system}]}" | tail -n1)")
  echo >&2 "=== Updating package.nix for ${system}..."
  # update-source-version expects to be at the root of nixpkgs
  (cd "${nixpkgs}" && update-source-version gitkraken "${version}" "${hash}" --system="${system}" --ignore-same-version)
done

echo >&2 "=== Done!"
