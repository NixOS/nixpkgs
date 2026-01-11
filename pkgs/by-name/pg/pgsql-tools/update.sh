#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash curl jq nix nix-prefetch common-updater-scripts

set -euo pipefail

latestVersion=$(curl --fail --silent https://api.github.com/repos/microsoft/pgsql-tools/releases/latest | jq --raw-output '.tag_name | ltrimstr("v")')
currentVersion=$(nix eval --raw -f . pgsql-tools.version 2>/dev/null || echo "unknown")

echo "latest  version: $latestVersion"
echo "current version: $currentVersion"

if [[ "$latestVersion" == "$currentVersion" ]]; then
  echo "package is up-to-date"
  exit 0
fi

update-source-version pgsql-tools "$latestVersion" --file=pkgs/by-name/pg/pgsql-tools/package.nix

declare -A platforms=(
  ["x86_64-linux"]="pgsqltoolsservice-linux-x64.tar.gz"
  ["aarch64-linux"]="pgsqltoolsservice-linux-arm64.tar.gz"
  ["x86_64-darwin"]="pgsqltoolsservice-osx-x86.tar.gz"
  ["aarch64-darwin"]="pgsqltoolsservice-osx-arm64.tar.gz"
)

for system in "${!platforms[@]}"; do
  filename="${platforms[$system]}"
  url="https://github.com/microsoft/pgsql-tools/releases/download/v${latestVersion}/${filename}"

  echo "Updating hash for $system..."
  hash=$(nix --extra-experimental-features nix-command hash convert --to sri --hash-algo sha256 $(nix-prefetch-url "$url"))
  update-source-version pgsql-tools "$latestVersion" "$hash" --system="$system" --ignore-same-version --ignore-same-hash
done
