#! /usr/bin/env nix-shell
#! nix-shell ../../update-shell.nix -i bash -p nix-prefetch-github prefetch-npm-deps

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
        curl -sL "https://api.github.com/repos/$owner/$repo/releases" |
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
fi
echo "$old_version -> $version"

# update hashes
sed -E 's/\bversion = ".*?"/version = "'$version'"/' --in-place "$nixFile"
srcHash=$(nix-prefetch-github vadimcn vscode-lldb --rev "v$version" | jq --raw-output .sha256)
sed -E 's#\bsha256 = ".*?"#sha256 = "'$srcHash'"#' --in-place "$nixFile"
cargoHash=$(nix-prefetch "{ sha256 }: (import $nixpkgs {}).vscode-extensions.vadimcn.vscode-lldb.adapter.cargoDeps.overrideAttrs (_: { outputHash = sha256; })")
sed -E 's#\bcargoSha256 = ".*?"#cargoSha256 = "'$cargoHash'"#' --in-place "$nixFile"

pushd $TMPDIR
curl -LO https://raw.githubusercontent.com/$owner/$repo/v${version}/package-lock.json
npmDepsHash=$(prefetch-npm-deps ./package-lock.json)
popd
sed -E 's#\bnpmDepsHash = ".*?"#npmDepsHash = "'$npmDepsHash'"#' --in-place "$nixFile"

