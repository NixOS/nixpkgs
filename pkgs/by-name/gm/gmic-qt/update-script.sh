#!@runtimeShell@

set -euo pipefail

export PATH="@pathTools@:$PATH"

latestVersion=$(curl 'https://gmic.eu/files/source/' \
                    | grep -E 'gmic_[^"]+\.tar\.gz' \
                    | sed -E 's/.+<a href="gmic_([^"]+)\.tar\.gz".+/\1/g' \
                    | sort --numeric-sort --reverse | head -n1)

if [[ "@version@" = "$latestVersion" ]]; then
    echo "The current version is the most recent."
    exit 0
fi

nix-update --version "$latestVersion"
