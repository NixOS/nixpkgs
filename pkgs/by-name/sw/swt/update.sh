#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnugrep gnused unzip

set -e

latest_full_version() {
  local minor
  minor=$(curl -sL "https://api.github.com/repos/eclipse-platform/eclipse.platform.swt/git/matching-refs/tags/R4_" |
    grep -oE '"refs/tags/R4_[0-9]+"' | grep -oE '[0-9]+"$' | tr -d '"' | sort -n | tail -1)
  curl -sL "https://download.eclipse.org/eclipse/updates/4.${minor}/" |
    grep -oE "R-4\.${minor}-[0-9]{12}" | sort -u | tail -1
}

FULL_VERSION="${1:-$(latest_full_version)}"
if [ -z "$FULL_VERSION" ]; then
  echo "Could not determine the latest SWT release" >&2
  exit 1
fi
VERSION=$(echo "$FULL_VERSION" | sed -E 's/R-([0-9]+\.[0-9]+)-.*/\1/')
BASE_URL="https://download.eclipse.org/eclipse/downloads/drops4/${FULL_VERSION}/swt-${VERSION}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_NIX=$SCRIPT_DIR"/package.nix"

printf "Updating to version = %s; fullVersion = %s;\n" "$VERSION" "$FULL_VERSION"
sed -i "s/fullVersion = \".*\";/fullVersion = \"$FULL_VERSION\";/" "$PACKAGE_NIX"

PLATFORMS=(
  "x86_64-linux|gtk-linux-x86_64|true"
  "aarch64-linux|gtk-linux-aarch64|true"
  "ppc64le-linux|gtk-linux-ppc64le|true"
  "riscv64-linux|gtk-linux-riscv64|true"
  "aarch64-darwin|cocoa-macosx-aarch64|false"
)

for item in "${PLATFORMS[@]}"; do
  IFS='|' read -r NIX_PLAT E_PLAT IS_LINUX <<<"$item"
  URL="${BASE_URL}-${E_PLAT}.zip"

  if [ "$IS_LINUX" == "true" ]; then
    # Linux hashes cover only the extracted src.zip, see postFetch
    TMP_DIR=$(mktemp -d)
    curl -sfL "$URL" -o "$TMP_DIR/outer.zip"
    unzip -q "$TMP_DIR/outer.zip" src.zip -d "$TMP_DIR"
    mkdir "$TMP_DIR/out"
    unzip -q "$TMP_DIR/src.zip" -d "$TMP_DIR/out"
    HASH=$(nix --extra-experimental-features nix-command hash path "$TMP_DIR/out")
    rm -rf "$TMP_DIR"
  else
    HASH=$(nix-prefetch-url --type sha256 --unpack "$URL" 2>/dev/null)
    HASH=$(nix --extra-experimental-features nix-command hash to-sri --type sha256 "$HASH")
  fi

  sed -i "s|$NIX_PLAT.hash = \".*\";|$NIX_PLAT.hash = \"$HASH\";|" "$PACKAGE_NIX"
done
