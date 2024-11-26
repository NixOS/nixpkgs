#! /usr/bin/env nix-shell
#! nix-shell -i bash -p curl jq bundler bundix ruby

set -eu -o pipefail

cd "$(dirname "$0")"

# Update Gemfile with the latest iruby version
echo "source 'https://rubygems.org'" > Gemfile
echo -n "gem 'iruby', " >> Gemfile
curl https://rubygems.org/api/v1/gems/iruby.json | jq .version >> Gemfile

# Regenerate Gemfile.lock
export BUNDLE_FORCE_RUBY_PLATFORM=1
bundle lock

# Regenerate gemset.nix
bundix -l
