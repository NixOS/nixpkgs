#! /usr/bin/env nix-shell
#! nix-shell -i bash -p curl common-updater-scripts

set -euo pipefail

# Scrape the pool directory since Microsoft doesn't keep Packages.gz up to date
pool_url="https://packages.microsoft.com/ubuntu/24.04/prod/pool/main/m/microsoft-identity-broker/"
pool_listing=$(curl -sL "$pool_url")

# Extract version from filenames like: microsoft-identity-broker_2.5.0-noble_amd64.deb
latest_version=$(echo "$pool_listing" \
    | grep -oP 'microsoft-identity-broker_\K[0-9]+\.[0-9]+\.[0-9]+' \
    | sort -V \
    | tail -n1)

if [[ -z "$latest_version" ]]; then
    echo "Failed to find any versions" >&2
    exit 1
fi

update-source-version microsoft-identity-broker "$latest_version" --file="$(dirname "$0")/package.nix"
