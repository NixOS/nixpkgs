#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bundix zlib
# shellcheck shell=bash

set -o errexit
set -o nounset

readonly BASEDIR="$(dirname $(readlink -f $0))"

for directory in "basic" "full"; do
  pushd "$BASEDIR/$directory"
  rm -f Gemfile.lock gemset.nix
  bundix --magic
  rm -rf .bundle vendor
  popd
done
