#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p curl coreutils common-updater-scripts nix
BASEDIR="$(dirname "$0")/../../../.."

set -euo pipefail

# The package is unfree, so evaluating it (to read the current version and the
# per-system sources) requires unfree to be allowed.
export NIXPKGS_ALLOW_UNFREE=1

baseUrl="https://binaries.sonarsource.com/Distribution/sonarqube-cli"

latestVersion=$(curl -fsSL "$baseUrl/stable.version" | tr -d '[:space:]')
currentVersion=$(nix-instantiate --eval -E "with import ${BASEDIR} {}; lib.getVersion sonarqube-cli" | tr -d '"')

echo "latest  version: $latestVersion"
echo "current version: $currentVersion"

if [[ "$latestVersion" == "$currentVersion" ]]; then
    echo "package is up-to-date"
    exit 0
fi

# "<nix-system> <os-path-segment> <artifact-platform>"
for i in \
    "x86_64-linux linux linux-x86-64" \
    "aarch64-linux linux linux-arm64" \
    "aarch64-darwin macos macos-arm64"
do
    # shellcheck disable=SC2086 # $i is intentionally split into positional args
    set -- $i
    prefetch=$(nix-prefetch-url "$baseUrl/$latestVersion/$2/sonarqube-cli-$latestVersion-$3.bin")
    hash=$(nix-hash --type sha256 --to-sri "$prefetch")

    (cd "$BASEDIR" && update-source-version sonarqube-cli "$latestVersion" "$hash" --system="$1" --ignore-same-version)
done
