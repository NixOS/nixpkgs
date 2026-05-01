#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl nix-update prefetch-npm-deps nodejs jq gnused ruby bundix

set -eu -o pipefail

# Make a temporary directory and make sure it's removed when the script exits
tmp=$(mktemp -d)
trap "rm -rf $tmp" EXIT

package_dir="$(dirname "${BASH_SOURCE[0]}")"
pushd "$package_dir"

curl -sfL ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} https://api.github.com/repos/Shopify/cli/releases/latest > $tmp/latest.json
version=$(cat $tmp/latest.json | jq -r '.tag_name')

if [[ "$UPDATE_NIX_OLD_VERSION" == "$version" ]]; then
    echo "Already up to date!"
    exit 0
fi

pushd manifests

# Update the package.json
sed -i "s|$UPDATE_NIX_OLD_VERSION|$version|g" package.json

# Update the package-lock.json
rm -f package-lock.json
npm i --package-lock-only
npm_hash=$(prefetch-npm-deps package-lock.json)

popd

sed -i "s|npmDepsHash = \".*\";|npmDepsHash = \"$npm_hash\";|" package.nix

popd

nix-update shopify-cli --version $version
