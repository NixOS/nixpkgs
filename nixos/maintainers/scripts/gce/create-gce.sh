#! /bin/sh -e

BUCKET_NAME=${BUCKET_NAME:-nixos}
export NIX_PATH=nixpkgs=../../../..
export NIXOS_CONFIG=$(dirname $(readlink -f $0))/../../../modules/virtualisation/google-compute-image.nix
export TIMESTAMP=$(date +%Y%m%d%H%M)

nix-build '<nixpkgs/nixos>' \
   -A config.system.build.googleComputeImage --argstr system x86_64-linux -o gce --option extra-binary-caches http://hydra.nixos.org -j 10

img=$(echo gce/*.tar.gz)
if ! gsutil ls gs://${BUCKET_NAME}/$(basename $img); then
  gsutil cp $img gs://${BUCKET_NAME}/$(basename $img)
fi
gcloud compute images create $(basename $img .raw.tar.gz | sed 's|\.|-|' | sed 's|_|-|') --source-uri gs://${BUCKET_NAME}/$(basename $img)
