#!/usr/bin/env nix-shell
#!nix-shell -i bash -p coreutils nix nix-update patch yarn-berry_4.yarn-berry-fetcher

set -euo pipefail

attr_path=${UPDATE_NIX_ATTR_PATH:-$UPDATE_NIX_PNAME}
package_file=$(
  nix-instantiate --eval --strict --expr \
    "with import ./. {}; (builtins.unsafeGetAttrPos \"version\" $attr_path).file" \
    --raw
)
package_dir=$(dirname "$package_file")

# Update the source first. The offline cache cannot be updated until hashes
# omitted from the new yarn.lock have been regenerated below.
nix-update "$attr_path" --src-only "$@"

updated_version=$(nix-instantiate --eval --strict --attr "$attr_path.version" --raw)
if [[ "$updated_version" == "$UPDATE_NIX_OLD_VERSION" ]]; then
  echo "Source is already up to date; refreshing dependencies for $updated_version"
fi

src_path=$(nix-build --attr "$attr_path.src" --no-link)
work_dir=$(mktemp -d)

# Keep this beside the tracked file so the final rename is atomic.
missing_hashes=$(mktemp "$package_dir/.missing-hashes.json.XXXXXX")
trap 'rm -rf "$work_dir"; rm -f "$missing_hashes"' EXIT
cp --recursive --no-preserve=mode "$src_path/." "$work_dir"

# The dependency cache is produced from the patched lockfile used by the build.
patch --directory="$work_dir" --strip=1 <"$package_dir/yarn-4.14-support.patch"
yarn-berry-fetcher missing-hashes "$work_dir/yarn.lock" >"$missing_hashes"
chmod 0644 "$missing_hashes"
mv "$missing_hashes" "$package_dir/missing-hashes.json"

# Refresh the fixed-output hash after the supplemental hashes are in place.
nix-update "$attr_path" --version skip
