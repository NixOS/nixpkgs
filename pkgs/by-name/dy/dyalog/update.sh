#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnugrep coreutils common-updater-scripts

set -euo pipefail

# The download zone lists every supported release, newest major included.
version=$(
  curl -fsSL 'https://www.dyalog.com/download-zone.htm?p=download' |
    grep -oE 'linux_64_[0-9]+\.[0-9]+\.[0-9]+_unicode\.x86_64\.deb' |
    grep -oE '[0-9]+\.[0-9]+\.[0-9]+' |
    sort -uV |
    tail -n1
)

update-source-version dyalog "$version" --source-key=sources.x86_64-linux
update-source-version dyalog "$version" --source-key=sources.aarch64-linux --ignore-same-version
