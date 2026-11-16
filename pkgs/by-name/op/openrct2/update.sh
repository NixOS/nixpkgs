#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p coreutils gnused curl common-updater-scripts jq

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

latest_assets=$(curl -fsSL "https://raw.githubusercontent.com/OpenRCT2/OpenRCT2/refs/tags/v${latest_version}/assets.json")

declare -A version_vars=(
  [objects]=objectsVersion
  [openmusic]=openmusicVersion
  [opensfx]=opensfxVersion
  [title-sequences]=titleSequencesVersion
  [replays]=replaysVersion
)

for asset in "${!version_vars[@]}"; do
  url=$(jq -er --arg a "$asset" '.[$a].url' <<<"$latest_assets")
  hex=$(jq -er --arg a "$asset" '.[$a].sha256' <<<"$latest_assets")
  version=$(sed -E 's|.*/download/v([^/]+)/.*|\1|' <<<"$url")
  sri=$(nix hash convert --hash-algo sha256 --from base16 --to sri "$hex")

  echo "$asset version: $version | sri: $sri"

  sed -i \
    -e "s|${version_vars[$asset]} = \"[^\"]*\"|${version_vars[$asset]} = \"$version\"|" \
    -e "/^ *$asset = fetchurl {/,/};/ s|hash = \"[^\"]*\"|hash = \"$sri\"|" \
    "$package_file"
done

update-source-version "$package" "$latest_version"
