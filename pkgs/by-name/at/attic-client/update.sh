#!/usr/bin/env nix-shell
#!nix-shell -i bash -p wget nix-prefetch-github jq coreutils

# shellcheck shell=bash

if [ -n "$GITHUB_TOKEN" ]; then
    TOKEN_ARGS=(--header "Authorization: token $GITHUB_TOKEN")
fi

if [[ $# -gt 1 || $1 == -* ]]; then
    echo "Regenerates packaging data for attic."
    echo "Usage: $0 [git commit]"
    exit 1
fi

set -x

cd "$(dirname "$0")"
rev="$1"

set -euo pipefail

if [ -z "$rev" ]; then
    rev="$(wget -O- "${TOKEN_ARGS[@]}" "https://api.github.com/repos/zhaofengli/attic/commits?per_page=1" | jq -r '.[0].sha')"
fi

date="$(wget -O- "${TOKEN_ARGS[@]}" "https://api.github.com/repos/zhaofengli/attic/commits/$rev" | jq -r '.commit.author.date' | cut -dT -f1)"

version="0-unstable-$date"

# Sources
src_hash=$(nix-prefetch-github zhaofengli attic --rev "$rev" | jq -r .hash)

# Cargo.lock
src="https://raw.githubusercontent.com/zhaofengli/attic/$rev"
wget "${TOKEN_ARGS[@]}" "$src/Cargo.lock" -O Cargo.lock

sed -i -E -e "s#version = \".*\"#version = \"$version\"#" package.nix
sed -i -E -e "s#rev = \".*\"#rev = \"$rev\"#" package.nix
sed -i -E -e "s#hash = \".*\"#hash = \"$src_hash\"#" package.nix
