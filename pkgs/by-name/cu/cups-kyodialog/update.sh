#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl nix perl git htmlq jq nurl
# shellcheck shell=bash

# Kyocera ships no GitHub/GitLab releases page nix-update understands,
# and its download-center search is entirely client-side JS with no
# documented API. Any Kyocera printer's product page has a server-
# rendered downloads.name-<base64>.html variant though, which embeds
# the whole download catalog as JSON in a `dc-models-json` attribute --
# including the current version of the generic Linux driver bundle this
# derivation fetches. ECOSYS P2040dw below is just a stable, verified
# anchor page; unrelated to which printer this overlay is actually used
# with.

set -euo pipefail

attr="${UPDATE_NIX_ATTR_PATH:-cups-kyodialog}"
anchor_path="/us/en/printers/ECOSYSP2040DW"
downloads_url="https://www.kyoceradocumentsolutions.us/en/support/downloads.name-$(printf '%s' "$anchor_path" | base64 | tr -d '\n').html"

# Mirrors what nix-update itself does (see nix_update/eval.nix upstream).
# getFlake + engine flags so the eval is reproducible on the nixpkgs
# runner's machine, whose nix.conf may not enable flakes by default.
repo_root=$(git rev-parse --show-toplevel)
system=$(nix eval --impure --raw --expr 'builtins.currentSystem')

result=$(nix --extra-experimental-features 'nix-command flakes' eval --impure --raw --expr "
  let
    flake = builtins.getFlake \"$repo_root\";
    pkg = flake.legacyPackages.\"$system\".\"$attr\";
    pos = builtins.unsafeGetAttrPos \"version\" pkg;
    outPath = toString flake.outPath;
    relFile = builtins.substring (builtins.stringLength outPath) (-1) pos.file;
  in
  relFile + \"\n\" + pkg.version + \"\n\" + pkg.src.url + \"\n\" + pkg.src.outputHash
")

deriv_file="$repo_root$(printf '%s' "$result" | sed -n 1p)"
old_version=$(printf '%s' "$result" | sed -n 2p)
old_url=$(printf '%s' "$result" | sed -n 3p)
old_hash=$(printf '%s' "$result" | sed -n 4p)

page_html=$(curl -sSL -A "Mozilla/5.0" "$downloads_url")

catalog_json=$(htmlq -a dc-models-json '[dc-models-json]' <<< "$page_html")
if [[ -z "$catalog_json" ]]; then
  echo "$attr: failed to find catalog json on $downloads_url" >&2
  exit 1
fi

entry_json=$(jq -ec '.[] | select(.resTitle == "Linux Print Driver")' <<< "$catalog_json") || {
  echo "$attr: failed to find the Linux driver entry on $downloads_url" >&2
  exit 1
}

new_version=$(jq -r '.title | capture("\\((?<v>[0-9.]+)\\)").v' <<<"$entry_json")
new_link=$(jq -r '.dcLink' <<<"$entry_json")

if [[ "$new_version" == "$old_version" ]]; then
  echo "$attr: already up to date ($old_version)"
  exit 0
fi

echo "$attr: found new version ($new_version); updating ..."

live_url="https://www.kyoceradocumentsolutions.us${new_link}"

# Kyocera's own link isn't reproducible: its filename's embedded date
# has stayed "20240521" across at least two different real releases
# (9.4 and 10.1 both), so the same URL can silently serve different
# content on a later rebuild. Pin an immutable Wayback Machine snapshot
# as the sole src instead.
echo "$attr: archiving $live_url into the Wayback Machine ..."

save_html=$(
  curl -sS \
    --max-time 60 \
    -A "Mozilla/5.0" \
    -X POST \
    --data-urlencode "url=$live_url" \
    --data "force_get=1" \
    "https://web.archive.org/save/"
)

# Anonymous Save Page Now returns an HTML page containing the job ID in
# a JavaScript call:
#
#   spn.watchJob("spn2-...", ...)
job_id=$(
  htmlq -t 'script' <<< "$save_html" |
    grep -oE 'spn\.watchJob\("[^"]+"' |
    sed -E 's/.*"([^"]+)".*/\1/' |
    head -n1
)

if [[ -z "$job_id" ]]; then
  echo "$attr: failed to find Wayback save job ID" >&2
  exit 1
fi

echo "$attr: Wayback save job: $job_id"

new_url=""
deadline=$((SECONDS + 600))

while (( SECONDS < deadline )); do
  # Note: _t is cache buster
  status_response=$(curl -sS --max-time 60 -A "Mozilla/5.0" "https://web.archive.org/save/status/$job_id?_t=$SECONDS")
  capture_status=$(jq -r '.status // empty' <<< "$status_response")

  case "$capture_status" in
    success)
      timestamp=$(jq -er '.timestamp' <<< "$status_response")
      original_url=$(jq -er '.original_url' <<< "$status_response")
      new_url="https://web.archive.org/web/${timestamp}/${original_url}"
      break
      ;;

    error)
      message=$(jq -r '.message // "unknown error"' <<< "$status_response")
      echo "$attr: Wayback save job $job_id failed: $message" >&2
      exit 1
      ;;

    pending|"")
      sleep 5
      ;;

    *)
      echo "$attr: unexpected Wayback save status '$capture_status': $status_response" >&2
      exit 1
      ;;
  esac
done

if [[ -z "$new_url" ]]; then
  echo "$attr: timed out waiting for Wayback save job $job_id" >&2
  exit 1
fi

echo "$attr: created new Wayback url for src: $new_url"

# postFetch deletes files, so the fixed-output hash covers the
# *processed* tree, not the raw download -- nix-prefetch-url can't help
# here. nurl builds the derivation with a deliberately wrong hash and
# reads the real one off the resulting mismatch.
new_hash=$(
  NEW_URL="$new_url" \
    nurl --hash --expr "
      let
        flake = builtins.getFlake \"$repo_root\";
        pkgs = flake.legacyPackages.\"$system\";
        pkg = pkgs.\"$attr\";
        src = pkg.src;
      in pkg.src.overrideAttrs (_: {
        urls = [ (builtins.getEnv \"NEW_URL\") ];
      })
    " 2> /dev/null
)

if [[ -z "$new_hash" ]]; then
  echo "$attr: could not determine hash for $new_url" >&2
  exit 1
fi

# Replace literally with perl: \Q..\E quotes the search string so the SRI hash
# and URL (which contain '+', '/', etc.) are matched verbatim, unlike sed -E.
replace_lit() {
  local old="$1" new="$2" file="$3"
  OLD="$old" NEW="$new" perl -i -pe 's/\Q$ENV{OLD}\E/$ENV{NEW}/' "$file"
}

replace_lit "version = \"$old_version\"" "version = \"$new_version\"" "$deriv_file"
replace_lit "url = \"$old_url\"" "url = \"$new_url\"" "$deriv_file"
replace_lit "hash = \"$old_hash\"" "hash = \"$new_hash\"" "$deriv_file"

echo "$attr: $old_version -> $new_version"
