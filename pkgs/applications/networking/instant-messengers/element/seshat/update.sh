#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=../ -i bash -p wget yarn2nix

set -euo pipefail

if [ "$#" -ne 1 ] || [[ "$1" == -* ]]; then
  echo "Regenerates the Yarn dependency lock files."
  echo "Usage: $0 <git release tag>"
  exit 1
fi

SRC="https://raw.githubusercontent.com/matrix-org/seshat/$1"

wget "$SRC/seshat-node/yarn.lock"
yarn2nix > yarn.nix
rm yarn.lock
