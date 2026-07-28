#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash gh gnugrep gnused
# shellcheck shell=bash

set -euo pipefail

dir="$(CDPATH="" cd "$(dirname "$0")" && pwd)"
pkg="$dir/package.nix"
if ! [ -e "$pkg" ]; then
  echo "Unable to find package.nix"
  exit 1
fi

old_vsn="$(grep --only-matching --perl-regexp 'version = "\K[^"]+' "$pkg")"

new_vsn="$(gh api repos/docker/sbx-releases/releases/latest --jq .tag_name | \
  grep --only-matching --perl-regexp '\d+\.\d+\.\d+')"

if [ "$old_vsn" = "$new_vsn" ]; then
  echo "No new version available, skipping"
  exit 0
fi

echo "docker-sbx: $old_vsn -> $new_vsn"

fetch_arch () {
  local vsn="$1" plat="$2" url hash
  url="https://github.com/docker/sbx-releases/releases/download/v${vsn}/DockerSandboxes-${plat}.tar.gz"
  hash="$(nix-prefetch-url --type sha256 "$url")";
  nix-hash --to-sri --type sha256 "$hash"
}

declare -A hashes
declare -A platNames=(
  ["linux-amd64"]="x86_64-linux"
  ["linux-arm64"]="aarch64-linux"
  ["darwin"]="aarch64-darwin"
)
declare -a platforms=(
  "linux-amd64"
  "linux-arm64"
  "darwin"
)

for plat in "${platforms[@]}"; do
  hashes[$plat]="$(fetch_arch "$new_vsn" "$plat")"
done

declare -a sedArgs=(
  -e 's:version = "'"$old_vsn"'":version = "'"$new_vsn"'":'
)

for plat in "${platforms[@]}"; do
  p="${platNames[$plat]}"
  sedArgs+=(
    -e '0,/"'"$p"'" = / s:"'"$p"'" = .*;:"'"$p"'" = "'"${hashes[$plat]}"'";:'
  )
done
sed -i "${sedArgs[@]}" "$pkg"
