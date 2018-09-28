#!/bin/sh

new="$1"
old="$2"

if test -e "$old"; then
  # skip anything that systemd can force creation of
  grep '^.+ ' "$new" |
  cut -d' ' -f2 |
  grep -vFwf - "$old" |
  # skip anything that's the same in the new version
  grep -vFxf "$new" |
  # delete everything else
  cut -d' ' -f2 |
  while read p; do echo r "$p"; done |
  # ensure any nested path appears before any of its ancestors
  sort -ur
fi
