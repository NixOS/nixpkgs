#!/usr/bin/env nix-shell
#!nix-shell -i bash -p wget nix-prefetch-github jq coreutils

# shellcheck shell=bash

if [ -n "$GITHUB_TOKEN" ]; then
    TOKEN_ARGS=(--header "Authorization: token $GITHUB_TOKEN")
fi

if [[ $# -gt 1 || $1 == -* ]]; then
    echo "Regenerates packaging data for psst."
    echo "Usage: $0 [git commit]"
    exit 1
fi

set -x

cd "$(dirname "$0")"
rev="$1"

set -euo pipefail

if [ -z "$rev" ]; then
    rev="$(wget -O- "${TOKEN_ARGS[@]}" "https://api.github.com/repos/jpochyla/psst/commits?per_page=1" | jq -r '.[0].sha')"
fi

version="unstable-$(date +%F)"

# Sources
src_hash=$(nix-prefetch-github jpochyla psst --rev "$rev" | jq -r .hash)

# Cargo.lock
src="https://raw.githubusercontent.com/jpochyla/psst/$rev"
wget "${TOKEN_ARGS[@]}" "$src/Cargo.lock" -O Cargo.lock

sed -i -E -e "s#version = \".*\"#version = \"$version\"#" default.nix
sed -i -E -e "s#rev = \".*\"#rev = \"$rev\"#" default.nix
sed -i -E -e "s#hash = \".*\"#hash = \"$src_hash\"#" default.nix

# Also update the git hash shown in the UI
sed -i -E -e "s#GIT_VERSION: \&str = \".*\"#GIT_VERSION: \&str = \"$rev\"#" make-build-reproducible.patch
