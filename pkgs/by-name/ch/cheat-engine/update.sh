#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl nix perl git
# shellcheck shell=bash

# Cheat Engine ships no GitHub/GitLab releases page that nix-update
# understands, but its downloads page is the canonical source of the
# latest Linux zip. Version "7.7.1" is encoded in the URL as "771".

set -euo pipefail

attr="${UPDATE_NIX_ATTR_PATH:-cheat-engine}"
downloads_url="https://cheatengine.org/downloads.php"
base_url="https://cheatengine.org/download/"

repo_root="$(git rev-parse --show-toplevel)"
system="$(nix eval --impure --raw --expr 'builtins.currentSystem')"

result="$(nix --extra-experimental-features 'nix-command flakes' eval --impure --raw --expr "
  let
    flake = builtins.getFlake \"$repo_root\";
    pkg = flake.legacyPackages.\"$system\".\"$attr\";
    pos = builtins.unsafeGetAttrPos \"version\" pkg;
    outPath = toString flake.outPath;
    relFile = builtins.substring (builtins.stringLength outPath) (-1) pos.file;
  in
  relFile + \"\n\" + pkg.version + \"\n\" + pkg.src.url + \"\n\" + pkg.src.outputHash
")"

deriv_file="$repo_root$(printf '%s' "$result" | sed -n 1p)"
old_version="$(printf '%s' "$result" | sed -n 2p)"
old_url="$(printf '%s' "$result" | sed -n 3p)"
old_hash="$(printf '%s' "$result" | sed -n 4p)"

page="$(curl -sSL --compressed "$downloads_url")"

# The downloads page names the version explicitly ("Download Cheat Engine
# 7.7.1 For Linux"), which handles multi-digit major/minor/patch correctly
# instead of reverse-parsing the dot-stripped URL suffix.
new_version="$(printf '%s' "$page" | grep -oE 'Download Cheat Engine [0-9.]+ For Linux' | grep -oE '[0-9.]+' | head -n1)"
if [[ -z "$new_version" ]]; then
  echo "$attr: failed to find the Linux version on $downloads_url" >&2
  exit 1
fi

# The download URL is the version with dots stripped (7.7.1 -> 771). Cross-check
# the full expected link against the page so a site-side naming change is caught.
url_suffix="${new_version//./}"
new_url="${base_url}CheatEngineLinux${url_suffix}.zip"
if ! printf '%s' "$page" | grep -qF "$new_url"; then
  echo "$attr: expected $new_url on $downloads_url but did not find it" >&2
  exit 1
fi

if [[ "$new_version" == "$old_version" ]]; then
  echo "$attr: already up to date ($old_version)"
  exit 0
fi

raw_new_hash="$(nix-prefetch-url --type sha256 "$new_url" 2>/dev/null)"
new_hash="$(nix --extra-experimental-features nix-command hash convert --hash-algo sha256 --to sri "$raw_new_hash")"

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
