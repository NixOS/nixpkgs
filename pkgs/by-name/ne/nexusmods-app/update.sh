#!/usr/bin/env nix-shell
#! nix-shell -i bash -p bash nix-update

set -eu -o pipefail

self=$(realpath "$0")
dir=$(dirname "$self")
cd "$dir"/../../../../

"$dir"/vendored/update.sh
"$dir"/game-hashes/update.sh

url=$(nix-instantiate --eval --raw --attr nexusmods-app.meta.homepage)

nix-update nexusmods-app --url "$url"
