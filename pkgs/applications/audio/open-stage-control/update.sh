#!/usr/bin/env nix-shell
#! nix-shell -i bash -p common-updater-scripts jq nodejs
set -euo pipefail

# Find nixpkgs repo
nixpkgs="$(git rev-parse --show-toplevel || (printf 'Could not find root of nixpkgs repo\nAre we running from within the nixpkgs git repo?\n' >&2; exit 1))"

stripwhitespace() {
    sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'
}

nixeval() {
    nix --extra-experimental-features nix-command eval --json --impure -f "$nixpkgs" "$1" | jq -r .
}

vendorhash() {
    (nix --extra-experimental-features nix-command build --impure -f "$nixpkgs" --no-link "$1" 2>&1 >/dev/null | tail -n3 | grep -F got: | cut -d: -f2- | stripwhitespace) 2>/dev/null || true
}

findpath() {
    path="$(nix --extra-experimental-features nix-command eval --json --impure -f "$nixpkgs" "$1.meta.position" | jq -r . | cut -d: -f1)"
    outpath="$(nix --extra-experimental-features nix-command eval --json --impure --expr "builtins.fetchGit \"$nixpkgs\"")"

    if [ -n "$outpath" ]; then
        path="${path/$(echo "$outpath" | jq -r .)/$nixpkgs}"
    fi

    echo "$path"
}

attr="${UPDATE_NIX_ATTR_PATH:-open-stage-control}"
version="$(cd "$nixpkgs" && list-git-tags --pname="$(nixeval "$attr".pname)" --attr-path="$attr" | grep '^v' | sed -e 's|^v||' | sort -V | tail -n1)"

pkgpath="$(findpath "$attr")"
pkgdir="$(dirname "$pkgpath")"

updated="$(cd "$nixpkgs" && update-source-version "$attr" "$version" --file="$pkgpath" --print-changes | jq -r length)"

if [ "$updated" -eq 0 ]; then
    echo 'update.sh: Package version not updated, nothing to do.'
    exit 0
fi

# Download package.json from the latest release
curl -sSL https://raw.githubusercontent.com/jean-emmanuel/open-stage-control/v"$version"/package.json | grep -v '"electron"\|"electron-installer-debian"' >"$pkgdir"/package.json

# Lock dependencies with npm
(cd "$pkgdir" && npm install --package-lock-only --ignore-scripts --legacy-peer-deps)

# Turn lock file into patch file
(cd "$pkgdir" && (diff -u /dev/null ./package-lock.json || [ $? -eq 1 ])) >"$pkgdir"/package-lock.json.patch

rm -f "$pkgdir"/{package.json,package-lock.json}

# Update FOD hash
curhash="$(nixeval "$attr.npmDeps.outputHash")"
newhash="$(vendorhash "$attr.npmDeps")"

if [ -n "$newhash" ] && [ "$curhash" != "$newhash" ]; then
    sed -i -e "s|\"$curhash\"|\"$newhash\"|" "$pkgpath"
else
    echo 'update.sh: New npmDepsHash same as old npmDepsHash, nothing to do.'
fi
