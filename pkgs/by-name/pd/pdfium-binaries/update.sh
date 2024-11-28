#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash nixVersions.latest curl coreutils jq common-updater-scripts

set -eou pipefail

latestVersion=$(curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} -sL https://api.github.com/repos/bblanchon/pdfium-binaries/releases/latest | jq -r '.tag_name | ltrimstr("chromium/")')
currentVersion=$(nix-instantiate --eval -E "with import ./. {}; pdfium-binaries.version" | tr -d '"')

echo "latest  version: $latestVersion"
echo "current version: $currentVersion"

if [[ "$latestVersion" == "$currentVersion" ]]; then
    echo "package is up-to-date"
    exit 0
fi

for i in \
    "x86_64-linux linux-x64" \
    "aarch64-linux linux-arm64" \
    "x86_64-darwin mac-x64" \
    "aarch64-darwin mac-arm64"; do
    set -- $i
    prefetch=$(nix-prefetch-url --unpack "https://github.com/bblanchon/pdfium-binaries/releases/download/chromium%2F$latestVersion/pdfium-$2.tgz")
    hash=$(nix hash convert --hash-algo sha256 --to sri $prefetch)
    update-source-version pdfium-binaries $latestVersion $hash --system=$1 --ignore-same-version
done
