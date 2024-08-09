#!/usr/bin/env nix-shell
#! nix-shell -i bash -p common-updater-scripts jq

set -eou pipefail

latest_release="$(curl --silent 'https://api.github.com/repos/hyprwm/aquamarine/releases/latest')"

tag=$(jq -r '.tag_name' <<<"$latest_release")
# drop 'v' prefix
version="${tag#v}"

# update version; otherwise fail
update-source-version aquamarine "$version" --ignore-same-hash
