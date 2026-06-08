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

# nixpkgs uses its own Python and only installs Linux/Darwin components.
# Drop unsupported component metadata to reduce the generated JSON file size.
curl -s "${CHANNEL_URL}/components-v${VERSION}.json" | jq '
    def is_bundled_python_component:
      .id | startswith("bundled-python3");

    def is_unsupported_os_only_component:
      (.platform.operating_systems // []) as $oses
      | ($oses | length > 0)
      and ([$oses[] | select(. == "LINUX" or . == "MACOSX")] | length == 0);

    def is_unsupported_component:
      is_bundled_python_component or is_unsupported_os_only_component;

    (.components | map(select(is_unsupported_component) | .id)) as $dropped
    |
    def drop_unsupported_dependencies:
      .dependencies = ((.dependencies // []) | map(. as $dep | select($dropped | index($dep) | not)));

    def drop_unsupported_operating_systems:
      if .platform.operating_systems then
        .platform.operating_systems |= map(select(. == "LINUX" or . == "MACOSX"))
      else
        .
      end;

    .components |= map(
      select(is_unsupported_component | not)
      | drop_unsupported_dependencies
      | drop_unsupported_operating_systems
    )
' > "${PACKAGE_DIR}/components.json"
