#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix

set -euo pipefail

PACKAGE_DIR="$(realpath "$(dirname "$0")")"
HTML="$(curl -sS https://www.devolo.com/en/software-downloads/cockpit)"

LINUX_URL="$(echo "$HTML" | grep -o 'https://[^"]*devolo-cockpit[^"]*\.zip' | head -n1 | sed -E 's|https://[^/]+|https://www.devolo.de|; s|\?.*||')"
DARWIN_URL="$(echo "$HTML" | grep -o 'https://[^"]*devolo-cockpit[^"]*\.dmg' | head -n1 | sed -E 's|https://[^/]+|https://www.devolo.de|; s|\?.*||')"

LATEST_VERSION="$(echo "$LINUX_URL" | sed -E 's/.*devolo-cockpit-v([0-9-]+?)(-linux)?\.zip/\1/' | tr '-' '.')"
CURRENT_VERSION="$(nix eval -f "$PACKAGE_DIR/sources.nix" --raw version || :)"

if [[ "$CURRENT_VERSION" != "$LATEST_VERSION" ]] || [[ "${1:-}" == "--force" ]]; then
  LINUX_HASH="$(nix store prefetch-file --json "$LINUX_URL" | jq -r .hash)"
  DARWIN_HASH="$(nix store prefetch-file --json "$DARWIN_URL" | jq -r .hash)"

  cat <<EOF > "$PACKAGE_DIR/sources.nix"
{
  version = "${LATEST_VERSION}";
  darwin = {
    url = "${DARWIN_URL}";
    hash = "${DARWIN_HASH}";
  };
  linux = {
    url = "${LINUX_URL}";
    hash = "${LINUX_HASH}";
  };
}
EOF
fi
