#!/usr/bin/env nix-shell
#!nix-shell -i bash -p jq curl nix
#shellcheck shell=bash
set -euo pipefail

# Upstream publishes on npm (prebuilt dist, no lockfile in the tarball) and
# keeps the matching package-lock.json under the "rea-agents-<version>" tag
# on GitHub. This script rewrites the three pinned anchors in package.nix
# (version, srcHash, lockfileHash); the npmDepsHash has to be updated
# manually from the failed-build error message.

PKG_DIR="$(cd "$(dirname "$0")" && pwd)"
REGISTRY="https://registry.npmjs.org/rea-agents"
REPO_RAW="https://raw.githubusercontent.com/morluto/rea"

NEW_VERSION=$(curl -fsS "$REGISTRY/latest" | jq -r .version)
OLD_VERSION=$(grep -oP '^\s*version = "\K[^"]+' "$PKG_DIR/package.nix" | head -1)
if [ "$NEW_VERSION" = "$OLD_VERSION" ]; then
  echo "latest version $NEW_VERSION is already packaged"
  exit 0
fi
echo "updating: $OLD_VERSION -> $NEW_VERSION"

WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

curl -fsSL "$REGISTRY/-/rea-agents-$NEW_VERSION.tgz" -o "$WORK/rea.tgz"
NEW_SRC_HASH="sha256-$(nix --extra-experimental-features nix-command hash file --base64 "$WORK/rea.tgz")"

curl -fsSL "$REPO_RAW/rea-agents-$NEW_VERSION/package-lock.json" -o "$WORK/package-lock.json"
# guard against tag mismatches (manually pushed tags, CDN quirks)
grep -q "\"version\": \"$NEW_VERSION\"" "$WORK/package-lock.json" || {
  echo "error: lockfile from tag does not match version $NEW_VERSION" >&2
  exit 1
}
NEW_LOCK_HASH="sha256-$(nix --extra-experimental-features nix-command hash file --base64 "$WORK/package-lock.json")"

sed -i "s/version = \"$OLD_VERSION\"/version = \"$NEW_VERSION\"/" "$PKG_DIR/package.nix"
sed -i "s|srcHash = \"sha256-[A-Za-z0-9+/=]*\"|srcHash = \"$NEW_SRC_HASH\"|" "$PKG_DIR/package.nix"
sed -i "s|lockfileHash = \"sha256-[A-Za-z0-9+/=]*\"|lockfileHash = \"$NEW_LOCK_HASH\"|" "$PKG_DIR/package.nix"
grep -q "version = \"$NEW_VERSION\"" "$PKG_DIR/package.nix"
grep -q "$NEW_SRC_HASH" "$PKG_DIR/package.nix"
grep -q "$NEW_LOCK_HASH" "$PKG_DIR/package.nix"

echo "done. Remaining manual step: rebuild and fill in the npmDepsHash from the error"
