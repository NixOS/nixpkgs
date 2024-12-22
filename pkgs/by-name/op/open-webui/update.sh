#!/usr/bin/env nix-shell
#!nix-shell -i bash -p git curl jq common-updater-scripts prefetch-npm-deps

set -eou pipefail

nixpkgs="$(git rev-parse --show-toplevel)"
path="$nixpkgs/pkgs/by-name/op/open-webui/package.nix"
version="$(curl --silent "https://api.github.com/repos/open-webui/open-webui/releases" | jq '.[0].tag_name' --raw-output)"

update-source-version open-webui "${version:1}" --file="$path"

# Fetch npm deps
tmpdir=$(mktemp -d)
curl -O --output-dir $tmpdir "https://raw.githubusercontent.com/open-webui/open-webui/refs/tags/${version}/package-lock.json"
curl -O --output-dir $tmpdir "https://raw.githubusercontent.com/open-webui/open-webui/refs/tags/${version}/package.json"
pushd $tmpdir
npm_hash=$(prefetch-npm-deps package-lock.json)
sed -i 's#npmDepsHash = "[^"]*"#npmDepsHash = "'"$npm_hash"'"#' "$path"
popd
rm -rf $tmpdir

