#!/bin/sh
rm -f Gemfile.lock
nix-shell -p bundler -p openssl --command "bundler package --path /tmp/vendor/bundle"
nix-shell -p bundix --command bundix
