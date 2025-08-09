#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix-update

set -euo pipefail

pushd "$(dirname "$0")" >/dev/null

ORG="WorksApplications"
REPO="SudachiDict"
VERSION="$(curl -s "https://api.github.com/repos/$ORG/$REPO/releases/latest" | jq -r '.tag_name' | sed 's/^v//')"

sed -i "s/version = \"[0-9]*\";/version = \"$VERSION\";/" package.nix

DICT_TYPES=("core" "small" "full")

for TYPE in "${DICT_TYPES[@]}"; do
  URL="https://github.com/$ORG/$REPO/releases/download/v$VERSION/sudachi-dictionary-$VERSION-$TYPE.zip"

  PLAIN_HASH=$(nix-prefetch-url --type sha256 "$URL" --unpack)
  HASH=$(nix --extra-experimental-features nix-command hash convert --hash-algo sha256 --to sri "$PLAIN_HASH")

  sed -i -E "/(${TYPE} = fetchzip \{|^ *url = .*${TYPE}\.zip\";\$)/,/^ *hash = / s|hash = \"[^\"]*\"|hash = \"$HASH\"|" package.nix
done

popd >/dev/null

nix-update "python3Packages.sudachidict-core" --version=skip
