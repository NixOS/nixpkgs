#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts
set -eu -o pipefail

pkg_file="$(dirname "${BASH_SOURCE[0]}")/package.nix"

new_version=$(
    curl -s "https://api.github.com/repos/ValveResourceFormat/ValveResourceFormat/releases/latest" \
       | jq -r '.tag_name'
)

old_version=$(sed -nE 's/^\s*version = "([^"]+)";/\1/p' $pkg_file)

if [[ $new_version == $old_version ]]; then
    echo "latest version, no update required"
    exit 0
fi

[[ $new_version =~ ^[0-9]+\.[0-9]+$ ]] \
    && update-source-version source2viewer-cli "$new_version" \
    && $(nix-build -A source2viewer-cli.fetch-deps --no-out-link)
