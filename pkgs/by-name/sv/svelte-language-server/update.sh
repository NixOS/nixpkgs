#! /usr/bin/env nix-shell
#! nix-shell -i bash -p gnused nix nodejs prefetch-npm-deps wget

set -euo pipefail
SCRIPT_DIRECTORY=$(cd $(dirname ${BASH_SOURCE[0]}); cd -P $(dirname $(readlink ${BASH_SOURCE[0]} || echo .)); pwd)

pushd "${SCRIPT_DIRECTORY}"

version=$(npm view svelte-language-server version)
tarball="svelte-language-server-$version.tgz"
url="https://registry.npmjs.org/svelte-language-server/-/$tarball"

if [[ "$UPDATE_NIX_OLD_VERSION" == "$version" ]]; then
    echo "Already up to date!"
    exit 0
fi

sed -i 's#version = "[^"]*"#version = "'"$version"'"#' package.nix

sha256=$(nix-prefetch-url "$url")
src_hash=$(nix-hash --type sha256 --to-sri "$sha256")
sed -i 's#hash = "[^"]*"#hash = "'"$src_hash"'"#' package.nix

rm -f package-lock.json package.json *.tgz
wget "$url"
tar xf "$tarball" --strip-components=1 package/package.json
npm i --package-lock-only
npm_hash=$(prefetch-npm-deps package-lock.json)
sed -i 's#npmDepsHash = "[^"]*"#npmDepsHash = "'"$npm_hash"'"#' package.nix
rm -f package.json *.tgz

popd
