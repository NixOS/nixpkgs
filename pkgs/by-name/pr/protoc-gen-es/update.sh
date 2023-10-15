#! /usr/bin/env nix-shell
#! nix-shell -i bash -p gnugrep gnused coreutils curl wget jq nix-update prefetch-npm-deps nodejs

set -euo pipefail

version=$(curl -s "https://api.github.com/repos/bufbuild/protobuf-es/tags" | jq -r .[0].name | grep -oP "^v\K.*")
url="https://raw.githubusercontent.com/bufbuild/protobuf-es/v$version/"

if [[ "$UPDATE_NIX_OLD_VERSION" == "$version" ]]; then
    echo "Already up to date!"
    exit 0
fi

tmp="$(mktemp -d)"
trap 'rm -rf -- "$tmp"' EXIT

pushd -- "$tmp"
wget "$url/package-lock.json"
npm_hash=$(prefetch-npm-deps package-lock.json)
popd

pushd "$(dirname "${BASH_SOURCE[0]}")"
sed -i 's#npmDepsHash = "[^"]*"#npmDepsHash = "'"$npm_hash"'"#' default.nix
popd

nix-update protoc-gen-es --version "$version"
