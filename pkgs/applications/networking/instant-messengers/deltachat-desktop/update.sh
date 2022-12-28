#! /usr/bin/env nix-shell
#! nix-shell -i bash -p coreutils curl gnused jq moreutils nix-prefetch prefetch-npm-deps

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

hash=$(nix-prefetch -f "$nixpkgs" deltachat-desktop --rev "$rev")
tac default.nix \
    | sed -e "0,/version = \".*\"/s//version = \"$ver\"/" \
          -e "0,/hash = \".*\"/s//hash = \"${hash//\//\\/}\"/" \
    | tac \
    | sponge default.nix

src=$(nix-build "$nixpkgs" -A deltachat-desktop.src --no-out-link)
hash=$(prefetch-npm-deps $src/package-lock.json)
sed -i "s,npmDepsHash = \".*\",npmDepsHash = \"$hash\"," default.nix
