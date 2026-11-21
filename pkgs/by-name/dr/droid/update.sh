#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl

set -euo pipefail

nixpkgs="$(git rev-parse --show-toplevel)"
path="$nixpkgs/pkgs/by-name/dr/droid/package.nix"

install_script=$(curl -fsSL "https://app.factory.ai/cli")
new_version=$(echo "$install_script" | grep -oP 'VER="\K[0-9.]+(?=")')

if [ -z "$new_version" ]; then
  echo "Error: Could not extract version from install script" >&2
  exit 1
fi

old_version=$(sed -nE 's/^\s*version = "(.*)".*/\1/p' "$path")

if [[ "$old_version" == "$new_version" ]]; then
  echo "Current version $old_version is up-to-date"
  exit 0
fi

echo "Updating droid: $old_version -> $new_version"

base_url="https://downloads.factory.ai/factory-cli/releases/$new_version"

get_hash() {
  curl -fsSL "$1" | xargs nix hash convert --hash-algo sha256 --to sri
}

sed -i "s/version = \"$old_version\"/version = \"$new_version\"/" "$path"

for pair in "x86_64-linux:linux/x64" "aarch64-linux:linux/arm64" "x86_64-darwin:darwin/x64" "aarch64-darwin:darwin/arm64"; do
  system="${pair%%:*}"
  url_path="${pair#*:}"
  hash=$(get_hash "$base_url/$url_path/droid.sha256")
  sed -i "/$system = {/,/};/s|hash = \"sha256-[^\"]*\"|hash = \"$hash\"|" "$path"
done

echo "Updated droid: $old_version -> $new_version"
