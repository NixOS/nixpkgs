#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts
#shellcheck shell=bash

set -o errexit
set -o nounset
set -o pipefail

new_version="$(
  list-git-tags --url=https://github.com/neo4j/neo4j.git |
    grep -E '^[0-9]{4}\.[0-9]{2}\.[0-9]+$' |
    sort --version-sort |
    tail -n1
)"

update-source-version neo4j "${new_version}"
