#!/usr/bin/env bash

set -euo pipefail

VERSION="2.0.6"
BASE_URL="https://github.com/microsoft/pgsql-tools/releases/download/v${VERSION}"

declare -A ARCHES=(
  ["x86_64-linux"]="linux-x64"
  ["aarch64-linux"]="linux-arm64"
)

declare -A HASHES

for SYSTEM in "${!ARCHES[@]}"; do
  ARCH="${ARCHES[$SYSTEM]}"
  URL="${BASE_URL}/pgsqltoolsservice-${ARCH}.tar.gz"

  echo "Fetching for ${SYSTEM}..."
  HASH=$(nix-prefetch-url "$URL")
  echo "  hash = '$HASH'"
  HASHES["$SYSTEM"]="$HASH"
done

echo
echo "sha256 = selectSystem {"
for SYSTEM in "${!ARCHES[@]}"; do
  echo "  ${SYSTEM} = \"${HASHES[$SYSTEM]}\";"
done
echo "};"
