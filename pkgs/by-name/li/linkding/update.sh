#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=../../../../ -i bash -p nix wget prefetch-npm-deps nix-prefetch-github jq

# shellcheck shell=bash

if [ -n "$GITHUB_TOKEN" ]; then
    TOKEN_ARGS=(--header "Authorization: token $GITHUB_TOKEN")
fi

if [ "$#" -gt 1 ] || [[ "$1" == -* ]]; then
    echo "Regenerates packaging data for the linkding package."
    echo "Usage: $0 [git release tag]"
    exit 1
fi

version="$1"

set -euo pipefail

if [ -z "$version" ]; then
    version="$(wget -O- "${TOKEN_ARGS[@]}" "https://api.github.com/repos/sissbruecker/linkding/releases?per_page=1" | jq -r '.[0].tag_name')"
fi

package_src="https://raw.githubusercontent.com/sissbruecker/linkding/$version"

src_hash=$(nix-prefetch-github sissbruecker linkding --rev "${version}" | jq -r .hash)

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

pushd "$tmpdir"
wget "${TOKEN_ARGS[@]}" "$package_src/package-lock.json"
npm_hash=$(prefetch-npm-deps package-lock.json)
popd

# Use friendlier hashes
src_hash=$(nix hash to-sri --type sha256 "$src_hash")
npm_hash=$(nix hash to-sri --type sha256 "$npm_hash")

sed -i -E -e "s#version = \".*\"#version = \"$version\"#" common.nix
sed -i -E -e "s#sha256 = \".*\"#sha256 = \"$src_hash\"#" common.nix
sed -i -E -e "s#npmDepsHash = \".*\"#npmDepsHash = \"$npm_hash\"#" common.nix
