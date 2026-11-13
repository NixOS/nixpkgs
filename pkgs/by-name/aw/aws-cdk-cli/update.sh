#!/usr/bin/env nix-shell
#!nix-shell -i bash -p coreutils nix nix-update yarn-berry_4.yarn-berry-fetcher

set -euo pipefail

package_dir=$(realpath "$(dirname "$0")")

# Update the source first. offlineCache cannot be updated until the hashes
# missing from the new yarn.lock have been regenerated below.
nix-update "$UPDATE_NIX_PNAME" --src-only --version-regex 'cdk@v(.*)' "$@"

updated_version=$(nix-instantiate --eval --strict --attr "$UPDATE_NIX_PNAME.version" --raw)

if [[ "$updated_version" == "$UPDATE_NIX_OLD_VERSION" ]]; then
  echo "Package is already up to date: $updated_version"
  exit 0
fi

src_path=$(nix-build --attr "$UPDATE_NIX_PNAME.src" --no-link)
yarn-berry-fetcher missing-hashes "$src_path/yarn.lock" >"$package_dir/missing-hashes.json"

# Regenerate the hash of the Yarn offline cache after updating its missing hashes.
nix-update "$UPDATE_NIX_PNAME" --version skip
