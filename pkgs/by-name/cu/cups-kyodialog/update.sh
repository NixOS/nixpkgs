#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl perl git htmlq jq nurl python3Packages.waybackpy
# shellcheck shell=bash
set -euo pipefail

attr="${UPDATE_NIX_ATTR_PATH:-cups-kyodialog}"
anchor_path="/us/en/printers/ECOSYSP2040DW"
downloads_url="https://www.kyoceradocumentsolutions.us/en/support/downloads.name-$(printf '%s' "$anchor_path" | base64 | tr -d '\n').html"

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

echo "$attr: archiving $live_url into the Wayback Machine ..."

wayback_result=$(waybackpy --url "$live_url" --save)

new_url=$(sed -n '2p' <<<"$wayback_result")

echo "$attr: created new Wayback url for src: $new_url"

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
