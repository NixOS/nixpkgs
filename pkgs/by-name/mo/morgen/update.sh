#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts

set -euo pipefail

# URL to check for the latest version
latestUrl="https://dl.todesktop.com/210203cqcj00tw1/linux/deb/x64"

# Fetch the latest version information
latestInfo=$(curl -sI -X GET $latestUrl | grep -oP 'morgen-\K\d+(\.\d+)*(?=[^\d])')

if [[ -z "$latestInfo" ]]; then
    echo "Could not find the latest version number."
    exit 1
fi

# Extract the version number
latestVersion=$(echo "$latestInfo" | head -n 1)

echo "Latest version of Morgen is $latestVersion"

# Update the package definition
update-source-version morgen "$latestVersion"

# Fetch and update the hash
nix-prefetch-url "https://dl.todesktop.com/210203cqcj00tw1/versions/${latestVersion}/linux/deb"
