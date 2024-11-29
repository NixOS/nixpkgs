#! /usr/bin/env nix-shell
#! nix-shell -i bash -p gnused nix nodejs prefetch-npm-deps wget

set -euo pipefail
pushd "$(dirname "${BASH_SOURCE[0]}")"

version=$(npm view @vue/language-server version)
tarball="language-server-$version.tgz"
url="https://registry.npmjs.org/@vue/language-server/-/$tarball"

if [[ "$UPDATE_NIX_OLD_VERSION" == "$version" ]]; then
    echo "Already up to date!"
    exit 0
fi

sed -i 's#version = "[^"]*"#version = "'"$version"'"#' package.nix

sha256=$(nix-prefetch-url "$url")
src_hash=$(nix-hash --to-sri --type sha256 "$sha256")
sed -i 's#hash = "[^"]*"#hash = "'"$src_hash"'"#' package.nix

rm -f package-lock.json package.json *.tgz
wget "$url"
tar xf "$tarball" --strip-components=1 package/package.json
npm i --package-lock-only --ignore-scripts
npm_hash=$(prefetch-npm-deps package-lock.json)
sed -i 's#npmDepsHash = "[^"]*"#npmDepsHash = "'"$npm_hash"'"#' package.nix
rm -f package.json *.tgz

popd
