#!/usr/bin/env nix-shell
#!nix-shell -i bash -p asar curl dpkg gzip jq libxml2
# shellcheck shell=bash disable=SC2016

set -o errexit
set -o nounset
set -o pipefail
shopt -s inherit_errexit

BASE_URL="https://persistent.oaistatic.com/codex-app-prod"
# Mirrors the app's primary runtime resolver for public builds (release "latest").
RUNTIME_ARTIFACT="codex-primary-runtime"
RUNTIME_LAYER="2096615506"
RUNTIME_MANIFEST_BASE_URL="https://persistent.oaistatic.com"
STATSIG_API="https://ab.chatgpt.com/v1"

SOURCE_JSON=${SOURCE_JSON:-"$(dirname "${BASH_SOURCE[0]}")/source.json"}
work=$(mktemp -d)
updated=$(mktemp "$SOURCE_JSON.XXXXXXXX")
trap 'rm -rf -- "$work"; rm -f -- "$updated"' EXIT
cp "$SOURCE_JSON" "$work/source.json"

fetch() {
  curl --fail --location --silent --show-error --connect-timeout 15 --max-time 120 "$@"
}

update_json() {
  jq "$@" "$work/source.json" > "$work/next.json"
  mv "$work/next.json" "$work/source.json"
}

single_line() {
  [[ -n "$2" && "$2" != *$'\n'* ]] || { echo "Expected exactly one $1" >&2; exit 1; }
  printf '%s\n' "$2"
}

get_field() {
  sed -n "s/^$1: //p" <<< "$2" | head -n 1
}

source_hash() {
  local system="$1" version="$2" url="$3"
  local old_hash
  old_hash=$(jq -r --arg system "$system" --arg version "$version" --arg url "$url" \
    '.[$system] | select(.version == $version and .src.url == $url) | .src.hash' "$SOURCE_JSON")
  if [[ -n "$old_hash" ]]; then
    printf '%s\n' "$old_hash"
  else
    nix --extra-experimental-features nix-command hash convert \
      --hash-algo sha256 "$(nix-prefetch-url "$url")"
  fi
}

DARWIN_XML=$(fetch "$BASE_URL/appcast.xml")
DARWIN_VERSION=$(xmllint --xpath '/rss/channel/item[1]/*[local-name()="shortVersionString"]/text()' - <<< "$DARWIN_XML")
DARWIN_URL=$(xmllint --xpath 'string(//item[1]/enclosure/@url)' - <<< "$DARWIN_XML")
DARWIN_HASH=$(source_hash aarch64-darwin "$DARWIN_VERSION" "$DARWIN_URL")
update_json --arg version "$DARWIN_VERSION" --arg url "$DARWIN_URL" --arg hash "$DARWIN_HASH" \
  '.["aarch64-darwin"] |= (.version = $version | .src = {url: $url, hash: $hash})'

for pair in "x86_64-linux amd64" "aarch64-linux arm64"; do
  read -r system architecture <<< "$pair"
  metadata=$(fetch "$BASE_URL/linux/deb/dists/stable/main/binary-$architecture/Packages.gz" | gzip --decompress --stdout)
  [[ $(get_field Package "$metadata") == chatgpt ]]
  [[ $(get_field Architecture "$metadata") == "$architecture" ]]
  version=$(get_field Version "$metadata")
  url="$BASE_URL/linux/deb/$(get_field Filename "$metadata")"
  hash=$(source_hash "$system" "$version" "$url")
  update_json --arg system "$system" --arg version "$version" --arg url "$url" --arg hash "$hash" \
    '.[$system] |= (.version = $version | .src = {url: $url, hash: $hash})'
done

# The runtime config comes from a Statsig layer; take the client key and layer ID from the app.
deb=$(nix-prefetch-url --print-path \
  "$(jq -r '.["x86_64-linux"].src.url' "$work/source.json")" \
  "$(jq -r '.["x86_64-linux"].src.hash' "$work/source.json")" | tail -n 1)
dpkg-deb --fsys-tarfile "$deb" | tar -x -C "$work" ./usr/lib/chatgpt/resources/app.asar
asar_path="$work/usr/lib/chatgpt/resources/app.asar"
asar_files=$(asar list "$asar_path")
extract_asset() {
  local name
  name=$(single_line "$1 asset in app.asar" \
    "$(grep -E "^/webview/assets/$1-[0-9a-f]+\.js$" <<< "$asar_files" || true)")
  (cd "$work" && asar extract-file "$asar_path" "${name#/}")
  printf '%s\n' "$work/${name##*/}"
}
config_asset=$(extract_asset codex-runtimes-config)
grep -qF "getLayer(\`$RUNTIME_LAYER\`)" "$config_asset" \
  || { echo "The app no longer reads runtime config from Statsig layer $RUNTIME_LAYER" >&2; exit 1; }
key_asset=$(extract_asset statsig-client-key)
statsig_key=$(single_line "Statsig client key" "$(grep -oE '`client-[A-Za-z0-9]+`' "$key_asset" | tr -d '`' | sort -u || true)")

# Only the Linux app bundle is patched to use a Nix-managed runtime.
for entry in \
  "x86_64-linux linux x64 linux-x86_64" \
  "aarch64-linux linux arm64 linux-aarch64"; do
  read -r system platform arch config_platform <<< "$entry"
  version=$(jq -r --arg system "$system" '.[$system].version' "$work/source.json")

  # Same user shape as the app's pre-auth Statsig client.
  jq -n --arg version "$version" --arg platform "$platform" \
    '{user: {customIDs: {stableID: "nixpkgs-update"}, appVersion: $version, custom: {platform: $platform}}, hash: "djb2"}' \
    > "$work/statsig-request.json"
  fetch --config <(printf 'header = "STATSIG-API-KEY: %s"\n' "$statsig_key") \
    --header 'Content-Type: application/json' --data "@$work/statsig-request.json" \
    --output "$work/statsig.json" "$STATSIG_API/initialize"
  jq --arg layer "$RUNTIME_LAYER" --arg artifact "$RUNTIME_ARTIFACT" \
    '.layer_configs[$layer].value[$artifact] // {}' "$work/statsig.json" > "$work/config.json"

  # 1. The config's "latest" entry for this platform takes precedence.
  jq --arg key "$config_platform" \
    '.latest as $release | $release.platforms[$key]? // empty
      | {bundleVersion: $release.bundleVersion, archiveUrl: .providers[0].url, archiveSha256: .digest, format}' \
    "$work/config.json" > "$work/runtime.json"

  # 2. Otherwise fall back to the public LATEST.json manifest.
  if [[ ! -s "$work/runtime.json" ]]; then
    base_url=$(jq -r --arg default "$RUNTIME_MANIFEST_BASE_URL" '.baseUrl // $default | sub("/+$"; "")' "$work/config.json")
    manifest_url="$base_url/$RUNTIME_ARTIFACT/latest/$platform-$arch/LATEST.json"
    status=$(curl --location --silent --show-error --connect-timeout 15 --max-time 120 \
      --output "$work/runtime.json" --write-out '%{http_code}' "$manifest_url")
    if [[ "$status" == 404 ]]; then
      echo "No upstream primary runtime for $system" >&2
      update_json --arg system "$system" '.[$system].primaryRuntime = null'
      continue
    fi
    [[ "$status" == 200 ]] || { echo "$manifest_url returned HTTP $status" >&2; exit 1; }
  fi

  jq -e '(.bundleVersion | type == "string" and length > 0)
      and (.archiveUrl | type == "string" and startswith("https://"))
      and (.archiveSha256 | type == "string" and test("^[0-9a-fA-F]{64}$"))
      and ((.format // (.archiveUrl | capture("\\.(?<f>tar\\.(?:gz|xz)|zip)$").f // "tar.xz") | ascii_downcase)
        | IN("tar.gz", "tar.xz"))' \
    "$work/runtime.json" >/dev/null \
    || { echo "Unsupported primary runtime for $system: $(cat "$work/runtime.json")" >&2; exit 1; }
  runtime_hash=$(nix --extra-experimental-features nix-command hash convert \
    --hash-algo sha256 --to sri "$(jq -r '.archiveSha256' "$work/runtime.json")")
  update_json --arg system "$system" --arg hash "$runtime_hash" --slurpfile runtime "$work/runtime.json" \
    '.[$system].primaryRuntime = {version: $runtime[0].bundleVersion, src: {url: $runtime[0].archiveUrl, hash: $hash}}'
done

jq . "$work/source.json" > "$updated"
if cmp --silent "$updated" "$SOURCE_JSON"; then
  echo "chatgpt and its primary runtimes are already up to date" >&2
else
  chmod 644 "$updated"
  mv "$updated" "$SOURCE_JSON"
fi
