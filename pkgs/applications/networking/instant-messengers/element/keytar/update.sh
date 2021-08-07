#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=../ -i bash -p wget yarn2nix yarn

set -euo pipefail

if [ "$#" -ne 1 ] || [[ "$1" == -* ]]; then
  echo "Regenerates the Yarn dependency lock files."
  echo "Usage: $0 <git release tag>"
  exit 1
fi

SRC="https://raw.githubusercontent.com/atom/node-keytar/$1"

wget "$SRC/package-lock.json"
wget "$SRC/package.json"
rm -f yarn.lock
yarn import
yarn2nix > yarn.nix
rm -rf node_modules package.json package-lock.json
