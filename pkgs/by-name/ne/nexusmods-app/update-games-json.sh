#!/usr/bin/env nix-shell
#! nix-shell -i bash -p bash curl common-updater-scripts jq

set -eu -o pipefail

# Set a default attrpath to allow running this update script directly
export UPDATE_NIX_ATTR_PATH="${UPDATE_NIX_ATTR_PATH:-"nexusmods-app"}"

save_url=https://web.archive.org/save
json_url=https://data.nexusmods.com/file/nexus-data/games.json
self=$(realpath "$0")
dir=$(dirname "$self")
curl_args=(
  "$save_url/$json_url"

  --silent
  --fail
  --location # follow redirects
  --head # we only need headers
  --output /dev/null # discard body
  --write-out '%{url_effective}'

  # Format --data-urlencode as GET query params
  --get
  # Instruct IA not to crawl linked content
  --data-urlencode capture_all=0
  # Only create a snapshot if older than 1 day
  --data-urlencode if_not_archived_within=86400
)
cd "$dir"/../../../../

# Ask the Internet Archive to save a snapshot of `games.json`
# We capture its 'HTTP 302 Found' redirect location
echo "Fetching games.json Internet Archive URL" >&2
url=$(curl "${curl_args[@]}")

# If the Internet Archive is having issues, they usually redirect to /sry
# but return status '200 OK'. Check this to avoid a bad url+hash:
if [[ "$url" = https://web.archive.org/sry* ]]; then
    echo "Internet Archive temporarily unavailable (redirected to /sry)" >&2
    exit 1
fi

# Use raw replay mode to avoid rewritten links in the JSON content
url=$(
  sed -E 's|^https://web\.archive\.org/web/([0-9]+)/|https://web.archive.org/web/\1id_/|' \
    <<<"$url"
)

# The query parameters are only used in the snapshot request,
# but remain in the redirected URL. Strip them:
url="${url%%\?*}"

current_url=$(
  nix-instantiate --eval --raw \
    --attr "$UPDATE_NIX_ATTR_PATH.gamesJson.url"
)
if [ "$current_url" = "$url" ]; then
  echo "games.json has no changes" >&2
  exit
fi

echo "Downloading and hashing games.json" >&2
prefetch_json=$(
  nix --extra-experimental-features nix-command \
    store prefetch-file --json "$url"
)
file=$(jq -r .storePath <<<"$prefetch_json")
hash=$(jq -r .hash <<<"$prefetch_json")

# Extra sanity check, validate the JSON:
if ! jq -e . "$file" >/dev/null; then
  {
    echo "Fetched file is not valid JSON (likely Internet Archive replay error):"
    echo "$file"
  } >&2
  exit 1
fi

# `update-source-version` needs the package version,
# even though we're updating the games.json source
package_version=$(
  nix-instantiate --eval --raw \
    --attr "$UPDATE_NIX_ATTR_PATH.version"
)

echo "Updating games.json source" >&2
update-source-version \
  "$UPDATE_NIX_ATTR_PATH" \
  "$package_version" \
  "$hash" \
  "$url" \
  --ignore-same-version \
  --source-key=gamesJson \
  --file="$dir"/package.nix
