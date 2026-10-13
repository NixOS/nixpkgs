#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gzip jq libxml2 dpkg gawk
# shellcheck shell=bash

set -o errexit
set -o nounset
set -o pipefail

BASE_URL="https://persistent.oaistatic.com/codex-app-prod"
DARWIN_APPCAST_URL="$BASE_URL/appcast.xml"
LINUX_REPOSITORY_URL="$BASE_URL/linux/deb"

SOURCE_JSON=${SOURCE_JSON:-"$(dirname "${BASH_SOURCE[0]}")/source.json"}

fail() {
  echo "chatgpt update: $*" >&2
  exit 1
}

prefetch() {
  local url=$1 expected_size=$2 expected_hash=${3:-} version=${4:-} architecture=${5:-}
  local output hash path
  output=$(nix-prefetch-url --print-path "$url")
  hash=$(head -n 1 <<< "$output")
  path=$(tail -n 1 <<< "$output")
  [[ -f "$path" ]] || fail "prefetch did not return an artifact path"
  [[ $(wc -c < "$path") -eq "$expected_size" ]] || fail "artifact size mismatch for $url"
  hash=$(nix --extra-experimental-features nix-command hash convert --hash-algo sha256 "$hash")
  if [[ -n "$expected_hash" ]]; then
    [[ "$hash" == "$expected_hash" ]] || fail "artifact SHA256 mismatch for $url"
    [[ $(dpkg-deb --field "$path" Package) == chatgpt ]] || fail "unexpected Debian package"
    [[ $(dpkg-deb --field "$path" Version) == "$version" ]] || fail "Debian version mismatch"
    [[ $(dpkg-deb --field "$path" Architecture) == "$architecture" ]] || fail "Debian architecture mismatch"
  fi
  printf '%s\n' "$hash"
}

get_field() {
  local field="$1"
  local metadata="$2"

  local value
  value=$(awk -v field="$field" '
    index($0, field ":") == 1 {
      count++
      value = substr($0, length(field) + 2)
      sub(/^[ \t]+/, "", value)
    }
    END {
      if (count != 1 || value == "") exit 1
      print value
    }
  ' <<< "$metadata") || fail "missing or duplicate $field field"
  printf '%s\n' "$value"
}

select_linux_metadata() {
  # Keep every field within one matching Debian control paragraph.
  awk -v architecture="$1" '
    BEGIN { RS = ""; FS = "\n" }
    {
      package = arch = ""
      for (i = 1; i <= NF; i++) {
        if ($i ~ /^Package: /) package = substr($i, 10)
        if ($i ~ /^Architecture: /) arch = substr($i, 15)
      }
      if (package == "chatgpt" && arch == architecture) {
        print $0
        matches++
      }
    }
    END { if (matches != 1) exit 1 }
  '
}

fetch_linux_metadata() {
  local architecture="$1"

  curl --fail --location --silent --show-error \
    "$LINUX_REPOSITORY_URL/dists/stable/main/binary-$architecture/Packages.gz" \
    | gzip --decompress --stdout
}

DARWIN_XML=$(curl --fail --location --silent --show-error "$DARWIN_APPCAST_URL")
DARWIN_VERSION=$(xmllint --xpath '/rss/channel/item[1]/*[local-name()="shortVersionString"]/text()' - <<< "$DARWIN_XML")
DARWIN_URL=$(xmllint --xpath 'string(//item[1]/enclosure/@url)' - <<< "$DARWIN_XML")
DARWIN_SIZE=$(xmllint --xpath 'string(//item[1]/enclosure/@length)' - <<< "$DARWIN_XML")
[[ "$DARWIN_VERSION" =~ ^[0-9]+(\.[0-9]+)+$ ]] || fail "invalid Darwin version"
[[ "$DARWIN_URL" == "$BASE_URL/ChatGPT-darwin-arm64-$DARWIN_VERSION.zip" ]] || fail "unexpected Darwin URL"
[[ "$DARWIN_SIZE" =~ ^[1-9][0-9]*$ ]] || fail "invalid Darwin artifact size"

for pair in \
  "x86_64-linux amd64" \
  "aarch64-linux arm64"; do
  read -r system architecture <<< "$pair"
  metadata=$(fetch_linux_metadata "$architecture" | select_linux_metadata "$architecture") \
    || fail "expected one chatgpt record for $architecture"

  [[ $(get_field Package "$metadata") == chatgpt ]]
  [[ $(get_field Architecture "$metadata") == "$architecture" ]]

  version=$(get_field Version "$metadata")
  filename=$(get_field Filename "$metadata")
  size=$(get_field Size "$metadata")
  published_hash=$(get_field SHA256 "$metadata")
  [[ "$version" =~ ^[0-9]+(\.[0-9]+)+$ ]] || fail "invalid Linux version"
  [[ "$filename" == "pool/main/c/chatgpt/chatgpt_${version}_${architecture}.deb" ]] || fail "unexpected Debian artifact path"
  [[ "$size" =~ ^[1-9][0-9]*$ ]] || fail "invalid Debian artifact size"
  [[ "$published_hash" =~ ^[0-9a-f]{64}$ ]] || fail "invalid Debian SHA256"
  published_hash=$(nix --extra-experimental-features nix-command hash convert --hash-algo sha256 "$published_hash")

  if [[ "$system" == x86_64-linux ]]; then
    AMD64_VERSION=$version
    AMD64_URL="$LINUX_REPOSITORY_URL/$filename"
    AMD64_SIZE=$size
    AMD64_EXPECTED_HASH=$published_hash
  else
    ARM64_VERSION=$version
    ARM64_URL="$LINUX_REPOSITORY_URL/$filename"
    ARM64_SIZE=$size
    ARM64_EXPECTED_HASH=$published_hash
  fi
done

if [[ -f "$SOURCE_JSON" ]] && jq -e \
  --arg darwin_version "$DARWIN_VERSION" \
  --arg darwin_url "$DARWIN_URL" \
  --arg amd64_version "$AMD64_VERSION" \
  --arg amd64_url "$AMD64_URL" \
  --arg arm64_version "$ARM64_VERSION" \
  --arg arm64_url "$ARM64_URL" \
  --arg amd64_hash "$AMD64_EXPECTED_HASH" \
  --arg arm64_hash "$ARM64_EXPECTED_HASH" \
  '.["aarch64-darwin"].version == $darwin_version
    and .["aarch64-darwin"].src.url == $darwin_url
    and (.["aarch64-darwin"].src.hash | type) == "string"
    and (.["aarch64-darwin"].src.hash | test("^sha256-[A-Za-z0-9+/]{43}=$"))
    and .["x86_64-linux"].version == $amd64_version
    and .["x86_64-linux"].src.url == $amd64_url
    and .["aarch64-linux"].version == $arm64_version
    and .["aarch64-linux"].src.url == $arm64_url
    and .["x86_64-linux"].src.hash == $amd64_hash
    and .["aarch64-linux"].src.hash == $arm64_hash' \
  "$SOURCE_JSON" >/dev/null; then
  echo "chatgpt is already up to date" >&2
  exit 0
fi

DARWIN_HASH=$(prefetch "$DARWIN_URL" "$DARWIN_SIZE")
AMD64_HASH=$(prefetch "$AMD64_URL" "$AMD64_SIZE" "$AMD64_EXPECTED_HASH" "$AMD64_VERSION" amd64)
ARM64_HASH=$(prefetch "$ARM64_URL" "$ARM64_SIZE" "$ARM64_EXPECTED_HASH" "$ARM64_VERSION" arm64)

# Render beside the destination so rename is atomic and failures preserve it.
temporary_json=$(mktemp "$(dirname "$SOURCE_JSON")/.chatgpt-source.XXXXXX")
trap 'rm -f -- "$temporary_json"' EXIT
trap 'exit 1' HUP INT TERM

jq -n \
  --arg darwin_version "$DARWIN_VERSION" \
  --arg darwin_url "$DARWIN_URL" \
  --arg darwin_hash "$DARWIN_HASH" \
  --arg amd64_version "$AMD64_VERSION" \
  --arg amd64_url "$AMD64_URL" \
  --arg amd64_hash "$AMD64_HASH" \
  --arg arm64_version "$ARM64_VERSION" \
  --arg arm64_url "$ARM64_URL" \
  --arg arm64_hash "$ARM64_HASH" \
  '{
    "aarch64-darwin": {
      "version": $darwin_version,
      "src": { "url": $darwin_url, "hash": $darwin_hash }
    },
    "aarch64-linux": {
      "version": $arm64_version,
      "src": { "url": $arm64_url, "hash": $arm64_hash }
    },
    "x86_64-linux": {
      "version": $amd64_version,
      "src": { "url": $amd64_url, "hash": $amd64_hash }
    }
  }' > "$temporary_json"
chmod 644 "$temporary_json"
mv -- "$temporary_json" "$SOURCE_JSON"
