#!/usr/bin/env nix-shell
#!nix-shell -i bash -p jq
#shellcheck shell=bash

CURRENT_HASH=""

print_hash() {
    OS="$1"
    CHANNEL="$2"
    ARCH="$3"
    VERSION="$4"

    if [[ "$OS" == "linux" ]]; then
        if [[ "$ARCH" == "x86_64" ]]; then
            EXT="x64.tar.gz"
        else
            EXT="arm64.tar.gz"
        fi
        URL="https://downloads.1password.com/${OS}/tar/${CHANNEL}/${ARCH}/1password-${VERSION}.${EXT}"
    else
        EXT="$ARCH.zip"
        URL="https://downloads.1password.com/${OS}/1Password-${VERSION}-${EXT}"
    fi

    CURRENT_HASH=$(nix store prefetch-file "$URL" --json | jq -r '.hash')

    echo "$CHANNEL ${ARCH}-${OS}: $CURRENT_HASH"
}

if [[ -z "$STABLE_VER" && -n "$1" ]]; then
    STABLE_VER="$1"
fi

if [[ -z "$BETA_VER" && -n "$2" ]]; then
    BETA_VER="$2"
fi

if [[ "${BETA_VER: -4}" != "BETA" ]]; then
    BETA_VER="$BETA_VER.BETA"
fi

if [[ -z "$STABLE_VER" ]]; then
    echo "No 'STABLE_VER' environment variable provided, skipping"
else
    print_hash "linux" "stable" "x86_64" "$STABLE_VER"
    print_hash "linux" "stable" "aarch64" "$STABLE_VER"
    print_hash "mac" "stable" "x86_64" "$STABLE_VER"
    print_hash "mac" "stable" "aarch64" "$STABLE_VER"
fi

if [[ -z "$BETA_VER" ]]; then
    echo "No 'BETA_VER' environment variable provided, skipping"
else
    print_hash "linux" "beta" "x86_64" "$BETA_VER"
    print_hash "linux" "beta" "aarch64" "$BETA_VER"
    print_hash "mac" "beta" "x86_64" "$BETA_VER"
    print_hash "mac" "beta" "aarch64" "$BETA_VER"
fi
