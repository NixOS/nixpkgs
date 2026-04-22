#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p coreutils gnused curl common-updater-scripts jq ripgrep

set -euo pipefail

package="openrct2"
package_file="$(dirname "$0")/package.nix"

current_version="$(nix eval --raw -f . $package.version)"
latest_version=$(curl -fsSL ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} "https://api.github.com/repos/OpenRCT2/OpenRCT2/releases/latest" | jq -r '.tag_name | ltrimstr("v")')

if [[ "$current_version" == "$latest_version" ]]; then
  echo "$package is already up-to-date: $current_version"
  exit 0
fi

echo "$package updating from $current_version to $latest_version"

echo "Getting new asset versions ..."

latest_assets=$(curl -fsSL "https://raw.githubusercontent.com/OpenRCT2/OpenRCT2/refs/tags/v${latest_version}/assets.json")

current_objects_version="$(rg -oP 'objects-version\s*=\s*"\K[^"]+' "$package_file")"
current_openmusic_version="$(rg -oP 'openmusic-version\s*=\s*"\K[^"]+' "$package_file")"
current_opensfx_version="$(rg -oP 'opensfx-version\s*=\s*"\K[^"]+' "$package_file")"
current_title_sequences_version="$(rg -oP 'title-sequences-version\s*=\s*"\K[^"]+' "$package_file")"

declare -A new_versions
declare -A new_sris

for asset in objects openmusic opensfx title-sequences; do
  url=$(echo "$latest_assets" | jq -r --arg a "$asset" '.[$a].url')
  hex=$(echo "$latest_assets" | jq -r --arg a "$asset" '.[$a].sha256')
  version=$(echo "$url" | grep -oP '(?<=/download/v)[^/]+')
  sri=$(nix hash convert --hash-algo sha256 --from base16 --to sri "$hex")

  new_versions[$asset]="$version"
  new_sris[$asset]="$sri"

  echo "$asset version: $version | sri: $sri"
done

# Update version strings
sed -i \
  -e "s|objects-version = \"${current_objects_version}\"|objects-version = \"${new_versions[objects]}\"|" \
  -e "s|openmusic-version = \"${current_openmusic_version}\"|openmusic-version = \"${new_versions[openmusic]}\"|" \
  -e "s|opensfx-version = \"${current_opensfx_version}\"|opensfx-version = \"${new_versions[opensfx]}\"|" \
  -e "s|title-sequences-version = \"${current_title_sequences_version}\"|title-sequences-version = \"${new_versions[title-sequences]}\"|" \
  "$package_file"

declare -A asset_url_fragments
asset_url_fragments[objects]="objects.zip"
asset_url_fragments[openmusic]="openmusic.zip"
asset_url_fragments[opensfx]="opensound.zip"
asset_url_fragments[title-sequences]="title-sequences.zip"

for asset in objects openmusic opensfx title-sequences; do
  old_sri=$(rg -A2 "${asset_url_fragments[$asset]}" "$package_file" | rg -oP 'sha256-[^"]+')
  sed -i "s|$old_sri|${new_sris[$asset]}|" "$package_file"
done

echo "Updating $package from $current_version to $latest_version ..."
update-source-version "$package" "$latest_version"
