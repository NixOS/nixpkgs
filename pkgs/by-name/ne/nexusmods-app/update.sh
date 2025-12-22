#!/usr/bin/env nix-shell
#! nix-shell -i bash -p bash nix-update

set -eu -o pipefail

# Set a default attrpath to allow running this update script directly
export UPDATE_NIX_ATTR_PATH="${UPDATE_NIX_ATTR_PATH:-"nexusmods-app"}"

self=$(realpath "$0")
dir=$(dirname "$self")
cd "$dir"/../../../../

current_version=$(
  nix-instantiate --eval --raw \
    --attr "$UPDATE_NIX_ATTR_PATH.version"
)

url=$(
  nix-instantiate --eval --raw \
    --attr "$UPDATE_NIX_ATTR_PATH.meta.homepage"
)

nix-update --url "$url"

new_version=$(
  nix-instantiate --eval --raw \
    --attr "$UPDATE_NIX_ATTR_PATH.version"
)

if [ "$current_version" != "$new_version" ]; then
  # Update games.json
  "$dir"/update-games-json.sh

  # Update game_hashes_db
  UPDATE_NIX_ATTR_PATH="$UPDATE_NIX_ATTR_PATH.gameHashes" \
    "$dir"/game-hashes/update.sh
fi
