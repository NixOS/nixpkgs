#! /usr/bin/env nix-shell
#! nix-shell -i bash -p gnused jq nix-prefetch-github nodejs prefetch-npm-deps wget

set -euo pipefail
pushd "$(dirname "${BASH_SOURCE[0]}")"

version=$(npm view node-gyp version)

if [[ "$UPDATE_NIX_OLD_VERSION" == "$version" ]]; then
    echo "Already up to date!"
    exit 0
fi

sed -i 's#version = "[^"]*"#version = "'"$version"'"#' package.nix

src_hash=$(nix-prefetch-github nodejs node-gyp --rev "v$version" | jq --raw-output .hash)
sed -i 's#hash = "[^"]*"#hash = "'"$src_hash"'"#' package.nix

rm -f package-lock.json package.json
wget "https://github.com/nodejs/node-gyp/raw/v$version/package.json"
npm i --package-lock-only --ignore-scripts
npm_hash=$(prefetch-npm-deps package-lock.json)
sed -i 's#npmDepsHash = "[^"]*"#npmDepsHash = "'"$npm_hash"'"#' package.nix
rm package.json

popd
