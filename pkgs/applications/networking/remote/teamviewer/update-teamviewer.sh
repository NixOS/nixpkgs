#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash curl gnugrep jq nix nix-prefetch nix-prefetch-scripts common-updater-scripts

set -euo pipefail

current_version=$(nix eval --raw -f . teamviewer.version)
latest_version=$(curl -s https://www.teamviewer.com/en-us/download/portal/linux/ | grep -oP 'Current version: <span data-dl-version-label>\K[0-9]+\.[0-9]+\.[0-9]+')

echo "current version: $current_version"
echo "latest version:  $latest_version"

if [[ "$latest_version" == "$current_version" ]]; then
  echo "package is up-to-date"
  exit 0
fi

update-source-version teamviewer "$latest_version"

systems=$(nix eval --json -f . teamviewer.meta.platforms | jq --raw-output '.[]')
for system in $systems; do
  hash=$(nix --extra-experimental-features nix-command hash convert --to sri --hash-algo sha256 $(nix-prefetch-url $(nix eval --raw -f . teamviewer.src.url --system "$system")))
  update-source-version teamviewer $latest_version $hash --system=$system --ignore-same-version --ignore-same-hash
done
