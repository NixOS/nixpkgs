#! /usr/bin/env nix-shell
#! nix-shell -i bash -p gnugrep coreutils curl jq nix-update prefetch-yarn-deps

set -euo pipefail
pushd "$(dirname "${BASH_SOURCE[0]}")"

owner="pomerium"
repo="pomerium"
version=`curl -s "https://api.github.com/repos/$owner/$repo/tags" | jq -r .[0].name | grep -oP "^v\K.*"`
url="https://raw.githubusercontent.com/$owner/$repo/v$version/"

if [[ "$UPDATE_NIX_OLD_VERSION" == "$version" ]]; then
    echo "Already up to date!"
    exit 0
fi

popd
nix-update pomerium --version $version
nix-update pomerium --version=skip --subpackage ui
