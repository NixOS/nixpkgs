#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq perl nix
set -euo pipefail

ROOT="$(dirname "$(readlink -f "$0")")"
PACKAGE_NIX="$ROOT/package.nix"

latest_tag=$(curl -s ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} "https://api.github.com/repos/github/app/releases/latest" | jq -r .tag_name)
latest_version=${latest_tag#v}

current_version=$(grep -oP 'version = "\K[^"]+' "$PACKAGE_NIX")

if [[ "$current_version" == "$latest_version" ]]; then
    echo "Already up-to-date: $latest_version"
    exit 0
fi

sed -i "s/version = \"$current_version\"/version = \"$latest_version\"/" "$PACKAGE_NIX"

for arch in x86_64-linux aarch64-linux aarch64-darwin; do
  case $arch in
    x86_64-linux)
      url="https://github.com/github/app/releases/download/v${latest_version}/GitHub-Copilot-linux-x64.deb"
      ;;
    aarch64-linux)
      url="https://github.com/github/app/releases/download/v${latest_version}/GitHub-Copilot-linux-arm64.deb"
      ;;
    aarch64-darwin)
      url="https://github.com/github/app/releases/download/v${latest_version}/GitHub-Copilot-darwin-arm64.dmg"
      ;;
  esac

  raw_hash=$(nix-prefetch-url "$url")
  new_hash=$(nix-hash --to-sri --type sha256 "$raw_hash")
  perl -0777 -pi -e "s|($arch = fetchurl \\{\\s*url = \"[^\"]+\";\\s*hash = \")[^\"]+(\";)|\${1}${new_hash}\${2}|g" "$PACKAGE_NIX"
done
