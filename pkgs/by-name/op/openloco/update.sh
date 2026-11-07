#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p coreutils gnused curl common-updater-scripts jq ripgrep

set -euo pipefail

package="openloco"
package_file="$(dirname "$0")/package.nix"

gh_curl() {
  curl -fsSL ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} "$@"
}

current_version="$(nix eval --raw -f . $package.version)"
latest_version=$(gh_curl "https://api.github.com/repos/OpenLoco/OpenLoco/releases/latest" | jq -r '.tag_name | ltrimstr("v")')

if [[ "$current_version" == "$latest_version" ]]; then
  echo "$package is already up-to-date: $current_version"
  exit 0
fi

echo "$package updating from $current_version to $latest_version"

raw="https://raw.githubusercontent.com/OpenLoco/OpenLoco/refs/tags/v${latest_version}"

echo "Getting new asset versions ..."

objects_decl=$(gh_curl "$raw/CMakeLists.txt" | rg -A1 'OpenGraphics/releases/download')
objects_version=$(echo "$objects_decl" | rg -oP '(?<=/download/v)[^/]+')
objects_hex=$(echo "$objects_decl" | rg -oP 'URL_HASH\s+SHA256=\K[0-9a-f]+')
objects_sri=$(nix hash convert --hash-algo sha256 --from base16 --to sri "$objects_hex")
echo "objects version: $objects_version | sri: $objects_sri"

sfl_version=$(gh_curl "$raw/thirdparty/CMakeLists.txt" | rg -A2 'slavenf/sfl-library' | rg -oP 'GIT_TAG\s+\K\S+')
echo "sfl version: $sfl_version"

commit=$(gh_curl "https://api.github.com/repos/OpenLoco/OpenLoco/commits/v${latest_version}" | jq -r '.sha[0:7]')
echo "commit: $commit"

current_commit="$(rg -oP 'commit\s*=\s*"\K[^"]+' "$package_file")"
current_objects_version="$(rg -oP 'objects-version\s*=\s*"\K[^"]+' "$package_file")"
current_objects_sri="$(rg -A2 'objects.zip' "$package_file" | rg -oP 'sha256-[^"]+')"
current_sfl_version="$(rg -oP 'sfl-version\s*=\s*"\K[^"]+' "$package_file")"

sed -i \
  -e "s|commit = \"${current_commit}\"|commit = \"${commit}\"|" \
  -e "s|objects-version = \"${current_objects_version}\"|objects-version = \"${objects_version}\"|" \
  -e "s|${current_objects_sri}|${objects_sri}|" \
  "$package_file"

if [[ "$sfl_version" != "$current_sfl_version" ]]; then
  sfl_nix32=$(nix-prefetch-url --unpack "https://github.com/slavenf/sfl-library/archive/refs/tags/${sfl_version}.tar.gz")
  sfl_sri=$(nix hash convert --hash-algo sha256 --to sri "$sfl_nix32")
  current_sfl_sri="$(rg -A4 'sfl-library' "$package_file" | rg -oP 'sha256-[^"]+')"
  echo "sfl sri: $sfl_sri"
  sed -i \
    -e "s|sfl-version = \"${current_sfl_version}\"|sfl-version = \"${sfl_version}\"|" \
    -e "s|${current_sfl_sri}|${sfl_sri}|" \
    "$package_file"
fi

echo "Updating $package from $current_version to $latest_version ..."
update-source-version "$package" "$latest_version"
