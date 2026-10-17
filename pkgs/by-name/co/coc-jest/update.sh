#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash nodejs nix-update git

WORKDIR=$(mktemp -d)
PACKAGE_DIR="$(realpath "$(dirname "$0")")"

# Clone source
git clone "https://github.com/neoclide/coc-jest" "$WORKDIR/src"
pushd "$WORKDIR/src"
npx --yes npm-package-lock-add-resolved

# Update package-lock patch
git diff >"$PACKAGE_DIR/package-lock-fix.patch"
popd

# Run nix-update
nix-update --version=branch "$UPDATE_NIX_PNAME"

# Cleanup
rm -rf "$WORKDIR"
