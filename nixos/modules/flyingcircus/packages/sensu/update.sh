#!/bin/sh
rm -f Gemfile.lock
rm -rf /tmp/bundix
nix-shell -p bundler -p openssl -p nix-prefetch-scripts --command "bundler package --no-install --path /tmp/bundix/bundle"
nix-shell -p bundix  -p nix-prefetch-scripts --command bundix
