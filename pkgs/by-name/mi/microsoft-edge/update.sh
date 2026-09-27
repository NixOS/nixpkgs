#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p curl gawk nix common-updater-scripts python3Packages.python-debian
# shellcheck shell=bash

set -euo pipefail

DEFAULT_NIX="$(realpath "./pkgs/by-name/mi/microsoft-edge/package.nix")"
DRIVER_NIX="$(realpath "./pkgs/by-name/ms/msedgedriver/package.nix")"

get_linux_version_info() {
    local packages_url
    local response
    local version
    local current_version
    local download_url

    packages_url="https://packages.microsoft.com/repos/edge/dists/stable/main/binary-amd64/Packages"

    response="$(curl --silent --fail "$packages_url")"
    read -r version download_url <<< "$(
        python3 -c '
import sys
from debian.deb822 import Packages
from debian.debian_support import Version

latest = None

for package in Packages.iter_paragraphs(sys.stdin, use_apt_pkg=False):
    if package["Package"] != "microsoft-edge-stable":
        continue

    if latest is None or latest.get_version() < package.get_version():
        latest = package

if latest is None:
    raise SystemExit("microsoft-edge-stable not found")

version = Version.re_valid_version.match(
    latest["Version"]
).group("upstream_version")

url = (
    "https://packages.microsoft.com/repos/edge/"
    + latest["Filename"]
)

print(version, url)
' <<< "$response"
    )"

    current_version="$(
        awk '
            /^  linux = stdenvNoCC.mkDerivation/ { in_block=1 }
            in_block && /version = "/ {
                match($0, /version = "([^"]+)"/, arr)
                print arr[1]
                exit
            }
            in_block && /^  \};/ { exit }
        ' "$DEFAULT_NIX"
    )"

    echo "$version" "$current_version" "$download_url"
}

get_darwin_version_info() {
    local redirect_url
    local final_url
    local version
    local current_version
    local uuid

    redirect_url="https://go.microsoft.com/fwlink/?linkid=2192091"

    final_url="$(
        curl \
            --silent \
            --show-error \
            --fail \
            --location \
            --output /dev/null \
            --write-out '%{url_effective}' \
            "$redirect_url"
    )"

    if [[ "$final_url" =~ /files/([^/]+)/MicrosoftEdge-([0-9.]+)\.dmg$ ]]; then
        uuid="${BASH_REMATCH[1]}"
        version="${BASH_REMATCH[2]}"
    else
        echo "Could not parse Darwin URL: $final_url" >&2
        exit 1
    fi

    current_version="$(
        awk '
            /^  darwin = stdenvNoCC.mkDerivation/ { in_block=1 }
            in_block && /version = "/ {
                match($0, /version = "([^"]+)"/, arr)
                print arr[1]
                exit
            }
            in_block && /^  \};/ { exit }
        ' "$DEFAULT_NIX"
    )"

    echo "$version" "$current_version" "$uuid" "$final_url"
}

update_linux() {
    local version_info
    local version
    local current_version
    local download_url
    local new_hash

    read -ra version_info <<< "$(get_linux_version_info)"

    version="${version_info[0]}"
    current_version="${version_info[1]}"
    download_url="${version_info[2]}"

    if [[ "$current_version" = "$version" ]]; then
        echo "[Nix] Linux microsoft-edge: same version"
        return 0
    fi

    new_hash="$(
        nix --extra-experimental-features nix-command \
            hash convert \
            --hash-algo sha256 \
            --to sri \
            "$(nix-prefetch-url "$download_url" 2>/dev/null)"
    )"

    sed -i \
        "/^  linux = stdenvNoCC.mkDerivation/,/^  });/s/version = \".*\"/version = \"$version\"/" \
        "$DEFAULT_NIX"

    sed -i \
        "/^  linux = stdenvNoCC.mkDerivation/,/^  });/s|hash = \".*\"|hash = \"$new_hash\"|" \
        "$DEFAULT_NIX"

    echo "[Nix] Linux microsoft-edge: $current_version -> $version with hash $new_hash"

}

update_darwin() {
    local version_info
    local version
    local current_version
    local uuid
    local url
    local new_hash

    read -ra version_info <<< "$(get_darwin_version_info)"

    version="${version_info[0]}"
    current_version="${version_info[1]}"
    uuid="${version_info[2]}"
    url="${version_info[3]}"

    if [[ "$current_version" = "$version" ]]; then
        echo "[Nix] Darwin microsoft-edge: same version"
        return 0
    fi

    new_hash="$(
        nix --extra-experimental-features nix-command \
            hash convert \
            --hash-algo sha256 \
            --to sri \
            "$(nix-prefetch-url "$url" 2>/dev/null)"
    )"

    sed -i \
        "/^  darwin = stdenvNoCC.mkDerivation/,/^  });/s/version = \".*\"/version = \"$version\"/" \
        "$DEFAULT_NIX"

    sed -i \
        "/^  darwin = stdenvNoCC.mkDerivation/,/^  });/s|uuid = \".*\"|uuid = \"$uuid\"|" \
        "$DEFAULT_NIX"

    sed -i \
        "/^  darwin = stdenvNoCC.mkDerivation/,/^  });/s|hash = \".*\"|hash = \"$new_hash\"|" \
        "$DEFAULT_NIX"

    echo "[Nix] Darwin microsoft-edge: $current_version -> $version with hash $new_hash"
}

update_msedgedriver() {
    local version="$1"
    local current_version
    local new_hash
    local driver_arch
    local url

    current_version="$(
        awk '
            /pname = "msedgedriver";/ { in_block=1 }
            in_block && /version = "/ {
                match($0, /version = "([^"]+)"/, arr)
                print arr[1]
                exit
            }
        ' "$DRIVER_NIX"
    )"

    if [[ "$current_version" = "$version" ]]; then
        echo "[Nix] msedgedriver: same version"
        return 0
    fi

    # All supported driver archives use the Linux Edge version.
    # The archive names correspond to the driverArch mapping in
    # msedgedriver/package.nix
    declare -A hashes=(
        [mac64_m1]=""
        [linux64]=""
    )

    for driver_arch in mac64_m1 linux64; do
        url="https://msedgedriver.microsoft.com/${version}/edgedriver_${driver_arch}.zip"

        new_hash="$(
            nix --extra-experimental-features nix-command \
                hash convert \
                --hash-algo sha256 \
                --to sri \
                "$(nix-prefetch-url --unpack "$url" 2>/dev/null)"
        )"

        hashes["$driver_arch"]="$new_hash"

        echo "[Nix] msedgedriver ${driver_arch}: $new_hash"
    done

    sed -i \
        "/pname = \"msedgedriver\";/,/^  meta = {/s/version = \".*\"/version = \"$version\"/" \
        "$DRIVER_NIX"

    for driver_arch in mac64_m1 linux64; do
        sed -i \
            "/pname = \"msedgedriver\";/,/^  meta = {/s|${driver_arch} = \".*\"|${driver_arch} = \"${hashes[$driver_arch]}\"|" \
            "$DRIVER_NIX"
    done

    echo "[Nix] msedgedriver: $current_version -> $version"
}

update_linux
update_darwin

# Linux is the canonical platform for the shared msedgedriver version
linux_version_info="$(get_linux_version_info)"
read -r linux_version _ _ <<< "$linux_version_info"

update_msedgedriver "$linux_version"
