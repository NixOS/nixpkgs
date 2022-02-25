#! /usr/bin/env nix-shell
#! nix-shell ../../update-shell.nix -i bash

set -eo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
if [[ $# -ne 1 ]]; then
    echo "Usage: ./update.sh <version>"
    exit 1
fi

echo "
FIXME: This script doesn't update patched lldb. Please manually check branches
of https://github.com/vadimcn/llvm-project and update lldb with correct version of LLVM.
"

# Ideally, nixpkgs points to default.nix file of Nixpkgs official tree
nixpkgs=../../../../../..
nixFile=./default.nix
owner=vadimcn
repo=vscode-lldb
version="$1"

sed -E 's/\bversion = ".*?"/version = "'$version'"/' --in-place "$nixFile"
srcHash=$(nix-prefetch fetchFromGitHub --owner vadimcn --repo vscode-lldb --rev "v$version")
sed -E 's#\bsha256 = ".*?"#sha256 = "'$srcHash'"#' --in-place "$nixFile"
cargoHash=$(nix-prefetch "{ sha256 }: (import $nixpkgs {}).vscode-extensions.vadimcn.vscode-lldb.adapter.cargoDeps.overrideAttrs (_: { outputHash = sha256; })")
sed -E 's#\bcargoSha256 = ".*?"#cargoSha256 = "'$cargoHash'"#' --in-place "$nixFile"

src="$(nix-build $nixpkgs -A vscode-extensions.vadimcn.vscode-lldb.src --no-out-link)"
oldDeps="$(jq '.dependencies' build-deps/package.json)"
newDeps="$(jq '.dependencies + .devDependencies' "$src/package.json")"
jq '{ name, version: $version, dependencies: (.dependencies + .devDependencies) }' \
    --arg version "$version" \
    "$src/package.json" \
    > build-deps/package.json

if [[ "$oldDeps" == "$newDeps" ]]; then
    echo "Dependencies not changed"
    sed '/"vscode-lldb-build-deps-/,+3 s/version = ".*"/version = "'"$version"'"/' \
        --in-place "$nixpkgs/pkgs/development/node-packages/node-packages.nix"
else
    echo "Dependencies changed"
    # Regenerate nodePackages.
    cd "$nixpkgs/pkgs/development/node-packages"
    exec ./generate.sh
fi
