#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash nix curl coreutils jq common-updater-scripts

set -eou pipefail

latestVersion=$(curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} -sL \
  https://api.github.com/repos/Kotlin/kotlin-lsp/releases/latest \
  | jq -r '.tag_name | ltrimstr("kotlin-lsp/v")')
currentVersion=$(nix-instantiate --eval -E \
  "with import ./. {}; vscode-extensions.jetbrains.kotlin.version" | tr -d '"')

echo "latest  version: $latestVersion"
echo "current version: $currentVersion"

if [[ "$latestVersion" == "$currentVersion" ]]; then
    echo "package is up-to-date"
    exit 0
fi

update-source-version vscode-extensions.jetbrains.kotlin "$latestVersion" || true

for system in x86_64-linux aarch64-linux x86_64-darwin aarch64-darwin; do
    hash=$(nix --extra-experimental-features nix-command hash convert --to sri --hash-algo sha256 \
      $(nix-prefetch-url $(nix-instantiate --eval -E \
        "with import ./. {}; vscode-extensions.jetbrains.kotlin.src.url" \
        --system "$system" | tr -d '"')))
    update-source-version vscode-extensions.jetbrains.kotlin "$latestVersion" "$hash" \
      --system="$system" --ignore-same-version
done
