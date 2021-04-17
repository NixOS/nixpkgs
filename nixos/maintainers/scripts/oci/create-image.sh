#! /usr/bin/env bash

export NIX_PATH=nixpkgs=$(dirname $(readlink -f $0))/../../../..
export NIXOS_CONFIG=$(dirname $(readlink -f $0))/../../../modules/virtualisation/oci-image.nix

nix-build '<nixpkgs/nixos>' \
   -A config.system.build.OCIImage \
   --argstr system x86_64-linux \
   --option system-features kvm \
   -o oci-image
