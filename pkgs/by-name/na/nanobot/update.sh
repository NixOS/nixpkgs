#! /usr/bin/env nix-shell
#! nix-shell -I nixpkgs=./. -i bash -p git prefetch-npm-deps nix-update nodejs coreutils gnused
set -euo pipefail

attrPath=${UPDATE_NIX_ATTR_PATH:-nanobot}

position=$(nix-instantiate --eval --raw -E "with import ./. {}; $attrPath.meta.position")
pkgDir=$(dirname "${position%:*}")

nix-update --version-regex '^v(0\.\d+\.\d+)$' "$attrPath"

gitRepoUrl=$(nix-instantiate --eval --raw -E "with import ./. {}; $attrPath.src.gitRepoUrl")
tag=$(nix-instantiate --eval --raw -E "with import ./. {}; $attrPath.src.tag")

tmp=$(mktemp -d)
trap 'rm -rf -- "$tmp"' EXIT
git clone --depth 1 --branch "$tag" "$gitRepoUrl" "$tmp/src"

pushd "$tmp/src/webui"
rm package-lock.json
npm install --package-lock-only --ignore-scripts
cp package-lock.json "$pkgDir/webui-package-lock.json"
popd

npmDepsHash=$(NPM_FETCHER_VERSION=2 prefetch-npm-deps "$pkgDir/webui-package-lock.json")
sed -E -i 's#(npmDepsHash = ")[^"]*(")#\1'"$npmDepsHash"'\2#' "$pkgDir/package.nix"
