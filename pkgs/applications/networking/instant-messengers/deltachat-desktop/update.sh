#! /usr/bin/env nix-shell
#! nix-shell -i bash -p coreutils curl gnused jq moreutils nix-prefetch
# shellcheck shell=bash

set -euo pipefail
cd "$(dirname "$0")"

owner=deltachat
repo=deltachat-desktop
nixpkgs=../../../../..

rev=$(
    curl -s "https://api.github.com/repos/$owner/$repo/releases" |
    jq 'map(select(.prerelease | not)) | .[0].tag_name' --raw-output
)
ver=$(echo "$rev" | sed 's/^v//')
old_ver=$(tac default.nix | sed -n 's/.*\bversion = "\(.*\)".*/\1/p' | head -1)
if [ "$ver" = "$old_ver" ]; then
    echo "Up to date: $ver"
    exit
fi
echo "$old_ver -> $ver"

sha256=$(nix-prefetch -f "$nixpkgs" deltachat-desktop --rev "$rev")
tac default.nix \
    | sed -e "0,/version = \".*\"/s//version = \"$ver\"/" \
          -e "0,/sha256 = \".*\"/s//sha256 = \"$sha256\"/" \
    | tac \
    | sponge default.nix

src=$(nix-build "$nixpkgs" -A deltachat-desktop.src --no-out-link)

jq '{ name, version, dependencies: (.dependencies + (.devDependencies | del(.["@typescript-eslint/eslint-plugin","@typescript-eslint/parser","esbuild","electron-builder","electron-devtools-installer","electron-notarize","esbuild","eslint","eslint-config-prettier","eslint-plugin-react-hooks","hallmark","prettier","tape","testcafe","testcafe-browser-provider-electron","testcafe-react-selectors","walk"]))) }' \
    "$src/package.json" > package.json.new

if cmp --quiet package.json{.new,}; then
    echo "package.json not changed, skip updating nodePackages"
    rm package.json.new
else
    echo "package.json changed, updating nodePackages"
    mv package.json{.new,}

    pushd ../../../../development/node-packages
    ./generate.sh
    popd
fi
