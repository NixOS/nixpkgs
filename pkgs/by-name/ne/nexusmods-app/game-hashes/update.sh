#!/usr/bin/env nix-shell
#! nix-shell -i bash -p bash common-updater-scripts gh

set -eu -o pipefail

# Set a default attrpath to allow running this update script directly
export UPDATE_NIX_ATTR_PATH="${UPDATE_NIX_ATTR_PATH:-"nexusmods-app.gameHashes"}"

self=$(realpath "$0")
dir=$(dirname "$self")
cd "$dir"/../../../../../

old_release=$(
  nix-instantiate --eval --raw \
    --attr "$UPDATE_NIX_ATTR_PATH.release"
)

echo "Looking up latest game_hashes_db" >&2
new_release=$(
  gh --repo Nexus-Mods/game-hashes \
    release list \
    --limit 1 \
    --exclude-drafts \
    --exclude-pre-releases \
    --json tagName \
    --jq .[].tagName
)

echo "Latest release is $new_release" >&2

if [ "$old_release" = "$new_release" ]; then
  echo "Already up to date"
  exit
fi

old_release_escaped=$(echo "$old_release" | sed 's#[$^*\\.[|]#\\&#g')
new_release_escaped=$(echo "$new_release" | sed 's#[$^*\\.[|]#\\&#g')
url=$(
  nix-instantiate --eval --raw --attr "$UPDATE_NIX_ATTR_PATH.url" |
    sed "s|$old_release_escaped|$new_release_escaped|"
)

echo "Downloading and hashing game_hashes_db" >&2
hash=$(
  nix --extra-experimental-features nix-command \
    hash convert --hash-algo sha256 --to sri \
    "$(nix-prefetch-url "$url" --type sha256)"
)

echo "Updating source" >&2
update-source-version \
  "$UPDATE_NIX_ATTR_PATH" \
  "$new_release" \
  "$hash" \
  --version-key=release \
  --file="$dir"/default.nix
