#! /usr/bin/env nix-shell
#! nix-shell -i bash -p gnused nix nodejs

set -euo pipefail
pushd "$(dirname "${BASH_SOURCE[0]}")"

version=$(npm view @withgraphite/graphite-cli version)

if [[ "$UPDATE_NIX_OLD_VERSION" == "$version" ]]; then
    echo "Already up to date!"
    exit 0
fi

sed -i 's#version = "[^"]*"#version = "'"$version"'"#' package.nix

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

for platform in linux-x64 linux-arm64 darwin-x64 darwin-arm64; do
    (
        url="https://registry.npmjs.org/@withgraphite/graphite-cli-${platform}/-/graphite-cli-${platform}-${version}.tgz"
        sha256=$(nix-prefetch-url "$url")
        nix-hash --to-sri --type sha256 "$sha256" > "$tmpdir/$platform"
    ) &
done
wait

for platform in linux-x64 linux-arm64 darwin-x64 darwin-arm64; do
    hash=$(cat "$tmpdir/$platform")
    # Each platform hash appears only once in the file
    sed -i "/${platform}/s#\"sha256-[^\"]*\"#\"${hash}\"#" package.nix
done

popd
