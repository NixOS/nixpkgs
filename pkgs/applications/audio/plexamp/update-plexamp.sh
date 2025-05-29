#! /usr/bin/env nix-shell
#! nix-shell -p yq bash curl bc ripgrep
#! nix-shell -i bash

set -Eeuxo pipefail

cleanup() {
  rm -rf "$TMPDIR"
}

trap cleanup EXIT

ROOT="$(dirname "$(readlink -f "$0")")"
if [ ! -f "$ROOT/default.nix" ]; then
  echo "ERROR: cannot find default.nix in $ROOT"
  exit 1
fi

if [ "$(basename "$ROOT")" != plexamp ]; then
  echo "ERROR: folder not named plexamp"
  exit 1
fi

TMPDIR="$(mktemp -d)"

VERSION_FILE="$TMPDIR/version.yml"
VERSION_URL="https://plexamp.plex.tv/plexamp.plex.tv/desktop/latest-linux.yml"
curl "$VERSION_URL" -o "$VERSION_FILE"

VERSION="$(yq -r .version "$VERSION_FILE")"
SHA512="$(yq -r .sha512 "$VERSION_FILE")"

DEFAULT_NIX="$ROOT/default.nix"
WORKING_NIX="$TMPDIR/default.nix"
cp "$DEFAULT_NIX" "$WORKING_NIX"

sed -i "s@version = .*;@version = \"$VERSION\";@g" "$WORKING_NIX"

if diff "$DEFAULT_NIX" "$WORKING_NIX"; then
  echo "WARNING: no changes"
  exit 0
fi

# update sha hash (convenietly provided)
sed -i "s@hash.* = .*;@hash = \"sha512-$SHA512\";@g" "$WORKING_NIX"

# update the changelog ("just" increment the number)
# manually check that the changelog corresponds to our Plexamp version
CHANGELOG_URL=$(rg --only-matching 'changelog = "(.+)";' --replace '$1' $WORKING_NIX)
CHANGELOG_NUMBER=$(rg --only-matching '.*/([0-9]+)' --replace '$1' <<< $CHANGELOG_URL)
NEXT_CHANGELOG=$(($CHANGELOG_NUMBER + 1))
NEXT_URL=$(rg --only-matching '(.*)/[0-9]+' --replace "\$1/$NEXT_CHANGELOG" <<< $CHANGELOG_URL)
sed -i "s@changelog = \".*\";@changelog = \"$NEXT_URL\";@" $WORKING_NIX

mv $WORKING_NIX $DEFAULT_NIX
