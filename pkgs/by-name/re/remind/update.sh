#!/usr/bin/env nix-shell
#!nix-shell -i bash -p coreutils gnused nix-update

updateUrl="https://dianne.skoll.ca/projects/remind/"
version=$(curl -sL "${updateUrl}" \
  | sed -nEe '/(BETA|\.sig)/q;/>remind/s/.*>remind-([^<]*).tar.gz<.*/\1/p')
nix-update --version="$version" remind
