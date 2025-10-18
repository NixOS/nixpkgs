#!/usr/bin/env nix-shell
#!nix-shell -i bash -p coreutils curl gawk gnugrep gnused common-updater-scripts
#shellcheck shell=bash

set -eu -o pipefail

update_arch() {
  local arch="$1"
  local system="$2"

  local source_url
  source_url="$(curl -L -I "https://orbstack.dev/download/stable/latest/$arch" | grep -i "location:" | awk '{print $2}' | tr -d '\r')"

  local version
  version="$(echo "$source_url" | grep -o '\([0-9]\+\.\)\{2\}[0-9]\+_[0-9]\+' | sed 's/_/-/')"

  local hash
  hash=$(nix --extra-experimental-features nix-command hash convert --to sri --hash-algo sha256 "$(nix-prefetch-url --type sha256 "$source_url")")

  update-source-version orbstack "$version" "$hash" --system="$system" --source-key="sources.$system" --ignore-same-version
}

update_arch "arm64" "aarch64-darwin"
update_arch "amd64" "x86_64-darwin"
