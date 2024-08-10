#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p curl jq gawk libossp_uuid libxml2 nix

set -euo pipefail

DEFAULT_NIX="$(realpath "./pkgs/by-name/go/google-chrome/package.nix")"

get_version_info() {
    local platform="$1"
    local start_pattern="$2"
    local end_pattern="$3"

    local url="https://versionhistory.googleapis.com/v1/chrome/platforms/${platform}/channels/stable/versions/all/releases"
    local response
    local version
    local current_version

    response="$(curl --silent --fail "$url")"
    version="$(jq ".releases[0].version" --raw-output <<< "$response")"
    current_version="$(awk "/${start_pattern}/,/${end_pattern}/ { if (\$0 ~ /version = \"/) { match(\$0, /version = \"([^\"]+)\"/, arr); print arr[1]; exit } }" "$DEFAULT_NIX")"

    echo "$version" "$current_version"
}

update_linux() {
    local version_info
    local version
    local current_version
    local new_hash
    local new_sri_hash

    read -ra version_info <<< "$(get_version_info "linux" "linux = stdenv.mkDerivation" "});")"
    version="${version_info[0]}"
    current_version="${version_info[1]}"

    if [[ "$current_version" = "$version" ]]; then
        echo "[Nix] Linux google chrome: same version"
        return 0
    fi

    local download_url="https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_${version}-1_amd64.deb"
    new_hash="$(nix-prefetch-url "$download_url" 2>/dev/null)"
    new_sri_hash="$(nix hash to-sri --type sha256 "$new_hash")"

    sed -i "/^  linux = stdenv.mkDerivation/,/^  });/s/version = \".*\"/version = \"$version\"/" "$DEFAULT_NIX"
    sed -i "/^  linux = stdenv.mkDerivation/,/^  });/s|hash = \".*\"|hash = \"$new_sri_hash\"|" "$DEFAULT_NIX"

    echo "[Nix] Linux google-chrome: $current_version -> $version with hash $new_hash"
}

update_darwin() {
    local version_info
    local version
    local current_version
    local uuid
    local url
    local pkg
    local manifest_version
    local new_hash
    local new_sri_hash

    read -ra version_info <<< "$(get_version_info "mac" "darwin = stdenvNoCC.mkDerivation" "});")"
    version="${version_info[0]}"
    current_version="${version_info[1]}"
    uuid="$(uuidgen)"

    if [[ "$current_version" = "$version" ]]; then
        echo "[Nix] Darwin google chrome: same version"
        exit 0
    fi

    local post_data="<?xml version='1.0' encoding='UTF-8'?>
    <request protocol='3.0' version='1.3.23.9' shell_version='1.3.21.103' ismachine='1'
        sessionid='$uuid' installsource='ondemandcheckforupdate'
        requestid='$uuid' dedup='cr'>
        <hw sse='1' sse2='1' sse3='1' ssse3='1' sse41='1' sse42='1' avx='1' physmemory='12582912' />
        <os platform='mac' version='$version' arch='arm64'/>
        <app appid='com.google.Chrome' ap=' ' version=' ' nextversion=' ' lang=' ' brand='GGLS' client=' '>
            <updatecheck/>
        </app>
    </request>"

    response="$(curl -s -X POST -H "Content-Type: text/xml" --data "$post_data" "https://tools.google.com/service/update2")"
    url="$(echo "$response" | xmllint --xpath "string(//url[contains(@codebase, 'http://dl.google.com/release2')]/@codebase)" -)"
    pkg="$(echo "$response" | xmllint --xpath "string(//package/@name)" -)"
    manifest_version="$(echo "$response" | xmllint --xpath "string(//manifest/@version)" -)"

    local download_url="$url$pkg"
    new_hash="$(nix hash to-sri --type sha256 "$(nix-prefetch-url "$download_url" 2>/dev/null)")"
    new_sri_hash="$(nix hash to-sri --type sha256 "$new_hash")"

    sed -i "/^  darwin = stdenvNoCC.mkDerivation/,/^  });/s/version = \".*\"/version = \"$manifest_version\"/" "$DEFAULT_NIX"
    sed -i "/^  darwin = stdenvNoCC.mkDerivation/,/^  });/s|hash = \".*\"|hash = \"$new_sri_hash\"|" "$DEFAULT_NIX"
    sed -i "/^  darwin = stdenvNoCC.mkDerivation/,/^  });/s|url = \".*\"|url = \"$download_url\"|" "$DEFAULT_NIX"

    echo "[Nix] Darwin google-chrome: $current_version -> $manifest_version with hash $new_hash"
}

update_linux
update_darwin
