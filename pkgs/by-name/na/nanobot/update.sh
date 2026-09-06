#! /usr/bin/env nix-shell
#! nix-shell -I nixpkgs=./. -i bash -p git prefetch-npm-deps nix-update nodejs coreutils gnused
set -euo pipefail

attrPath=${UPDATE_NIX_ATTR_PATH:-nanobot}

# Locate this package's directory from meta.position, so the script works whether
# it is run in-place or from the Nix store.
position=$(nix-instantiate --eval --raw -E "with import ./. {}; $attrPath.meta.position")
pkgDir=$(dirname "${position%:*}")

# 1. Bump version and main source hash.
nix-update --version-regex '^v(0\.\d+\.\d+)$' "$attrPath"

# 2. Regenerate the WebUI lockfile. Upstream's committed package-lock.json is
#    missing most `resolved` URLs, which breaks the npm deps fetcher, so fill
#    them in with `npm install --package-lock-only`.
gitRepoUrl=$(nix-instantiate --eval --raw -E "with import ./. {}; $attrPath.src.gitRepoUrl")
tag=$(nix-instantiate --eval --raw -E "with import ./. {}; $attrPath.src.tag")

tmp=$(mktemp -d)
trap 'rm -rf -- "$tmp"' EXIT
git clone --depth 1 --branch "$tag" "$gitRepoUrl" "$tmp/src"

pushd "$tmp/src/webui"
npm install --package-lock-only --ignore-scripts
cp package-lock.json "$pkgDir/webui-package-lock.json"
popd

# 3. Recompute the npm deps hash (fetcher version 2, matching the package) and
#    write it back into package.nix.
npmDepsHash=$(NPM_FETCHER_VERSION=2 prefetch-npm-deps "$pkgDir/webui-package-lock.json")
sed -E -i 's#(npmDepsHash = ")[^"]*(")#\1'"$npmDepsHash"'\2#' "$pkgDir/package.nix"
