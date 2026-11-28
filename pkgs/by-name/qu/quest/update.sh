#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq gawk gnused nix
# shellcheck shell=bash

set -euo pipefail

repo_root="$(git rev-parse --show-toplevel)"
pkg_file="$repo_root/pkgs/by-name/qu/quest/package.nix"

stage_json="$(curl -fsSL https://packages.quest.app/linux/repository-stage.json)"
latest_version="$(jq -r '.version' <<<"$stage_json")"
current_version="$(sed -n 's/^[[:space:]]*version = "\([^"]*\)";/\1/p' "$pkg_file" | head -n1)"

if [[ "$latest_version" == "$current_version" ]]; then
  echo "quest is already up-to-date ($current_version)"
  exit 0
fi

deb_entry="$(jq -r '.files[] | select(.path | startswith("candidates/") and endswith("-linux-amd64.deb"))' <<<"$stage_json")"
deb_path="$(jq -r '.path' <<<"$deb_entry")"
deb_sha256_hex="$(jq -r '.sha256' <<<"$deb_entry")"

if [[ -z "$deb_path" || -z "$deb_sha256_hex" ]]; then
  echo "Failed to locate Linux amd64 .deb candidate in repository-stage.json" >&2
  exit 1
fi

deb_url="https://packages.quest.app/linux/$deb_path"
deb_hash="$(nix hash convert --hash-algo sha256 --from base16 "$deb_sha256_hex")"

mac_sums="$(curl -fsSL "https://github.com/steenfatt/quest-releases/releases/download/v${latest_version}/SHA256SUMS.txt")"
mac_sha256_hex="$(awk -v asset="Quest-${latest_version}-arm64-mac.zip" '$2 == asset { print $1; exit }' <<<"$mac_sums")"

if [[ -z "$mac_sha256_hex" ]]; then
  echo "Failed to locate Quest-${latest_version}-arm64-mac.zip in SHA256SUMS.txt" >&2
  exit 1
fi

mac_hash="$(nix hash convert --hash-algo sha256 --from base16 "$mac_sha256_hex")"

sed -i \
  -e "s|version = \"[^\"]*\";|version = \"$latest_version\";|" \
  -e "/x86_64-linux = fetchurl/,/};/s|url = \"https://packages.quest.app/linux/[^\"]*\";|url = \"$deb_url\";|" \
  -e "/x86_64-linux = fetchurl/,/};/s|hash = \"sha256-[^\"]*\";|hash = \"$deb_hash\";|" \
  -e "/aarch64-darwin = fetchurl/,/};/s|hash = \"sha256-[^\"]*\";|hash = \"$mac_hash\";|" \
  "$pkg_file"

echo "Updated quest: $current_version -> $latest_version"
