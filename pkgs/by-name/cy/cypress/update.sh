#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq

set -euo pipefail

basedir="$(git rev-parse --show-toplevel)"
package_nix="$basedir/pkgs/by-name/cy/cypress/package.nix"

version="$(curl -sL https://cdn.cypress.io/desktop/ | jq '.version' --raw-output)"
old_version=$(sed -nE 's/^  version = "(.*)";$/\1/p' "$package_nix")

if [[ "$version" == "$old_version" ]]; then
  echo "cypress is already up to date at version $version"
  exit 0
fi

echo "Updating cypress from $old_version to $version"
sed -i "s/version = \"$old_version\"/version = \"$version\"/" "$package_nix"

update_hash() {
  local nix_system="$1"
  local platform="$2"
  local url="https://cdn.cypress.io/desktop/${version}/${platform}/cypress.zip"

  echo "Fetching hash for $nix_system ($platform)..."
  local hash sri_hash old_hash
  hash=$(nix-prefetch-url --unpack --type sha256 "$url" 2>/dev/null)
  sri_hash=$(nix hash convert --hash-algo sha256 --to sri "$hash")

  old_hash=$(sed -n "/${nix_system}/,/hash/s/.*hash = \"\(.*\)\";/\1/p" "$package_nix")

  if [[ -n "$old_hash" ]]; then
    sed -i "s|${old_hash}|${sri_hash}|" "$package_nix"
    echo "  $nix_system: $sri_hash"
  else
    echo "  ERROR: Could not find hash for $nix_system" >&2
    exit 1
  fi
}

update_hash "x86_64-linux" "linux-x64"
update_hash "aarch64-linux" "linux-arm64"
update_hash "aarch64-darwin" "darwin-arm64"
update_hash "x86_64-darwin" "darwin-x64"

echo "Done updating cypress to $version"
