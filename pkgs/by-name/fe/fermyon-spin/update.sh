#!/usr/bin/env nix-shell
#!nix-shell -i bash -p jq
#shellcheck shell=bash

CURRENT_HASH=""

print_hash() {
    OS="$1"
    ARCH="$2"
    VERSION="$3"

    URL="https://github.com/fermyon/spin/releases/download/v${VERSION}/spin-v${VERSION}-${OS}-${ARCH}.tar.gz"
    echo
    CURRENT_HASH=$(nix store prefetch-file "$URL" --json | jq -r '.hash')

    echo "${ARCH}-${OS}: $CURRENT_HASH"
}

if [[ -z "$VER" && -n "$1" ]]; then
    VER="$1"
fi

if [[ -z "$VER" ]]; then
    echo "No 'VER' environment variable provided, skipping"
else
    print_hash "linux"  "amd64"   "$VER"
    print_hash "linux"  "aarch64" "$VER"
    print_hash "macos" "amd64"   "$VER"
    print_hash "macos" "aarch64" "$VER"
fi

