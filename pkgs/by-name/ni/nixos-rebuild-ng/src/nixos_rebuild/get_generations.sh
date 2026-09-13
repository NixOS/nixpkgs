#!/bin/sh

# Return generations from target Nix profile in a JSON-lines(ish) format.
# Example:
# $ ./get_generations.sh /nix/var/nix/profiles/system
# {"id":642,"timestamp":"2026-09-06 11:57:05","current":false}
# {"id":643,"timestamp":"2026-09-06 13:01:11","current":false}
# {"id":644,"timestamp":"2026-09-06 18:59:37","current":false}
# {"id":645,"timestamp":"2026-09-07 18:17:07","current":true}

profile="$1"

if [ ! -L "$profile" ]; then
  printf "no profile '%s' found" "$profile" >&2
  exit 1
fi

dir="${profile%/*}"
name="${profile##*/}"

current="$(readlink "$profile")"
current="${current##*/}"

for path in "$dir"/"$name"-*-link; do
  [ -L "$path" ] || continue

  basename="${path##*/}"
  id="${basename#"$name"-}"
  id="${id%-link}"

  # Use birth time if available, otherwise fallback to
  # creation time
  # https://github.com/NixOS/nixpkgs/issues/435555
  # shellcheck disable=SC2046
  set -- $(stat -L -c '%W %Z' "$path")
  btime="$1"
  ctime="$2"

  if [ "$btime" -ne 0 ]; then
    creation_time="$btime"
  else
    creation_time="$ctime"
  fi

  timestamp="$(date -d "@$creation_time" '+%Y-%m-%d %H:%M:%S')"

  if [ "$basename" = "$current" ]; then
    is_current=true
  else
    is_current=false
  fi

  printf '{"id":%d,"timestamp":"%s","current":%s}\n' \
    "$id" \
    "$timestamp" \
    "$is_current"
done
