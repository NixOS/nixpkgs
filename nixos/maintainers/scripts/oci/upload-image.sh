#! /usr/bin/env bash

set -euo pipefail

script_dir="$(dirname $(readlink -f $0))"
nixpkgs_root="$script_dir/../../../.."
export NIX_PATH="nixpkgs=$nixpkgs_root"

cat - <<EOF
This script will locally build a NixOS image and upload it as a Custom Image
using oci-cli. Make sure that an API key for the tenancy administrator has been
added to '~/.oci'.
For more info about configuring oci-cli, please visit
https://docs.cloud.oracle.com/iaas/Content/API/Concepts/apisigningkey.htm#Required_Keys_and_OCIDs

EOF

qcow="oci-image/nixos.qcow2"
if [ ! -f "$qcow" ]; then
    echo "OCI image $qcow does not exist"
    echo "Building image with create-image.sh for 'x86_64-linux'"
    "$script_dir/create-image.sh" x86_64-linux
    [ -f "$qcow" ] || { echo "Build failed: image not present after build"; exit 1; }
else
    echo "Using prebuilt image $qcow"
fi

cli="$(
  nix-build '<nixpkgs>' \
    --no-out-link \
    -A oci-cli
)"

PATH="$cli/bin:$PATH"
bucket="_TEMP_NIXOS_IMAGES_$RANDOM"

echo "Creating a temporary bucket"
root_ocid="$(
  oci iam compartment list \
  --all \
  --compartment-id-in-subtree true \
  --access-level ACCESSIBLE \
  --include-root \
  --raw-output \
  --query "data[?contains(\"id\",'tenancy')].id | [0]"
)"
bucket_ocid=$(
  oci os bucket create \
    -c "$root_ocid" \
    --name "$bucket" \
    --raw-output \
    --query "data.id"
)
# Clean up bucket on script termination
trap 'echo Removing temporary bucket; oci os bucket delete --force --name "$bucket"' INT TERM EXIT

echo "Uploading image to temporary bucket"
oci os object put -bn "$bucket" --file "$qcow"

echo "Importing image as a Custom Image"
bucket_ns="$(oci os ns get --query "data" --raw-output)"
image_id="$(
  oci compute image import from-object \
    -c "$root_ocid" \
    --namespace "$bucket_ns" \
    --bucket-name "$bucket" \
    --name nixos.qcow2 \
    --operating-system NixOS \
    --source-image-type QCOW2 \
    --launch-mode PARAVIRTUALIZED \
    --display-name NixOS \
    --raw-output \
    --query "data.id"
)"

cat - <<EOF
Image created! Please mark all available shapes as compatible with this image by
visiting the following link and by selecting the 'Edit Details' button on:
https://cloud.oracle.com/compute/images/$image_id
EOF

# Workaround until https://github.com/oracle/oci-cli/issues/399 is addressed
echo "Sleeping for 15 minutes before cleaning up files in the temporary bucket"
sleep $((15 * 60))

echo "Deleting image from bucket"
par_id="$(
  oci os preauth-request list \
    --bucket-name "$bucket" \
    --raw-output \
    --query "data[0].id"
)"

if [[ -n $par_id ]]; then
  oci os preauth-request delete \
    --bucket-name "$bucket" \
    --par-id "$par_id"
fi

oci os object delete -bn "$bucket" --object-name nixos.qcow2 --force
