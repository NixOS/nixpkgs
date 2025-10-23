#!/usr/bin/env nix-shell
#! nix-shell -i bash -p bash nix-update

set -eu -o pipefail

# Set a default attrpath to allow running this update script directly
export UPDATE_NIX_ATTR_PATH="${UPDATE_NIX_ATTR_PATH:-"nexusmods-app"}"

self=$(realpath "$0")
dir=$(dirname "$self")
cd "$dir"/../../../../

# Update vendored files
"$dir"/vendored/update.sh

# Update game_hashes_db
UPDATE_NIX_ATTR_PATH="$UPDATE_NIX_ATTR_PATH.gameHashes" \
  "$dir"/game-hashes/update.sh

url=$(
  nix-instantiate --eval --raw \
    --attr "$UPDATE_NIX_ATTR_PATH.meta.homepage"
)
nix-update --url "$url"
