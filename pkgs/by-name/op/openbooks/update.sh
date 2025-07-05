#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix wget prefetch-npm-deps nix-prefetch-github nurl jq

# shellcheck shell=bash

if [ -n "${GITHUB_TOKEN:-}" ]; then
    TOKEN_ARGS=(--header "Authorization: token $GITHUB_TOKEN")
fi

if [ "$#" -gt 1 ] || [[ $1 == -* ]]; then
    echo "Regenerates packaging data for the openbooks package."
    echo "Usage: $0 [git release tag]"
    exit 1
fi

version="$1"
rev="v$version"

set -euo pipefail

NIXPKGS_ROOT="$(git rev-parse --show-toplevel)"

if [ -z "$version" ]; then
    rev="$(wget -O- "${TOKEN_ARGS[@]}" "https://api.github.com/repos/evan-buss/openbooks/releases?per_page=1" | jq -r '.[0].tag_name')"
    version="${rev#v}"
fi

package_src="https://raw.githubusercontent.com/evan-buss/openbooks/$rev"

src_hash=$(nix-prefetch-github evan-buss openbooks --rev "$rev" | jq -r .hash)

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

pushd "$tmpdir"
wget "${TOKEN_ARGS[@]}" "$package_src/server/app/package-lock.json"
npm_hash=$(prefetch-npm-deps package-lock.json)
popd

cd "$(dirname "${BASH_SOURCE[0]}")"
sed -i -E -e "s#version = \".*\"#version = \"$version\"#" common.nix
sed -i -E -e "s#hash = \".*\"#hash = \"$src_hash\"#" common.nix
sed -i -E -e "s#npmDepsHash = \".*\"#npmDepsHash = \"$npm_hash\"#" frontend.nix

vendor_hash=$(nurl -e "(import $NIXPKGS_ROOT/. { }).openbooks.goModules")
sed -i -E -e "s#vendorHash = \".*\"#vendorHash = \"$vendor_hash\"#" package.nix
