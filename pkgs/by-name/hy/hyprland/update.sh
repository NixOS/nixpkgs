#!/usr/bin/env nix-shell
#! nix-shell -i bash -p common-updater-scripts fd jq

set -eou pipefail

latest_release="$(curl --silent 'https://api.github.com/repos/hyprwm/Hyprland/releases/latest')"
latest_tag="$(curl --silent 'https://api.github.com/repos/hyprwm/Hyprland/tags?per_page=1')"
commit_hash="$(jq -r '.[0].commit.sha' <<<"$latest_tag")"
latest_commit="$(curl --silent 'https://api.github.com/repos/hyprwm/Hyprland/commits/'"$commit_hash"'')"
commit_message="$(jq -r '.commit.message' <<<"$latest_commit")"

tag=$(jq -r '.tag_name' <<<"$latest_release")
# drop 'v' prefix
version="${tag#v}"

branch=$(jq -r '.target_commitish' <<<"$latest_release")

date=$(jq -r '.created_at' <<<"$latest_release")
# truncate time
date=${date%T*}

# update version; otherwise fail
update-source-version hyprland "$version" --ignore-same-hash

# find hyprland dir
files="$(fd --full-path /hyprland/ | head -1)"
dir="${files%/*}"

echo -e '{
  "branch": "'"$branch"'",
  "commit_hash": "'"$commit_hash"'",
  "commit_message": "'"$commit_message"'",
  "date": "'"$date"'",
  "tag": "'"$tag"'"
}' >"$dir/info.json"
