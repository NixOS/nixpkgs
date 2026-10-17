#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nodejs curl gnused jq nix bash coreutils nix-update yarn-berry_4.yarn-berry-fetcher

set -eou pipefail

PACKAGE_DIR=$(realpath "$(dirname "$0")")
NEW_VERSION=$(npm view 'joplin' version)

if [[ "$UPDATE_NIX_OLD_VERSION" == "$NEW_VERSION" ]]; then
  echo "package is up-to-date: $UPDATE_NIX_OLD_VERSION"
  exit 0
fi

nix-update "$UPDATE_NIX_PNAME" --version "$NEW_VERSION" || true

WORKDIR=$(mktemp -d)

git clone "https://github.com/laurent22/joplin" -b "v$NEW_VERSION" "$WORKDIR/src"
pushd "$WORKDIR/src"
yarn-berry-fetcher missing-hashes yarn.lock >"$PACKAGE_DIR/missing-hashes.json"
popd
rm -rf "$WORKDIR"

nix-update "$UPDATE_NIX_PNAME" --version skip || true
