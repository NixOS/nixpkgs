#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash curl jq

set -xe

fetch() {
  platform=$1
  suffix=$2
  hash=$(nix-hash --to-sri --type sha256 "$(nix-prefetch-url "https://github.com/streetwriters/notesnook/releases/download/v$latestVersion/notesnook_$suffix")")
  printf '  %s = "%s";\n' "$platform" "$hash" >> "$dirname/hashes.nix"
}

dirname="$(dirname "$0")"

latestTag=$(curl ${GITHUB_TOKEN:+-u":$GITHUB_TOKEN"} https://api.github.com/repos/streetwriters/notesnook/releases/latest | jq -r ".tag_name")
latestVersion="$(expr "$latestTag" : 'v\(.*\)')"

sed -i "s/version = \"$UPDATE_NIX_OLD_VERSION\";/version = \"$latestVersion\";/" "$dirname/package.nix"

printf '{\n' > "$dirname/hashes.nix"
fetch x86_64-linux linux_x86_64.AppImage
fetch aarch64-linux linux_arm64.AppImage
fetch x86_64-darwin mac_x64.dmg
fetch aarch64-darwin mac_arm64.dmg
printf '}\n' >> "$dirname/hashes.nix"
