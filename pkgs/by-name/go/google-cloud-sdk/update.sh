#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nix jq curl

CHANNEL_URL="https://dl.google.com/dl/cloudsdk/channels/rapid"
BASE_URL="$CHANNEL_URL/downloads/google-cloud-sdk"

PACKAGE_DIR=$(dirname -- "$0")

VERSION=$(curl -s "$CHANNEL_URL/components-2.json" | jq -r '.version')

function genMainSrc() {
    local url="${BASE_URL}-${VERSION}-${1}-${2}.tar.gz"
    local sha256
    sha256=$(nix-prefetch-url "$url")
    echo " {"
    echo "      url = \"${url}\";"
    echo "      sha256 = \"${sha256}\";"
    echo "    };"
}

{
    cat <<EOF
# DO NOT EDIT! This file is generated automatically by update.sh
{ }:
{
  version = "${VERSION}";
  googleCloudSdkPkgs = {
EOF

    echo -n "    x86_64-linux ="
    genMainSrc "linux" "x86_64"

    echo -n "    x86_64-darwin ="
    genMainSrc "darwin" "x86_64"

    echo -n "    aarch64-linux ="
    genMainSrc "linux" "arm"

    echo -n "    aarch64-darwin ="
    genMainSrc "darwin" "arm"

    echo -n "    i686-linux ="
    genMainSrc "linux" "x86"

    echo "  };"
    echo "}"

} > "${PACKAGE_DIR}/data.nix"

# nixpkgs uses its own Python wrapper; do not generate bundled Python components.
curl -s "${CHANNEL_URL}/components-v${VERSION}.json" | jq '
    .components |= map(
      select(.id | startswith("bundled-python3") | not)
      | .dependencies = ((.dependencies // []) | map(select(startswith("bundled-python3") | not)))
    )
' > "${PACKAGE_DIR}/components.json"
