#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash nodejs nix-update git curl jq

WORKDIR=$(mktemp -d)
PACKAGE_DIR="$(realpath "$(dirname "$0")")"

# Get latest tag
NEW_VERSION=$(curl "https://api.github.com/repos/neoclide/coc-pairs/tags" | jq -r '.[] | .name' | sort --version-sort | tail -1)

if [[ "$UPDATE_NIX_OLD_VERSION" == "$NEW_VERSION" ]]; then
  echo "package is up to date: $UPDATE_NIX_OLD_VERSION"
  exit 0
fi

# Clone source
git clone "https://github.com/neoclide/coc-pairs" -b "$NEW_VERSION" "$WORKDIR/src"
pushd "$WORKDIR/src"
npx --yes npm-package-lock-add-resolved

# Update package-lock patch
git diff >"$PACKAGE_DIR/package-lock-fix.patch"
popd

# Run nix-update
nix-update "$UPDATE_NIX_PNAME"

# Cleanup
rm -rf "$WORKDIR"
