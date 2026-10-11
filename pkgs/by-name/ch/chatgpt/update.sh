#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl libxml2 common-updater-scripts

XML_URL="https://persistent.oaistatic.com/codex-app-prod/appcast.xml"

XML_DATA=$(curl -s $XML_URL)

LATEST_VERSION=$(echo "$XML_DATA" | xmllint --xpath '/rss/channel/item[1]/*[local-name()="shortVersionString"]/text()' -)
DOWNLOAD_URL=$(echo "$XML_DATA" | xmllint --xpath 'string(//item[1]/enclosure/@url)' -)

HASH=$(nix-prefetch-url $DOWNLOAD_URL | xargs nix --extra-experimental-features nix-command hash convert --hash-algo sha256)

PACKAGE_NIX="$(dirname "${BASH_SOURCE[0]}")/darwin.nix"

update-source-version \
  chatgpt \
  "$LATEST_VERSION" \
  "$HASH" \
  "$DOWNLOAD_URL" \
  --system=aarch64-darwin \
  --file="$PACKAGE_NIX" \
  --ignore-same-version
