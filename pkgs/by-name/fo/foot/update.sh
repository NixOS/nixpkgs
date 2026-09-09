#!/usr/bin/env nix-shell
#!nix-shell -i bash
#!nix-shell -p nix-update

nix-update foot
nix-update --version=skip foot.stimulusGenerator
