#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl dpkg nix

set -euo pipefail

BASE_URL="https://persistent.oaistatic.com/codex-app-prod/linux/deb/latest"

TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

AMD64_URL="$BASE_URL/chatgpt_amd64.deb"
ARM64_URL="$BASE_URL/chatgpt_arm64.deb"

curl -L "$AMD64_URL" -o "$TMPDIR/chatgpt_amd64.deb"
curl -L "$ARM64_URL" -o "$TMPDIR/chatgpt_arm64.deb"

VERSION="$(dpkg-deb -f "$TMPDIR/chatgpt_amd64.deb" Version)"
ARM_VERSION="$(dpkg-deb -f "$TMPDIR/chatgpt_arm64.deb" Version)"

if [[ "$VERSION" != "$ARM_VERSION" ]]; then
  echo "Version mismatch: amd64=$VERSION arm64=$ARM_VERSION" >&2
  exit 1
fi

AMD64_HASH="$(nix hash file --type sha256 --sri "$TMPDIR/chatgpt_amd64.deb")"
ARM64_HASH="$(nix hash file --type sha256 --sri "$TMPDIR/chatgpt_arm64.deb")"

SOURCE_NIX="$(dirname "${BASH_SOURCE[0]}")/source-linux.nix"

cat > "$SOURCE_NIX" <<EOF2
{
  version = "$VERSION";

  sources = {
    x86_64-linux = {
      url =
        "https://"
        + "persistent.oaistatic.com/codex-app-prod/linux/deb/latest/chatgpt_amd64.deb";
      hash = "$AMD64_HASH";
    };

    aarch64-linux = {
      url =
        "https://"
        + "persistent.oaistatic.com/codex-app-prod/linux/deb/latest/chatgpt_arm64.deb";
      hash = "$ARM64_HASH";
    };
  };
}
EOF2
