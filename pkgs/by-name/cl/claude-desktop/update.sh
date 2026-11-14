#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq openssl gnused common-updater-scripts
# shellcheck shell=bash

set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
nixpkgs_root=$(git -C "$script_dir" rev-parse --show-toplevel)

releases_url="https://downloads.claude.ai/releases/darwin/universal/RELEASES.json"
package_file="$nixpkgs_root/pkgs/by-name/cl/claude-desktop/package.nix"

release_data=$(curl --silent --show-error --fail "$releases_url")

version=$(jq -er '.currentRelease' <<<"$release_data")
url=$(jq -er --arg version "$version" '.releases[] | select(.version == $version) | .updateTo.url' <<<"$release_data")

[[ -n "$url" ]]

release=$(sed -E 's|.*/Claude-([0-9a-f]+)\.zip$|\1|' <<<"$url")
if ! [[ "$release" =~ ^[0-9a-f]+$ ]]; then
  echo "Could not extract release hash from URL: $url" >&2
  exit 1
fi

hash="sha256-$(curl --silent --show-error --fail --location "$url" | openssl dgst -sha256 -binary | openssl base64)"

sed -i -E \
  's|(release = )"[0-9a-f]+";|\1"'"$release"'";|' \
  "$package_file"

update-source-version claude-desktop "$version" "$hash" --file="$package_file"
