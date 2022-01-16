#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=../../../../../ -i bash -p curl

set -euo pipefail

if [ "$#" -ne 1 ] || [[ "$1" == -* ]]; then
  echo "Pre-downloads the policy and AutoConfig file for mobile-config-firefox."
  echo "Usage: $0 <git release tag>"
  exit 1
fi

SRC_REPO="https://gitlab.com/postmarketOS/mobile-config-firefox/-/raw/$1"

curl "$SRC_REPO/src/policies.json" > policies.json
echo "# Run generate.sh to update this file" > policies.nix
nix-instantiate --eval -E "with builtins; fromJSON (readFile ./policies.json) // { version = \"$1\"; }" >> policies.nix
rm policies.json
