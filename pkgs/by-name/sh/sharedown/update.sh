#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts curl jq yarn yarn2nix-moretea.yarn2nix nodejs

set -euo pipefail

SCRIPT_DIRECTORY=$(cd $(dirname ${BASH_SOURCE[0]}); cd -P $(dirname $(readlink ${BASH_SOURCE[0]} || echo .)); pwd)

latestVersion=$(curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} -sL "https://api.github.com/repos/kylon/Sharedown/releases/latest" | jq -r '.tag_name')
currentVersion=$(nix-instantiate --eval --expr 'with import ./. {}; sharedown.version' | tr -d '"')

if [[ "$currentVersion" == "$latestVersion" && "${BUMP_LOCK-}" != "1" ]]; then
    # Skip update when already on the latest version.
    exit 0
fi

update-source-version sharedown "$latestVersion"

sourceDir="$(nix-build -A sharedown.src --no-out-link)"
tempDir="$(mktemp -d)"

cp -r "$sourceDir"/* "$tempDir"
cd "$tempDir"
PUPPETEER_SKIP_DOWNLOAD=1 yarn install
yarn2nix >"${SCRIPT_DIRECTORY}/yarndeps.nix"
cp -r yarn.lock "${SCRIPT_DIRECTORY}"
