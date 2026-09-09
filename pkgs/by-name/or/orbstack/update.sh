#!/usr/bin/env nix-shell
#!nix-shell -i bash -p coreutils curl gawk gnugrep gnused common-updater-scripts
#shellcheck shell=bash

set -eu -o pipefail

source_url="$(curl -L -I "https://orbstack.dev/download/stable/latest/arm64" | grep -i "location:" | awk '{print $2}' | tr -d '\r')"
version="$(echo "$source_url" | grep -o '\([0-9]\+\.\)\{2\}[0-9]\+_[0-9]\+' | sed 's/_/-/')"
hash=$(nix --extra-experimental-features nix-command hash convert --to sri --hash-algo sha256 "$(nix-prefetch-url --type sha256 "$source_url")")

update-source-version orbstack "$version" "$hash" --ignore-same-version
