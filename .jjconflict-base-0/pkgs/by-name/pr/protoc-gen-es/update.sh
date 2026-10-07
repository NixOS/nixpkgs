#! /usr/bin/env -S nix shell nixpkgs#gnugrep nixpkgs#gnused nixpkgs#coreutils nixpkgs#curl nixpkgs#wget nixpkgs#jq nixpkgs#nix-update nixpkgs#prefetch-npm-deps nixpkgs#npm-lockfile-fix nixpkgs#nodejs --command bash

set -euo pipefail

version="$(
  curl ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} -s "https://api.github.com/repos/bufbuild/protobuf-es/releases" |
    jq -r 'map(select(.prerelease == false)) | .[0].tag_name' |
    grep -oP "^v\K.*"
)"
url="https://raw.githubusercontent.com/bufbuild/protobuf-es/v$version/"

if [[ "$UPDATE_NIX_OLD_VERSION" == "$version" ]]; then
  echo "Already up to date!"
  exit 0
fi

tmp="$(mktemp -d)"
trap 'rm -rf -- "$tmp"' EXIT

pushd -- "$tmp"
wget "$url/package-lock.json"
npm-lockfile-fix package-lock.json
npm_hash=$(prefetch-npm-deps package-lock.json)
popd

pushd "$(dirname "${BASH_SOURCE[0]}")"
sed -i 's#npmDepsHash = "[^"]*"#npmDepsHash = "'"$npm_hash"'"#' package.nix
popd

nix-update protoc-gen-es --version "$version"
