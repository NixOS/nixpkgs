#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gawk gnused nix

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

baseUrl="https://cli.coderabbit.ai/releases"

version=$(curl -fsSL "$baseUrl/latest/VERSION")
checksums=$(curl -fsSL "$baseUrl/$version/SHA256SUMS")

sed -i "s|version = \".*\";|version = \"$version\";|" package.nix

for platform in darwin-arm64 darwin-x64 linux-arm64 linux-x64; do
  hex=$(awk -v name="./coderabbit-$platform.zip" '$2 == name { print $1 }' <<<"$checksums")
  hash=$(nix --extra-experimental-features nix-command hash convert --hash-algo sha256 --to sri "$hex")
  sed -i "/platform = \"$platform\";/{n;s|hash = \".*\";|hash = \"$hash\";|}" package.nix
done
