#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix jq common-updater-scripts

set -euo pipefail

nixpkgs="$(git rev-parse --show-toplevel || (printf 'Could not find root of nixpkgs repo\nAre we running from within the nixpkgs git repo?\n' >&2; exit 1))"

stripwhitespace() {
    sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'
}

nixeval() {
    nix --extra-experimental-features nix-command eval --json --impure -f "$nixpkgs" "$1" | jq -r .
}

vendorhash() {
    (nix --extra-experimental-features nix-command build --impure --argstr nixpkgs "$nixpkgs" --argstr attr "$1" --expr '{ nixpkgs, attr }: let pkgs = import nixpkgs {}; in with pkgs.lib; (getAttrFromPath (splitString "." attr) pkgs).overrideAttrs (attrs: { outputHash = fakeHash; })' --no-link 2>&1 >/dev/null | tail -n3 | grep -F got: | cut -d: -f2- | stripwhitespace) 2>/dev/null || true
}

findpath() {
    path="$(nix --extra-experimental-features nix-command eval --json --impure -f "$nixpkgs" "$1.meta.position" | jq -r . | cut -d: -f1)"
    outpath="$(nix --extra-experimental-features nix-command eval --json --impure --expr "builtins.fetchGit \"$nixpkgs\"")"

    if [ -n "$outpath" ]; then
        path="${path/$(echo "$outpath" | jq -r .)/$nixpkgs}"
    fi

    echo "$path"
}

attr="${UPDATE_NIX_ATTR_PATH:-teams-for-linux}"
version="$(cd "$nixpkgs" && list-git-tags --pname="$(nixeval "$attr".pname)" --attr-path="$attr" | grep '^v' | sed -e 's|^v||' | sort -V | tail -n1)"

pkgpath="$(findpath "$attr")"

updated="$(cd "$nixpkgs" && update-source-version "$attr" "$version" --file="$pkgpath" --print-changes | jq -r length)"

if [ "$updated" -eq 0 ]; then
    echo 'update.sh: Package version not updated, nothing to do.'
    exit 0
fi

curhash="$(nixeval "$attr.offlineCache.outputHash")"
newhash="$(vendorhash "$attr.offlineCache")"

if [ -n "$newhash" ] && [ "$curhash" != "$newhash" ]; then
    sed -i -e "s|\"$curhash\"|\"$newhash\"|" "$pkgpath"
else
    echo 'update.sh: New vendorHash same as old vendorHash, nothing to do.'
fi
