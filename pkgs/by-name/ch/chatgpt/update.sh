#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl libxml2

XML_URL="https://persistent.oaistatic.com/sidekick/public/sparkle_public_appcast.xml"

XML_DATA=$(curl -s $XML_URL)

LATEST_VERSION=$(echo "$XML_DATA" | xmllint --xpath '/rss/channel/item[1]/*[local-name()="shortVersionString"]/text()' -)
DOWNLOAD_URL=$(echo "$XML_DATA" | xmllint --xpath 'string(//item[1]/enclosure/@url)' -)

HASH=$(nix-prefetch-url $DOWNLOAD_URL | xargs nix hash convert --hash-algo sha256)

SOURCE_NIX="$(dirname ${BASH_SOURCE[0]})/source.nix"

cat > "${SOURCE_NIX}" << _EOF_
{
  version = "$LATEST_VERSION";
  src = {
    url = "$DOWNLOAD_URL";
    hash = "$HASH";
  };
}
_EOF_
