#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash wget jq yarn yarn2nix nix-prefetch-github

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

if [ "$#" -gt 1 ] || [[ "${1:-}" == -* ]]; then
  echo "Regenerates packaging data for the vieb package."
  echo "Usage: $0 [git release tag]"
  exit 1
fi

version="${1:-}"

if [ -z "$version" ]; then
  version="$(wget -O- "https://api.github.com/repos/Jelmerro/Vieb/releases?per_page=1" | jq -r '.[0].tag_name')"
fi

SRC="https://raw.githubusercontent.com/Jelmerro/Vieb/$version"

tmpdir="$(mktemp -d --tmpdir update-vieb-XXXXXX)"
pushd "$tmpdir"

wget "$SRC/package-lock.json"
wget "$SRC/package.json"
yarn import
yarn2nix >yarn.nix

popd
cp -ft . "$tmpdir/"{package.json,yarn.lock,yarn.nix}
rm -rf "$tmpdir"

src_hash=$(nix-prefetch-github Jelmerro Vieb --rev "${version}" | jq -r .sha256)

cat > pin.json << EOF
{
  "version": "$version",
  "sha256": "$src_hash"
}
EOF
