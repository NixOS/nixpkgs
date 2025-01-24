#! /usr/bin/env nix-shell
#! nix-shell -i bash -p curl nix-update prefetch-npm-deps nodejs jq gnused

set -eu -o pipefail

pushd "$(dirname "${BASH_SOURCE[0]}")"

tag=$(curl -sfL ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} https://api.github.com/repos/node-red/node-red/releases/latest | jq -r .tag_name)

curl -sfL ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} "https://github.com/node-red/node-red/raw/refs/tags/$tag/package.json" > package.json

rm package-lock.json
npm i --package-lock-only

npm_hash=$(prefetch-npm-deps package-lock.json)
sed -i "s|npmDepsHash = \".*\";|npmDepsHash = \"$npm_hash\";|" package.nix

rm package.json
popd

nix-update node-red --version "$tag"
