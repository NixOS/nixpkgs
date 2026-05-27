#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash common-updater-scripts coreutils curl gnutar nix
# shellcheck shell=bash
set -euo pipefail

script_dir="$(cd -- "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
nixpkgs_root="$(realpath "$script_dir/../../../..")"
package_file="$script_dir/package.nix"
tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

cd -- "$nixpkgs_root"

if (( $# < 3 || ($# - 1) % 2 != 0 )); then
  echo "Usage: $0 <version> [<system> <url>]..." >&2
  exit 1
fi

version="$1"
shift

export NIXPKGS_ALLOW_UNFREE=1

hash_url() {
  local system="$1"
  local url="$2"
  local archive="$tmpdir/$system.tar.gz"
  local unpack_dir="$tmpdir/$system-unpack"

  mkdir -p "$unpack_dir"
  curl -fsSL "$url" -o "$archive" || return
  tar -xzf "$archive" -C "$unpack_dir" || return

  if [[ ! -x "$unpack_dir/antigravity" ]]; then
    echo "Expected executable 'antigravity' in $url" >&2
    exit 1
  fi

  nix hash path --type sha256 "$unpack_dir"
}

while (( $# > 0 )); do
  system="$1"
  url="$2"
  shift 2

  if [[ "$url" != *"/antigravity-cli/$version-"* ]]; then
    echo "URL for $system does not match package version $version: $url" >&2
    exit 1
  fi

  echo "Hashing $system from $url"
  hash="$(hash_url "$system" "$url")"
  update-source-version antigravity-cli "$version" "$hash" \
    --file="$package_file" \
    --ignore-same-hash \
    --ignore-same-version \
    --source-key="sources.$system" \
    --system="$system"
done
