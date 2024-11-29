#! /bin/sh -e

export STORAGE=${STORAGE:-nixos}
export THREADS=${THREADS:-8}

azure-vhd-utils-for-go  upload --localvhdpath azure/disk.vhd  --stgaccountname "$STORAGE"  --stgaccountkey "$KEY" \
   --containername images --blobname nixos-unstable-nixops-updated.vhd --parallelism "$THREADS" --overwrite















