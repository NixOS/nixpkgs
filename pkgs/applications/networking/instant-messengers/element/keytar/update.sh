#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=../../../../../../ -i bash -p wget prefetch-yarn-deps yarn

if [ "$#" -gt 1 ] || [[ "$1" == -* ]]; then
  echo "Regenerates packaging data for the seshat package."
  echo "Usage: $0 [git release tag]"
  exit 1
fi

version="$1"

set -euo pipefail

if [ -z "$version" ]; then
  version="$(wget -O- "https://api.github.com/repos/atom/node-keytar/releases?per_page=1" | jq -r '.[0].tag_name')"
fi

# strip leading "v"
version="${version#v}"

SRC="https://raw.githubusercontent.com/atom/node-keytar/v$version"

wget "$SRC/package-lock.json"
wget "$SRC/package.json"
rm -f yarn.lock
yarn import
rm -rf node_modules package.json package-lock.json
yarn_hash=$(prefetch-yarn-deps yarn.lock)

src_hash=$(nix-prefetch-github atom node-keytar --rev v${version} | jq -r .sha256)

cat > pin.json << EOF
{
  "version": "$version",
  "srcHash": "$src_hash",
  "yarnHash": "$yarn_hash"
}
EOF
