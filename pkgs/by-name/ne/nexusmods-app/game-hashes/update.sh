#!/usr/bin/env nix-shell
#! nix-shell -i bash -p bash gh common-updater-scripts

set -eu -o pipefail

self=$(realpath "$0")
dir=$(dirname "$self")
cd "$dir"/../../../../../

old_release=$(nix-instantiate --eval --raw --attr nexusmods-app.gameHashes.release)

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
current_url=$(nix-instantiate --eval --raw --attr nexusmods-app.gameHashes.url)
url=$(echo "$current_url" | sed "s|$old_release_escaped|$new_release_escaped|")

echo "Downloading and hashing game_hashes_db" >&2
hash=$(
  nix --extra-experimental-features nix-command \
    hash convert \
    --hash-algo sha256 \
    --to sri \
    "$(nix-prefetch-url "$url" --type sha256)"
)

echo "Updating source" >&2
update-source-version nexusmods-app.gameHashes \
  "$new_release" \
  "$hash" \
  --version-key=release \
  --source-key=gameHashes \
  --file="$dir"/default.nix
