#!/usr/bin/env bash

set -eu -o pipefail

cd "$(dirname "$0")"

# Update Gemfile with the latest iruby version
echo "source 'https://rubygems.org'" > Gemfile
echo -n "gem 'iruby', " >> Gemfile
nix shell .#curl -c curl https://rubygems.org/api/v1/gems/iruby.json | nix shell .#jq -c jq .version >> Gemfile

# Regenerate Gemfile.lock
nix shell .#bundler -c bundle lock

# Regenerate gemset.nix
nix shell .#bundix -c bundix -l
