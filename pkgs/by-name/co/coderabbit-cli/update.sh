#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gawk gnused nix

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

baseUrl="https://cli.coderabbit.ai/releases"
platforms=(darwin-arm64 darwin-x64 linux-arm64 linux-x64)

version=$(curl -fsSL "$baseUrl/latest/VERSION")
checksums=$(curl -fsSL "$baseUrl/$version/SHA256SUMS")

# Resolve every hash before touching package.nix so a partial release can't leave it half-updated
declare -A hashes
for platform in "${platforms[@]}"; do
  hex=$(awk -v name="./coderabbit-$platform.zip" '$2 == name { print $1 }' <<<"$checksums")
  if [[ ! "$hex" =~ ^[0-9a-f]{64}$ ]]; then
    echo "error: no valid SHA-256 for coderabbit-$platform.zip in $version SHA256SUMS" >&2
    exit 1
  fi
  hashes[$platform]=$(nix --extra-experimental-features nix-command hash convert --hash-algo sha256 --to sri "$hex")
done

sed -i "s|version = \".*\";|version = \"$version\";|" package.nix
for platform in "${platforms[@]}"; do
  sed -i "/platform = \"$platform\";/{n;s|hash = \".*\";|hash = \"${hashes[$platform]}\";|}" package.nix
done
