#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl coreutils common-updater-scripts
set -eu -o pipefail

release=$(curl -s https://cursor.com/install | grep -oP "lab/\K[^/]+")

# Check if release matches the pattern YYYY.MM.DD-{commithash}
if [[ "$release" =~ ^[0-9]{4}\.[0-9]{2}\.[0-9]{2}-[a-f0-9]+$ ]]; then
  timestamp=$(echo "$release" | cut -d"-" -f1 | tr "." "-")
  latestVersion="0-unstable-$timestamp"
else
  latestVersion="$release"
fi

currentVersion=$(nix eval --raw -f . cursor-cli.version)

echo "latest  version: $latestVersion"
echo "current version: $currentVersion"

if [[ "$latestVersion" == "$currentVersion" ]]; then
  echo "package is up-to-date"
  exit 0
fi

declare -A platforms=( [x86_64-linux]="linux/x64" [aarch64-linux]="linux/arm64" [x86_64-darwin]="darwin/x64" [aarch64-darwin]="darwin/arm64" )

for platform in "${!platforms[@]}"; do
  url="https://downloads.cursor.com/lab/$release/${platforms[$platform]}/agent-cli-package.tar.gz"
  source=$(nix-prefetch-url "$url" --name "cursor-cli-$latestVersion")
  hash=$(nix-hash --to-sri --type sha256 "$source")
  update-source-version cursor-cli "$latestVersion" "$hash" "$url" --system="$platform" --source-key="sources.$platform" --ignore-same-version
done
