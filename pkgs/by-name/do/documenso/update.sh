#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl git nodejs_latest nix-update npm-lockfile-fix
set -xeou pipefail

WORKDIR=$(mktemp -d)
trap 'rm -rf "$WORKDIR"' EXIT

PACKAGE_DIR="$(realpath "$(dirname "$0")")"

# Get latest tag
NEW_VERSION=$(curl "https://api.github.com/repos/documenso/documenso/tags" | jq -r '.[] | .name' | sort --version-sort | tail -1)

if [[ "$UPDATE_NIX_OLD_VERSION" == "$NEW_VERSION" ]]; then
  echo "package is up to date: $UPDATE_NIX_OLD_VERSION"
  exit 0
fi

git clone "https://github.com/documenso/documenso" -b "$NEW_VERSION" "$WORKDIR/src"

pushd "$WORKDIR/src" || exit

echo "rm inngest-cli from root"
npm uninstall --package-lock-only inngest-cli

echo "adding node-addon-api dependency"
npm install --save-dev --package-lock-only node-addon-api

echo "fix package-lock.json hashes"
npm-lockfile-fix package-lock.json

git diff --no-ext-diff package-lock.json > "$PACKAGE_DIR/package-lock.json.patch"
git diff --no-ext-diff package.json > "$PACKAGE_DIR/package.json.patch"

popd || exit

nix-update "$UPDATE_NIX_PNAME"
