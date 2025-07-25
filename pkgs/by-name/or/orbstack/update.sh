#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl common-updater-scripts
#shellcheck shell=bash

set -eu -o pipefail

update_arch() {
  local arch="$1"
  local system="$2"

  local source_url
  source_url="$(curl -L -I "https://orbstack.dev/download/stable/latest/$arch" | grep -i "location:" | awk '{print $2}' | tr -d '\r')"

  local version
  version="$(echo "$source_url" | sed -E 's|.*/OrbStack_v||' | sed -E "s|_${arch}\.dmg||")"

  local hash
  hash=$(nix --extra-experimental-features nix-command hash convert --to sri --hash-algo sha256 "$(nix-prefetch-url --type sha256 "$source_url")")

  update-source-version orbstack "$version" "$hash" --version-key="buildVersion" --system="$system" --ignore-same-version
}

update_arch "arm64" "aarch64-darwin"
update_arch "amd64" "x86_64-darwin"
