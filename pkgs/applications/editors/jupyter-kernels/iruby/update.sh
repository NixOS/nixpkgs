#!/usr/bin/env sh

# First, manually update Gemfile

# Regenerate Gemfile.lock
nix shell .#bundler -c bundle lock

# Regenerate gemset.nix
nix shell .#bundix -c bundix -l
