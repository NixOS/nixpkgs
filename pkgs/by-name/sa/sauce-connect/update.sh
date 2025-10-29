#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts curl jq
# API documentation: https://docs.saucelabs.com/dev/api/connect/

set -Eeuo pipefail
shopt -s lastpipe
die() {
    echo -e "${BASH_SOURCE[0]}:${BASH_LINENO[0]}" ERROR: "$@" >&2
    exit 1
}
# shellcheck disable=2154
trap 's=$?; die "$BASH_COMMAND"; exit $s' ERR

# Versions may not be updated simultaneously across all platforms, so need to figure out the latest
# version that includes both platforms. For example, currently the latest on Linux is 4.9.2 while
# Mac is 4.9.1.
response=$(curl -fsSL 'https://api.us-west-1.saucelabs.com/rest/v1/public/tunnels/info/versions?all=true')
all_versions=$(jq --exit-status --raw-output \
    '.all_downloads | to_entries[] | select(.value | has("linux") and has("osx")) | .key' \
    <<< "$response")
latest_version=$(sort --version-sort <<< "$all_versions" | tail -n 1)
for platform in x86_64-linux aarch64-linux x86_64-darwin; do
    update-source-version sauce-connect "$latest_version" \
        --ignore-same-version \
        --source-key="passthru.sources.$platform"
done
