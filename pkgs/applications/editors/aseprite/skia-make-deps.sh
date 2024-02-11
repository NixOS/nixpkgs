#!/usr/bin/env bash

FILTER=$1
OUT=skia-deps.nix
REVISION=861e4743af6d9bf6077ae6dda7274e5a136ee4e2
DEPS=$(curl -s https://raw.githubusercontent.com/aseprite/skia/$REVISION/DEPS)
THIRD_PARTY_DEPS=$(echo "$DEPS" | grep third_party | grep "#" -v | sed 's/"//g')

function write_fetch_defs ()
{
  while read -r DEP; do
    NAME=$(echo "$DEP" | cut -d: -f1 | cut -d/ -f3 | sed 's/ //g')
    URL=$(echo "$DEP" | cut -d: -f2- | cut -d@ -f1 | sed 's/ //g')
    REV=$(echo "$DEP" | cut -d: -f2- | cut -d@ -f2 | sed 's/[ ,]//g')

    echo "Fetching $NAME@$REV"
    PREFETCH=$(nix-prefetch-git --rev "$REV" "$URL")

(
cat <<EOF
  $NAME = fetchgit {
    url = "$URL";
    rev = "$REV";
    sha256 = $(echo $PREFETCH | jq '.sha256');
  };
EOF
) >> "$OUT"

  echo "----------"
  echo
  done <<< "$1"
}

echo "{ fetchgit }:" > "$OUT"
echo "{" >> "$OUT"
write_fetch_defs "$(echo "$THIRD_PARTY_DEPS" | grep -E "$FILTER")"
echo "}" >> "$OUT"
