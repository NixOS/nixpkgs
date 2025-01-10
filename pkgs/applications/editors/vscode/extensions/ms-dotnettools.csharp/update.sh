#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p curl coreutils jq nix unzip
# shellcheck shell=bash
set -euo pipefail
shopt -s globstar
shopt -s dotglob

export LC_ALL=C

PUBLISHER=ms-dotnettools
EXTENSION=csharp
LOCKFILE=pkgs/applications/editors/vscode/extensions/$PUBLISHER.$EXTENSION/lockfile.json

response=$(curl -s 'https://marketplace.visualstudio.com/_apis/public/gallery/extensionquery' \
    -H 'accept: application/json;api-version=3.0-preview.1' \
    -H 'content-type: application/json' \
    --data-raw '{"filters":[{"criteria":[{"filterType":7,"value":"'"$PUBLISHER.$EXTENSION"'"}]}],"flags":16}')

# Find the latest version compatible with stable vscode version
latest_version=$(jq --raw-output '
.results[0].extensions[0].versions
| map(select(has("properties")))
| map(select(.properties | map(select(.key == "Microsoft.VisualStudio.Code.Engine")) | .[0].value | test("\\^[0-9.]+$")))
| map(select(.properties | map(select(.key == "Microsoft.VisualStudio.Code.PreRelease")) | .[0].value != "true"))
| .[0].version' <<<"$response")

current_version=$(jq '.version' --raw-output <"$LOCKFILE")

if [[ "$latest_version" == "$current_version" ]]; then
    echo "Package is up to date." >&2
    exit 1
fi

# Return success if the specified file is an ELF object.
isELF() {
    local fn="$1"
    local fd
    local magic
    exec {fd}<"$fn"
    read -r -n 4 -u "$fd" magic
    exec {fd}<&-
    if [ "$magic" = $'\177ELF' ]; then return 0; else return 1; fi
}

# Return success if the specified file is a Mach-O object.
isMachO() {
    local fn="$1"
    local fd
    local magic
    exec {fd}<"$fn"
    read -r -n 4 -u "$fd" magic
    exec {fd}<&-

    # nix uses 'declare -F' in get-env.sh to retrieve the loaded functions.
    # If we use the $'string' syntax instead of 'echo -ne' then 'declare' will print the raw characters and break nix.
    # See https://github.com/NixOS/nixpkgs/pull/138334 and https://github.com/NixOS/nix/issues/5262.

    # https://opensource.apple.com/source/lldb/lldb-310.2.36/examples/python/mach_o.py.auto.html
    if [[ "$magic" = $(echo -ne "\xfe\xed\xfa\xcf") || "$magic" = $(echo -ne "\xcf\xfa\xed\xfe") ]]; then
        # MH_MAGIC_64 || MH_CIGAM_64
        return 0
    elif [[ "$magic" = $(echo -ne "\xfe\xed\xfa\xce") || "$magic" = $(echo -ne "\xce\xfa\xed\xfe") ]]; then
        # MH_MAGIC || MH_CIGAM
        return 0
    elif [[ "$magic" = $(echo -ne "\xca\xfe\xba\xbe") || "$magic" = $(echo -ne "\xbe\xba\xfe\xca") ]]; then
        # FAT_MAGIC || FAT_CIGAM
        return 0
    else
        return 1
    fi
}

getDownloadUrl() {
    nix-instantiate \
        --eval \
        --strict \
        --json \
        pkgs/applications/editors/vscode/extensions/mktplcExtRefToFetchArgs.nix \
        --attr url \
        --argstr publisher $PUBLISHER \
        --argstr name $EXTENSION \
        --argstr version "$latest_version" \
        --argstr arch "$1" | jq . --raw-output
}

TEMP=$(mktemp --directory --tmpdir)
OUTPUT="$TEMP/lockfile.json"
trap 'rm -r "$TEMP"' EXIT

HASH=
BINARIES=()
fetchMarketplace() {
    arch="$1"

    echo "  Downloading VSIX..."
    if ! curl -sLo "$TEMP/$arch".zip "$(getDownloadUrl "$arch")"; then
        echo "    Failed to download extension for arch $arch" >&2
        exit 1
    fi

    HASH=$(nix hash file --type sha256 --sri "$TEMP/$arch".zip)
    BINARIES=()

    echo "  Extracting VSIX..."
    mkdir "$TEMP/$arch"
    if ! unzip "$TEMP/$arch".zip -d "$TEMP/$arch" >/dev/null; then
        echo "    Failed to unzip extension for arch $arch" >&2
        file "$TEMP/$arch".zip >&2
        exit 1
    fi

    echo "  Listing binaries..."
    for file in "$TEMP/$arch"/**/*; do
        if [[ ! -f "$file" || "$file" == *.so || "$file" == *.dylib ]] ||
            (! isELF "$file" && ! isMachO "$file"); then
            continue
        fi

        echo "    FOUND: ${file#"$TEMP/$arch/extension/"}"
        BINARIES+=("${file#"$TEMP/$arch/extension/"}")
    done
    rm -r "${TEMP:?}/$arch"
}

cat >"$OUTPUT" <<EOF
{
  "version": "$latest_version",
EOF
firstArch=true
for arch in linux-x64 linux-arm64 darwin-x64 darwin-arm64; do
    if [ "$firstArch" = false ]; then
        echo -e ',' >>"$OUTPUT"
    fi
    firstArch=false

    echo "Getting data for $arch..."
    fetchMarketplace "$arch"

    cat >>"$OUTPUT" <<EOF
  "$arch": {
    "hash": "$HASH",
    "binaries": [
EOF

    firstBin=true
    for binary in "${BINARIES[@]}"; do
        if [ "$firstBin" = false ]; then
            echo -e ',' >>"$OUTPUT"
        fi
        firstBin=false

        echo -n "      \"$binary\"" >>"$OUTPUT"
    done
    echo -ne '\n    ]\n  }' >>"$OUTPUT"
done
echo -e '\n}' >>"$OUTPUT"

mv "$OUTPUT" "$LOCKFILE"
