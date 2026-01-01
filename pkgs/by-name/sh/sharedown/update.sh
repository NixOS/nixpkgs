#!/usr/bin/env nix-shell
<<<<<<< HEAD
#!nix-shell -i bash -p common-updater-scripts curl gnugrep jq yarn yarn2nix-moretea.yarn2nix nix-update nodejs
# See git history for the version of this script that updated to tagged versions.

set -euo pipefail

nixpkgsDir="$PWD"

currentRev=$(nix-instantiate --eval --expr 'with import ./. {}; sharedown.src.rev' | tr -d '"')
nix-update --version=branch --src-only sharedown

latestRev=$(nix-instantiate --eval --expr 'with import ./. {}; sharedown.src.rev' | tr -d '"')
dirname="$(realpath "$(dirname "$0")")"
sourceDir="$(nix-build -A sharedown.src --no-out-link)"
tempDir="$(mktemp -d)"
trap 'chmod -R u+w $tempDir && rm -rf $tempDir' EXIT

if [[ "$currentRev" == "$latestRev" && "${BUMP_LOCK-}" != "1" ]]; then
=======
#!nix-shell -i bash -p common-updater-scripts curl jq yarn yarn2nix-moretea.yarn2nix nodejs

set -euo pipefail

latestVersion=$(curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} -sL "https://api.github.com/repos/kylon/Sharedown/releases/latest" | jq -r '.tag_name')
currentVersion=$(nix-instantiate --eval --expr 'with import ./. {}; sharedown.version' | tr -d '"')

if [[ "$currentVersion" == "$latestVersion" && "${BUMP_LOCK-}" != "1" ]]; then
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    # Skip update when already on the latest version.
    exit 0
fi

<<<<<<< HEAD
cp -r "$sourceDir"/* "$tempDir"
cd "$tempDir"
PUPPETEER_SKIP_DOWNLOAD=1 yarn install --mode update-lockfile
cp yarn.lock "$dirname"
cd "$nixpkgsDir"
update-source-version sharedown --ignore-same-version --source-key=offlineCache
=======
update-source-version sharedown "$latestVersion"

dirname="$(realpath "$(dirname "$0")")"
sourceDir="$(nix-build -A sharedown.src --no-out-link)"
tempDir="$(mktemp -d)"

cp -r "$sourceDir"/* "$tempDir"
cd "$tempDir"
PUPPETEER_SKIP_DOWNLOAD=1 yarn install
yarn2nix >"$dirname/yarndeps.nix"
cp -r yarn.lock "$dirname"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
