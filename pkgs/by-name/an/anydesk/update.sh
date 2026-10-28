#!/usr/bin/env -S nix shell nixpkgs#curl nixpkgs#jq nixpkgs#nix --command bash

set -euo pipefail

directory="$(dirname $0 | xargs realpath)"

new_version=$(
  curl -s https://rpm.anydesk.com/rhel/x86_64/Packages/ \
    | grep -oP 'anydesk_\K[0-9]+\.[0-9]+\.[0-9]+(?=-[0-9]+_x86_64\.rpm)' \
    | sort -V \
    | tail -1
)

old_version=$(jq -r '.version' "$directory/pin.json")

if [[ "$new_version" == "$old_version" ]]; then
  echo "anydesk is already up to date ($old_version)"
  exit 0
fi

echo "Updating anydesk: $old_version -> $new_version"

hash_amd64=$(nix hash to-sri --type sha256 \
  "$(nix-prefetch-url --type sha256 \
    "https://download.anydesk.com/linux/anydesk-${new_version}-amd64.tar.gz")")

hash_arm64=$(nix hash to-sri --type sha256 \
  "$(nix-prefetch-url --type sha256 \
    "https://download.anydesk.com/rpi/anydesk-${new_version}-arm64.tar.gz")")

cat > "$directory/pin.json" << EOF
{
  "version": "$new_version",
  "x86_64-linux": "$hash_amd64",
  "aarch64-linux": "$hash_arm64"
}
EOF

cat "$directory/pin.json"
