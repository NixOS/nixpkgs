#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gawk gnused jq

set -euo pipefail

version="$(curl --silent "https://api.github.com/repos/aptakube/aptakube/tags" | jq '.[0].name' --raw-output)"
checksums="$(curl -L --silent "https://github.com/aptakube/aptakube/releases/download/$version/checksums.txt")"

get_hash() {
  echo "$checksums" | awk "/$1/ {print \$1}" | xargs nix-hash --type sha256 --to-sri
}

linux_hash=$(get_hash "aptakube_${version}_amd64.deb")
darwin_hash=$(get_hash "Aptakube_${version}_universal.dmg")

sed -i "s|version = \"[0-9.]*\"|version = \"${version}\"|" pkgs/by-name/ap/aptakube/package.nix
sed -i "s|sha256 = \".*\"|sha256 = \"${linux_hash}\"|" pkgs/by-name/ap/aptakube/linux.nix
sed -i "s|sha256 = \".*\"|sha256 = \"${darwin_hash}\"|" pkgs/by-name/ap/aptakube/darwin.nix
