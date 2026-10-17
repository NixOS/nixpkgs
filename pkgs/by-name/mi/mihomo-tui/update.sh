#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix-update

set -euo pipefail

scriptDir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

release="$(
  curl -fsSL \
    https://api.github.com/repos/potoo0/mihomo-tui/releases/latest
)"

version="$(jq -er '.tag_name | ltrimstr("v")' <<< "$release")"
buildDate="$(jq -er '.published_at | split("T")[0]' <<< "$release")"

sed -i \
  's#VERGEN_BUILD_DATE = "[^"]*"#VERGEN_BUILD_DATE = "'"$buildDate"'"#' \
  "$scriptDir/package.nix"

# Update the package version, source hash, and Cargo dependency hash.
nix-update mihomo-tui --version "$version"
