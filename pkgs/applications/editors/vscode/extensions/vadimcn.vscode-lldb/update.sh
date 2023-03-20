#! /usr/bin/env nix-shell
#! nix-shell ../../update-shell.nix -i bash

set -eo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

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
if [[ $# -ne 1 ]]; then
    # no version specified, find the newest one
    version=$(
        curl -s "https://api.github.com/repos/$owner/$repo/releases" |
        jq 'map(select(.prerelease | not)) | .[0].tag_name' --raw-output |
        sed 's/[\"v]//'
    )
fi
old_version=$(sed -nE 's/.*\bversion = "(.*)".*/\1/p' ./default.nix)
if grep -q 'cargoSha256 = ""' ./default.nix; then
    old_version='broken'
fi
if [[ "$version" == "$old_version" ]]; then
    echo "Up to date: $version"
    exit
fi
echo "$old_version -> $version"

# update hashes
sed -E 's/\bversion = ".*?"/version = "'$version'"/' --in-place "$nixFile"
srcHash=$(nix-prefetch fetchFromGitHub --owner vadimcn --repo vscode-lldb --rev "v$version")
sed -E 's#\bsha256 = ".*?"#sha256 = "'$srcHash'"#' --in-place "$nixFile"
cargoHash=$(nix-prefetch "{ sha256 }: (import $nixpkgs {}).vscode-extensions.vadimcn.vscode-lldb.adapter.cargoDeps.overrideAttrs (_: { outputHash = sha256; })")
sed -E 's#\bcargoSha256 = ".*?"#cargoSha256 = "'$cargoHash'"#' --in-place "$nixFile"

# update node dependencies
src="$(nix-build $nixpkgs -A vscode-extensions.vadimcn.vscode-lldb.src --no-out-link)"
nix-shell -p node2nix -I nixpkgs=$nixpkgs --run "cd build-deps && ls -R && node2nix -14 -d -i \"$src/package.json\" -l \"$src/package-lock.json\""
