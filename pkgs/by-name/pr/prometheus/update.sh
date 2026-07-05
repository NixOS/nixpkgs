#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix coreutils curl jq nix-prefetch-git

set -euo pipefail

OWNER=prometheus
REPO=prometheus

# Current version.
LATEST_NIXPKGS_VERSION=$(nix eval --raw .#prometheus.version 2>/dev/null)
UPDATE_NIX_OLD_VERSION=${UPDATE_NIX_OLD_VERSION:-$LATEST_NIXPKGS_VERSION}

TARGET_TAG="$(curl -L -s ${GITHUB_TOKEN:+-u ":${GITHUB_TOKEN}"} "https://api.github.com/repos/$OWNER/$REPO/releases/latest" | jq -r '.tag_name')"
TARGET_VERSION="$(echo "$TARGET_TAG" | sed -e 's/^v//')"

if [[ "$UPDATE_NIX_OLD_VERSION" == "$TARGET_VERSION" ]]; then
    # prometheus is up-to-date
    if [[ -n "$UPDATE_NIX_ATTR_PATH" ]]; then
        echo "[{}]";
    fi

    exit 0
fi

FAKE_HASH="sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";

extractHash() {
    attr="${1?attr missing}"
    result="$(nix-build -A "$attr" 2>&1 | tail -n3 | grep 'got:' | cut -d: -f2- | xargs echo || true)"
    [ -z "$result" ] && { echo "$FAKE_HASH"; } || { echo "$result"; }
}

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

NIXPKGS_PROMETHEUS_PATH=$(cd $(dirname ${BASH_SOURCE[0]}); pwd -P)/
SOURCE_NIX="$NIXPKGS_PROMETHEUS_PATH/source.nix"

PREFETCH_JSON=$TMP/prefetch.json
nix-prefetch-git --rev "$TARGET_TAG" --url "https://github.com/$OWNER/$REPO" > "$PREFETCH_JSON"
PREFETCH_HASH="$(jq '.hash' -r < "$PREFETCH_JSON")"

cat > "$SOURCE_NIX" <<-EOF
{
  version = "$TARGET_VERSION";
  hash = "$PREFETCH_HASH";
  pnpmDepsHash = "$FAKE_HASH";
  vendorHash = "$FAKE_HASH";
}
EOF

VENDOR_HASH=$(extractHash prometheus.goModules)
PNPM_DEPS_HASH=$(extractHash prometheus.assets.pnpmDeps)

cat > "$SOURCE_NIX" <<-EOF
{
  version = "$TARGET_VERSION";
  hash = "$PREFETCH_HASH";
  pnpmDepsHash = "$PNPM_DEPS_HASH";
  vendorHash = "$VENDOR_HASH";
}
EOF

if [[ -z "$UPDATE_NIX_ATTR_PATH" ]]; then
    exit 0
fi

cat <<-EOF
[{
  "attrPath": "$UPDATE_NIX_ATTR_PATH",
  "oldVersion": "$UPDATE_NIX_OLD_VERSION",
  "newVersion": "$TARGET_VERSION",
  "files": ["$SOURCE_NIX"]
}]
EOF
