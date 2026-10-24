#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix
#shellcheck shell=bash

set -euo pipefail

update_info_url="https://raw.githubusercontent.com/jetbrains-junie/junie/main/update-info.jsonl"
source_file="pkgs/by-name/ju/junie/source.json"

update_info=$(curl -fsSL "$update_info_url")

version=$(jq -sr 'max_by(.version | split(".") | map(tonumber)).version' <<<"$update_info")

linux_aarch64_hash=$(jq -sr --arg v "$version" 'map(select(.version == $v and .platform == "linux-aarch64"))[-1].sha256' <<<"$update_info")
linux_x86_64_hash=$(jq -sr --arg v "$version" 'map(select(.version == $v and .platform == "linux-amd64"))[-1].sha256' <<<"$update_info")
darwin_aarch64_hash=$(jq -sr --arg v "$version" 'map(select(.version == $v and .platform == "macos-aarch64"))[-1].sha256' <<<"$update_info")

jq -n \
  --arg version "$version" \
  --arg linuxAarch64Hash "$(nix-hash --type sha256 --to-sri "$linux_aarch64_hash")" \
  --arg linuxX86_64Hash "$(nix-hash --type sha256 --to-sri "$linux_x86_64_hash")" \
  --arg darwinAarch64Hash "$(nix-hash --type sha256 --to-sri "$darwin_aarch64_hash")" \
  '{
    version: $version,
    platforms: {
      "aarch64-linux": { hash: $linuxAarch64Hash },
      "x86_64-linux": { hash: $linuxX86_64Hash },
      "aarch64-darwin": { hash: $darwinAarch64Hash }
    }
  }' >"$source_file"
