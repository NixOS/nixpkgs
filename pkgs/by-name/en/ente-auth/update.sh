#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gojq nix-prefetch-github common-updater-scripts

set -eou pipefail
pkg_dir="$(dirname "$0")"

gh-curl () {
  curl --silent ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} "$1"
}

version="$(gh-curl "https://api.github.com/repos/ente-io/ente/releases" | gojq 'map(select(.draft == false and .prerelease == false and (.tag_name | startswith("auth-v")))) | first | .tag_name' --raw-output)"
short_version="${version:6}"
if [[ "$short_version" == "$UPDATE_NIX_OLD_VERSION" ]]; then
  echo "ente-auth is already up-to-date: $short_version"
  exit 0
fi
echo "Updating to $short_version"

# Subtree needed for lockfile and icons
auth_tree="$(gh-curl "https://api.github.com/repos/ente-io/ente/git/trees/$version" | gojq '.tree[] | select(.path == "auth") | .url' --raw-output)"

# Get lockfile, filter out incompatible sqlite dependency and convert to JSON
echo "Updating lockfile"
pubspec_lock="$(gh-curl "$auth_tree" | gojq '.tree[] | select(.path == "pubspec.lock") | .url' --raw-output)"
gh-curl "$pubspec_lock" | gojq '.content | @base64d' --raw-output | gojq --yaml-input 'del(.packages.sqlite3_flutter_libs)' > "$pkg_dir/pubspec.lock.json"

# Get rev and hash of simple-icons submodule
echo "Updating icons"
assets_tree="$(gh-curl "$auth_tree" | gojq '.tree[] | select(.path == "assets") | .url' --raw-output)"
simple_icons_rev="$(gh-curl "$assets_tree" | gojq '.tree[] | select(.path == "simple-icons") | .sha' --raw-output)"
nix-prefetch-github --rev "$simple_icons_rev" simple-icons simple-icons > "$pkg_dir/simple-icons.json"

# Update package version and hash
echo "Updating package source"
update-source-version ente-auth "$short_version" --file="$pkg_dir/package.nix"
