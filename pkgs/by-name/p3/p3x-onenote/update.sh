#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix

set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"

latest_version() {
    curl -s "https://api.github.com/repos/patrikx3/onenote/releases/latest" | jq -r '.tag_name | sub("^v"; "")'
}

fetch_sri() {
    local version=$1
    local plat=$2
    local system=$3
    local hashi

    hash=$(nix-prefetch-url https://github.com/patrikx3/onenote/releases/download/v${version}/P3X-OneNote-${version}${plat}.AppImage)
    error=$?

    if [ $error -gt 0 ]; then
        echo "ERROR $error Fetching $version for $system" >&2
        return $error
    fi

    nix hash convert --hash-algo sha256 --to sri $hash --extra-experimental-features nix-command
}

system_plat() {
    case "$1" in
        x86_64-linux) echo "" ;;
        aarch64-linux) echo "-arm64" ;;
        *) echo "BAD SYSTEM: $1" >&2; exit 2 ;;
    esac
}

generate_json() {
    local version="$1"
    local systems=("x86_64-linux" "aarch64-linux")

    echo "{"
    echo "  \"version\": \"${version}\","
    echo "  \"hash\": {"

    local first=1
    for system in "${systems[@]}"; do
        local plat
        plat=$(system_plat "$system")

        local sri
        sri=$(fetch_sri "$version" "$plat" "$system")

        # JSON comma handling
        if [ $first -eq 0 ]; then
            echo ","
        fi
        first=0

        echo -n "    \"${system}\": \"${sri}\""
    done

    echo ""
    echo "  }"
    echo "}"
}

if [ -z "${VERSION:-}" ]; then
    echo "VERSION not set, fetching latest release…" >&2
    VERSION="$(latest_version)"
fi

echo "p3x-onenote: v$VERSION"
JSON=$(generate_json "$VERSION")
echo "$JSON" > "$SCRIPT_DIR/sources.json"

cat "$SCRIPT_DIR/sources.json"
