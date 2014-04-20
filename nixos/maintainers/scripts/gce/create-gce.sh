#! /bin/sh -e

export NIX_PATH=nixpkgs=../../../..
export NIXOS_CONFIG=$(dirname $(readlink -f $0))/../../../modules/virtualisation/google-compute-image.nix
export TIMESTAMP=$(date +%Y%m%d%H%M)

nix-build '<nixpkgs/nixos>' \
   -A config.system.build.googleComputeImage --argstr system x86_64-linux -o gce --option extra-binary-caches http://hydra.nixos.org -j 10

img=$(echo gce/*.tar.gz)
if ! gsutil ls gs://nixos/$(basename $img); then
  gsutil cp $img gs://nixos/$(basename $img)
fi
gcutil addimage $(basename $img .raw.tar.gz | sed 's|\.|-|' | sed 's|_|-|') gs://nixos/$(basename $img)
