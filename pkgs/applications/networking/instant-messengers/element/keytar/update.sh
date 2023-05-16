#!/usr/bin/env nix-shell
<<<<<<< HEAD
#!nix-shell -I nixpkgs=../../../../../../ -i bash -p wget prefetch-npm-deps nix-prefetch-github
=======
#!nix-shell -I nixpkgs=../../../../../../ -i bash -p wget prefetch-npm-deps
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

if [ "$#" -gt 1 ] || [[ "$1" == -* ]]; then
  echo "Regenerates packaging data for the keytar package."
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
npm_hash=$(prefetch-npm-deps package-lock.json)
rm -rf node_modules package.json package-lock.json

<<<<<<< HEAD
src_hash=$(nix-prefetch-github atom node-keytar --rev v${version} | jq -r .hash)
=======
src_hash=$(nix-prefetch-github atom node-keytar --rev v${version} | jq -r .sha256)
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

cat > pin.json << EOF
{
  "version": "$version",
  "srcHash": "$src_hash",
  "npmHash": "$npm_hash"
}
EOF
