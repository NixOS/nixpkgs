#!/bin/sh
rm -f Gemfile.lock
rm -rf /tmp/bundix
nix-shell -p bundler -p openssl --command "bundler package --path /tmp/bundix/bundle"
nix-shell -p bundix --command bundix
