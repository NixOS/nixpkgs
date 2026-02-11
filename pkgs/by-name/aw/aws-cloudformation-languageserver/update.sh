#!/usr/bin/env nix-shell
#!nix-shell -p curl jq nix
#!nix-shell -i bash

set -e

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
OUT_FILE="${SCRIPT_DIR}/sources.json"
WORK_DIR=$(mktemp -d)
# Auto-detect latest version from GitHub releases
VERSION=$(curl -s ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} https://api.github.com/repos/aws-cloudformation/cloudformation-languageserver/releases/latest | jq -r '.tag_name | ltrimstr("v")')

PLATFORMS=(
  "x86_64-linux:linux-x64"
  "aarch64-linux:linux-arm64"
  "x86_64-darwin:darwin-x64"
  "aarch64-darwin:darwin-arm64"
)

for pair in "${PLATFORMS[@]}"; do
  (
    SYSTEM="${pair%%:*}"
    SUFFIX="${pair##*:}"

    URL="https://github.com/aws-cloudformation/cloudformation-languageserver/releases/download/v${VERSION}/cloudformation-languageserver-${VERSION}-${SUFFIX}-node22.zip"

    HASH=$(nix store prefetch-file --unpack --json "$URL" | jq -r .hash)
    echo "Prefetched $SYSTEM"

    jq -n \
      --arg s "$SYSTEM" \
      --arg u "$URL" \
      --arg h "$HASH" \
      '{($s): {url: $u, sha256: $h}}' >"$WORK_DIR/$SYSTEM.json"
  ) &
done

wait

jq -n --arg v "$VERSION" '{version: $v}' >"$WORK_DIR/aaaversion.json"
jq -s 'add' "$WORK_DIR"/*.json >"$OUT_FILE"

echo "Done! Wrote to $OUT_FILE"
