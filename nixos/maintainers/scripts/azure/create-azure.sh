#! /bin/sh -e

BUCKET_NAME=${BUCKET_NAME:-nixos}
export NIX_PATH=nixpkgs=../../../..
export NIXOS_CONFIG=$(dirname $(readlink -f $0))/../../../modules/virtualisation/azure-image.nix
export TIMESTAMP=$(date +%Y%m%d%H%M)

nix-build '<nixpkgs/nixos>' \
   -A config.system.build.azureImage --argstr system x86_64-linux -o azure --option extra-binary-caches http://hydra.nixos.org -j 10

azure vm image create nixos-test --location "West Europe" --md5-skip -v --os Linux azure/disk.vhd
