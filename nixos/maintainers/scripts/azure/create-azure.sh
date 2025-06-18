#! /bin/sh -eu

export NIX_PATH=nixpkgs=$(dirname $(readlink -f $0))/../../../..
export NIXOS_CONFIG=$(dirname $(readlink -f $0))/../../../modules/virtualisation/azure-image.nix
export TIMESTAMP=$(date +%Y%m%d%H%M)

nix-build '<nixpkgs/nixos>' \
   -A config.system.build.azureImage --argstr system x86_64-linux -o azure -j 10
