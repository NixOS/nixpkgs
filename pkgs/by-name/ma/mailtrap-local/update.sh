#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix coreutils curl jq nix-prefetch-git prefetch-npm-deps

set -euo pipefail

OWNER=mailtrap
REPO=mailtrap-local

curlArgs=(-L -s)
if [[ -n "${GITHUB_TOKEN:-}" ]]; then
  curlArgs+=(-u ":${GITHUB_TOKEN}")
fi
TARGET_TAG="$(curl "${curlArgs[@]}" "https://api.github.com/repos/$OWNER/$REPO/releases/latest" | jq -r '.tag_name')"
TARGET_VERSION="${TARGET_TAG#v}"

if [[ "$UPDATE_NIX_OLD_VERSION" == "$TARGET_VERSION" ]]; then
  if [[ -n "$UPDATE_NIX_ATTR_PATH" ]]; then
    echo "[{}]"
  fi

  exit 0
fi

extractVendorHash() {
  local original="${1?original hash missing}"
  local result
  result="$(nix-build -A mailtrap-local.goModules 2>&1 | tail -n3 | grep 'got:' | cut -d: -f2- | xargs echo || true)"
  [[ -z "$result" ]] && echo "$original" || echo "$result"
}

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' exit

PACKAGE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
SOURCE_NIX="$PACKAGE_DIR/source.nix"

PREFETCH_JSON="$TMP/prefetch.json"
nix-prefetch-git --rev "$TARGET_TAG" --url "https://github.com/$OWNER/$REPO" > "$PREFETCH_JSON"
PREFETCH_HASH="$(jq -r '.hash' < "$PREFETCH_JSON")"
PREFETCH_PATH="$(jq -r '.path' < "$PREFETCH_JSON")"
NPM_DEPS_HASH="$(prefetch-npm-deps "$PREFETCH_PATH/frontend/package-lock.json")"

FAKE_HASH="sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="

cat > "$SOURCE_NIX" <<EOF
{
  version = "$TARGET_VERSION";
  hash = "$PREFETCH_HASH";
  npmDepsHash = "$NPM_DEPS_HASH";
  vendorHash = "$FAKE_HASH";
}
EOF

GO_HASH="$(nix-instantiate --eval --raw -A mailtrap-local.vendorHash)"
VENDOR_HASH="$(extractVendorHash "$GO_HASH")"

cat > "$SOURCE_NIX" <<EOF
{
  version = "$TARGET_VERSION";
  hash = "$PREFETCH_HASH";
  npmDepsHash = "$NPM_DEPS_HASH";
  vendorHash = "$VENDOR_HASH";
}
EOF

if [[ -z "$UPDATE_NIX_ATTR_PATH" ]]; then
  exit 0
fi

cat <<EOF
[{
  "attrPath": "$UPDATE_NIX_ATTR_PATH",
  "oldVersion": "$UPDATE_NIX_OLD_VERSION",
  "newVersion": "$TARGET_VERSION",
  "files": ["$SOURCE_NIX"]
}]
EOF
