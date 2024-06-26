#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bundix zlib libyaml

set -o errexit -o nounset

BASEDIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

for directory in "basic" "full"; do
  pushd "$BASEDIR/$directory"
  rm -f Gemfile.lock gemset.nix
  BUNDLE_FORCE_RUBY_PLATFORM=true bundix --magic
  rm -rf .bundle vendor
  popd
done
