#!/usr/bin/env nix-shell
#!nix-shell -i bash
#!nix-shell -p nix-update

# update the main package
nix-update opengym

# update the frontend hash
nix-update --version skip opengym.frontend

