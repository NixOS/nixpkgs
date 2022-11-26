#!/usr/bin/env bash
if ! kexec -v >/dev/null 2>&1; then
  echo "kexec not found: please install kexec-tools" 2>&1
  exit 1
fi
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
kexec --load ${SCRIPT_DIR}/bzImage \
  --initrd=${SCRIPT_DIR}/initrd.gz \
  --command-line="$(< "${SCRIPT_DIR}/kernel-params")"
kexec -e
