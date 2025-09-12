#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash nix curl coreutils jq common-updater-scripts

set -eou pipefail

latestVersion=$(curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} -sL https://api.github.com/repos/bblanchon/pdfium-binaries/releases/latest | jq -r '.tag_name | ltrimstr("chromium/")')
currentVersion=$(nix-instantiate --eval -E "with import ./. {}; pdfium-binaries.version or (lib.getVersion pdfium-binaries)" | tr -d '"')

echo "latest  version: $latestVersion"
echo "current version: $currentVersion"

if [[ "$latestVersion" == "$currentVersion" ]]; then
    echo "package is up-to-date"
    exit 0
fi

update-source-version pdfium-binaries $latestVersion || true

for system in \
    x86_64-linux \
    aarch64-linux \
    x86_64-darwin \
    aarch64-darwin; do
    hash=$(nix --extra-experimental-features nix-command hash convert --to sri --hash-algo sha256 $(nix-prefetch-url --unpack $(nix-instantiate --eval -E "with import ./. {}; pdfium-binaries.src.url" --system "$system" | tr -d '"')))
    update-source-version pdfium-binaries $latestVersion $hash --system=$system --ignore-same-version
done

for system in \
    x86_64-linux \
    aarch64-linux \
    x86_64-darwin \
    aarch64-darwin; do
    hash=$(nix --extra-experimental-features nix-command hash convert --to sri --hash-algo sha256 $(nix-prefetch-url --unpack $(nix-instantiate --eval -E "with import ./. {}; pdfium-binaries-v8.src.url" --system "$system" | tr -d '"')))
    update-source-version pdfium-binaries-v8 $latestVersion $hash --system=$system --ignore-same-version
done
