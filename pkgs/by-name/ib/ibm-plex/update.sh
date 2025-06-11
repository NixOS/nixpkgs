#! /usr/bin/env nix-shell
#! nix-shell -i bash -p nix nix-prefetch jq
#  shellcheck shell=bash
set -eo pipefail

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

dirname="$(dirname "$0")"
echo \""${version}"\" >"$dirname/version-new.nix"
if diff -q "$dirname/version-new.nix" "$dirname/version.nix"; then
    echo No new version available, current: "$version"
    rm "$dirname/version-new.nix"
    exit 0
else
    echo Updated to version "$version"
    mv "$dirname/version-new.nix" "$dirname/version.nix"
fi

printf '{\n' > "$dirname/hashes.nix"

for family in "${families[@]}"; do
    url="https://github.com/IBM/plex/releases/download/%40ibm%2Fplex-${family}%40${version}/ibm-plex-${family}.zip"
    printf '  "%s" = "%s";\n' "$family" "$(nix-prefetch-url --unpack "$url" | xargs nix hash convert --hash-algo sha256)" >>"$dirname/hashes.nix"
done

printf '}\n' >> "$dirname/hashes.nix"
