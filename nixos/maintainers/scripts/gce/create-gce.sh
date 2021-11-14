#!/usr/bin/env nix-shell
#! nix-shell -i bash -p google-cloud-sdk
# shellcheck shell=bash

set -euo pipefail

BUCKET_NAME="${BUCKET_NAME:-nixos-cloud-images}"
TIMESTAMP="$(date +%Y%m%d%H%M)"
export TIMESTAMP

nix-build '<nixpkgs/nixos/lib/eval-config.nix>' \
   -A config.system.build.googleComputeImage \
   --arg modules "[ <nixpkgs/nixos/modules/virtualisation/google-compute-image.nix> ]" \
   --argstr system x86_64-linux \
   -o gce \
   -j 10

img_path=$(echo gce/*.tar.gz)
img_name=${IMAGE_NAME:-$(basename "$img_path")}
img_id=$(echo "$img_name" | sed 's|.raw.tar.gz$||;s|\.|-|g;s|_|-|g')
img_family=$(echo "$img_id" | cut -d - -f1-4)

if ! gsutil ls "gs://${BUCKET_NAME}/$img_name"; then
  gsutil cp "$img_path" "gs://${BUCKET_NAME}/$img_name"
  gsutil acl ch -u AllUsers:R "gs://${BUCKET_NAME}/$img_name"

  gcloud compute images create \
    "$img_id" \
    --source-uri "gs://${BUCKET_NAME}/$img_name" \
    --family="$img_family"

  gcloud compute images add-iam-policy-binding \
    "$img_id" \
    --member='allAuthenticatedUsers' \
    --role='roles/compute.imageUser'
fi
