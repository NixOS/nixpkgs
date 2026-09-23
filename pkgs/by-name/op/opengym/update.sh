#!/usr/bin/env nix-shell
#!nix-shell -i bash
#!nix-shell -p nix-update

nix-update opengym
nix-update --version=skip opengym.frontend
nix-update --version=branch opengym.media

