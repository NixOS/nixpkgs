#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=../../../../../ -i bash -p wget yarn2nix nix yarn jq

set -euo pipefail

if [ "$#" -ne 1 ] || [[ "$1" == -* ]]; then
  echo "Regenerates the Yarn dependency lock files for the element-desktop package."
  echo "Usage: $0 <git release tag>"
  exit 1
fi

RIOT_WEB_SRC="https://raw.githubusercontent.com/vector-im/element-desktop/$1"

# Here we deal with the so-called hakDependencies. They are not part of yarn.lock.
# Upstream doesn't add them to the dependencies field, because they want to prevent
# the install scripts to be run by npm/yarn. Fortunately, yarn2nix doesn't run
# install scripts by default, so it's okay to add them to the dependencies for us.
# For more information, read the description at
# https://github.com/vector-im/element-desktop/tree/v1.7.17/scripts/hak

TMPDIR="$(mktemp -d)"
trap "rm -rf $TMPDIR;" EXIT

pushd "$TMPDIR"

wget -O- "$RIOT_WEB_SRC/package.json" \
  | jq '. + { dependencies: (.dependencies + .hakDependencies) }' \
  > package.json

wget "$RIOT_WEB_SRC/yarn.lock"

# generate new entries in lockfile, since we changed the dependencies field
yarn --ignore-scripts

yarn2nix > yarn.nix

popd

cp $TMPDIR/package.json ./element-desktop-package.json
cp $TMPDIR/yarn.lock ./element-desktop-yarn.lock
cp $TMPDIR/yarn.nix ./element-desktop-yarndeps.nix
