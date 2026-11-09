#!/usr/bin/env nix-shell
#!nix-shell -i bash -p gitMinimal common-updater-scripts nix-update
#shellcheck shell=bash

set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
NIXPKGS_ROOT="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel)"
cd "$NIXPKGS_ROOT"

owner="ironcalc"
repo="ironcalc"

if [ -n "${1:-}" ]; then
  new_version="${1#v}"
else
  latest_tag=$(list-git-tags --url="https://github.com/$owner/$repo" | grep -E '^v[0-9]+(\.[0-9]+)*$' | sort -V | tail -n1)
  new_version="${latest_tag#v}"
fi

current_version=$(nix-instantiate --eval --raw -A ironcalc.version)

echo "Updating ironcalc: $current_version -> $new_version"

if [ "$current_version" = "$new_version" ]; then
  echo "Already up to date: $current_version"
  exit 0
fi

update-source-version ironcalc "$new_version"

echo "Updating hashes..."

nix-update ironcalc.tools --version=skip
nix-update ironcalc.server --version=skip
nix-update ironcalc.workbook --version=skip
nix-update ironcalc.frontend --version=skip
nix-update ironcalc.nodejs --version=skip
