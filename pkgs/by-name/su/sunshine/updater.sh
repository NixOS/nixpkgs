#! /usr/bin/env nix-shell
#! nix-shell -i bash -p gnugrep curl jq nix-update

set -euo pipefail

version=$(curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} --silent --location https://api.github.com/repos/LizardByte/Sunshine/releases/latest | jq --raw-output .tag_name | grep -oP "^v\K.*")

if [[ "$UPDATE_NIX_OLD_VERSION" == "$version" ]]; then
    echo "Already up to date!"
    exit 0
fi

nix-update sunshine --version $version --generate-lockfile --subpackage ui
