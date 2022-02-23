#!/usr/bin/env bash

set -euo pipefail

if [ "$#" -gt 2 ] || [[ "$1" == -* ]]; then
  echo "Regenerates packaging data for the zammad packages."
  echo "Usage: $0 [package name] [zammad directory in nixpkgs]"
  exit 1
fi

VERSION=$(curl -s https://ftp.zammad.com/ | grep -v latest | grep tar.gz | sed "s/<a href=\".*\">zammad-//" | sort -h | tail -n 1 | awk '{print $1}' | sed 's/.tar.gz<\/a>//')
TARGET_DIR="$2"
WORK_DIR=$(mktemp -d)
SOURCE_DIR=$WORK_DIR/zammad-$VERSION

pushd $TARGET_DIR

rm -rf \
    ./source.json \
    ./gemset.nix \
    ./yarn.lock \
    ./yarn.nix


# Check that working directory was created.
if [[ ! "$WORK_DIR" || ! -d "$WORK_DIR" ]]; then
    echo "Could not create temporary directory."
    exit 1
fi

# Delete the working directory on exit.
function cleanup {
  rm -rf "$WORK_DIR"
}
trap cleanup EXIT


pushd $WORK_DIR

echo ":: Creating source.json"
nix-prefetch-github zammad zammad --rev $VERSION --json > $TARGET_DIR/source.json
echo >> $TARGET_DIR/source.json

echo ":: Fetching source"
curl -L https://github.com/zammad/zammad/archive/$VERSION.tar.gz --output source.tar.gz
tar zxf source.tar.gz

if [[ ! "$SOURCE_DIR" || ! -d "$SOURCE_DIR" ]]; then
    echo "Source directory does not exists."
    exit 1
fi

pushd $SOURCE_DIR

echo ":: Creating gemset.nix"
bundix --lockfile=./Gemfile.lock  --gemfile=./Gemfile --gemset=$TARGET_DIR/gemset.nix

echo ":: Creating yarn.nix"
yarn install
cp yarn.lock $TARGET_DIR
yarn2nix > $TARGET_DIR/yarn.nix

# needed to avoid import from derivation
cp package.json $TARGET_DIR

popd
popd
popd
