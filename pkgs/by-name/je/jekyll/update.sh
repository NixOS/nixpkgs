#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bundix zlib libyaml

set -o errexit -o nounset

SCRIPT_DIRECTORY=$(cd $(dirname ${BASH_SOURCE[0]}); cd -P $(dirname $(readlink ${BASH_SOURCE[0]} || echo .)); pwd)

for directory in "basic" "full"; do
  pushd "$SCRIPT_DIRECTORY/$directory"
  rm -f Gemfile.lock gemset.nix
  BUNDLE_FORCE_RUBY_PLATFORM=true bundix --magic
  rm -rf .bundle vendor
  popd
done
