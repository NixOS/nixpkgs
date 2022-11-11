#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix curl libxml2 jq common-updater-scripts

set -euo pipefail

nixpkgs="$(git rev-parse --show-toplevel || (printf 'Could not find root of nixpkgs repo\nAre we running from within the nixpkgs git repo?\n' >&2; exit 1))"

attr="${UPDATE_NIX_ATTR_PATH:-touchosc}"
version="$(curl -sSL https://hexler.net/touchosc/appcast/linux | xmllint --xpath '/rss/channel/item/enclosure/@*[local-name()="version"]' - | cut -d= -f2- | tr -d '"' | head -n1)"

findpath() {
    path="$(nix --extra-experimental-features nix-command eval --json --impure -f "$nixpkgs" "$1.meta.position" | jq -r . | cut -d: -f1)"
    outpath="$(nix --extra-experimental-features nix-command eval --json --impure --expr "builtins.fetchGit \"$nixpkgs\"")"

    if [ -n "$outpath" ]; then
        path="${path/$(echo "$outpath" | jq -r .)/$nixpkgs}"
    fi

    echo "$path"
}

pkgpath="$(findpath "$attr")"

sed -i -e "/version\s*=/ s|\"$UPDATE_NIX_OLD_VERSION\"|\"$version\"|" "$pkgpath"

for system in aarch64-linux armv7l-linux x86_64-linux; do
    url="$(nix --extra-experimental-features nix-command eval --json --impure --argstr system "$system" -f "$nixpkgs" "$attr".src.url | jq -r .)"

    curhash="$(nix --extra-experimental-features nix-command eval --json --impure --argstr system "$system" -f "$nixpkgs" "$attr".src.outputHash | jq -r .)"
    newhash="$(nix --extra-experimental-features nix-command store prefetch-file --json "$url" | jq -r .hash)"

    sed -i -e "s|\"$curhash\"|\"$newhash\"|" "$pkgpath"
done
