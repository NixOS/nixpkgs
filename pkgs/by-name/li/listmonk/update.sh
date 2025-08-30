#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=../../../../ -i bash -p nix coreutils gnused curl jq nurl prefetch-yarn-deps

if [ "$#" -gt 1 ] || [[ "$1" == -* ]]; then
  echo "Regenerates packaging data for listmonk."
  echo "Usage: $0 [git release tag]"
  exit 1
fi

version=$(echo "$1" | tr -d v)

set -euo pipefail

if [ -z "$version" ]; then
  version="$(curl "https://api.github.com/repos/knadh/listmonk/releases?per_page=1" | jq -r '.[0].tag_name' | tr -d v)"
fi

src="https://raw.githubusercontent.com/knadh/listmonk/v$version"
src_hash=$(nurl -H https://github.com/knadh/listmonk v${version})
yarn_hash=$(prefetch-yarn-deps <(curl -o - "$src/frontend/yarn.lock"))
yarn_hash=$(nix-hash --type sha256 --to-sri "$yarn_hash")

cat > pin.json << EOF
{
  "version": "$version",
  "hash": "$src_hash",
  "vendorHash": "#REPLACE#",
  "yarnHash": "$yarn_hash"
}
EOF

vendor_hash=$(nurl -e "(import ../../../../default.nix { }).listmonk.goModules")
sed -i "s/#REPLACE#/$vendor_hash/" pin.json
