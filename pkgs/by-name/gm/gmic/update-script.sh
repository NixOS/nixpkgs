#!@runtimeShell@

set -euo pipefail
export PATH="@pathTools@":$PATH

latestVersion=$(curl 'https://gmic.eu/files/source/' \
                    | grep -E 'gmic_[^"]+\.tar\.gz' \
                    | sed -E 's/.+<a href="gmic_([^"]+)\.tar\.gz".+/\1/g' \
                    | sort --numeric-sort --reverse | head -n1)

if [[ "@version@" = "$latestVersion" ]]; then
    echo "The current version is the most recent."
    exit 0
fi

for component in src gmic_stdlib; do
    # The script will not perform an update when the version attribute is up to
    # date from previous platform run; we need to clear it before each run
    update-source-version "--source-key=$component" "gmic" 0 "${lib.fakeHash}"
    update-source-version "--source-key=$component" "gmic" $latestVersion
done

