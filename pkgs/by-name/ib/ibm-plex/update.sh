#! /usr/bin/env nix-shell
#! nix-shell -i bash -p nix nix-prefetch jq
#  shellcheck shell=bash
set -eo pipefail

SCRIPT_DIRECTORY=$(cd $(dirname ${BASH_SOURCE[0]}); cd -P $(dirname $(readlink ${BASH_SOURCE[0]} || echo .)); pwd)

families=(
    "serif"
    "sans"
    "sans-condensed"
    "sans-arabic"
    "sans-devanagari"
    "sans-thai"
    "sans-thai-looped"
    "sans-sc"
    "sans-tc"
    "sans-kr"
    "sans-jp"
    "sans-hebrew"
    "mono"
    "math"
)

version=$(curl --silent 'https://api.github.com/repos/IBM/plex/releases/latest' | jq -r '.tag_name | sub("^@ibm/[\\w-]+@"; "")')


echo \""${version}"\" >"${SCRIPT_DIRECTORY}/version-new.nix"
if diff -q "${SCRIPT_DIRECTORY}/version-new.nix" "${SCRIPT_DIRECTORY}/version.nix"; then
    echo No new version available, current: "$version"
    rm "${SCRIPT_DIRECTORY}/version-new.nix"
    exit 0
else
    echo Updated to version "$version"
    mv "${SCRIPT_DIRECTORY}/version-new.nix" "${SCRIPT_DIRECTORY}/version.nix"
fi

printf '{\n' > "${SCRIPT_DIRECTORY}/hashes.nix"

for family in "${families[@]}"; do
    url="https://github.com/IBM/plex/releases/download/%40ibm%2Fplex-${family}%40${version}/ibm-plex-${family}.zip"
    printf '  "%s" = "%s";\n' "$family" "$(nix-prefetch-url --unpack "$url" | xargs nix hash convert --hash-algo sha256)" >>"${SCRIPT_DIRECTORY}/hashes.nix"
done

printf '}\n' >> "${SCRIPT_DIRECTORY}/hashes.nix"
