#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl git jq nix prefetch-npm-deps
# shellcheck shell=bash

# Regenerates the hashes in sources.json. Pass a version to pin a
# release, or no arguments to auto-detect the latest GitHub release.

# Usage: ./update.sh [version]

set -euo pipefail

root="$(git rev-parse --show-toplevel)"

# Outputs the source hash (SRI) and npm deps hash (SRI).
prefetch() {
  local this hash path
  this="$(nix-prefetch-url --unpack --print-path --type sha256 "$1" 2>/dev/null)"
  hash="$(head -1 <<< "$this")"
  path="$(tail -1 <<< "$this")"
  nix hash convert --hash-algo sha256 "$hash"
  prefetch-npm-deps "${path}/package-lock.json" 2>/dev/null | tail -1
}

version="${1:-}"
if [ -z "$version" ]; then
  version="$(curl -fsSL 'https://api.github.com/repos/raindropio/desktop/releases/latest' | jq -r '.tag_name | ltrimstr("v")')"
fi

echo "Updating raindrop to v${version}..."

# The webapp is a Git submodule of desktop; the Contents API returns the commit SHA it's pinned to.
webapp_rev="$(curl -fsSL "https://api.github.com/repos/raindropio/desktop/contents/webapp?ref=v${version}" | jq -r '.sha')"

echo "  Fetching desktop..."
readarray -t desktop < <(prefetch "https://github.com/raindropio/desktop/archive/refs/tags/v${version}.tar.gz")

echo "  Fetching webapp..."
readarray -t webapp < <(prefetch "https://github.com/raindropio/app/archive/${webapp_rev}.tar.gz")

jq -n \
  --arg version "$version" \
  --arg desktopRev "v${version}" \
  --arg desktopHash "${desktop[0]}" \
  --arg desktopNpmHash "${desktop[1]}" \
  --arg webappRev "$webapp_rev" \
  --arg webappHash "${webapp[0]}" \
  --arg webappNpmHash "${webapp[1]}" \
  '$ARGS.named' > "$root/pkgs/by-name/ra/raindrop/sources.json"

echo "Updated sources.json to v${version}"
