#!/usr/bin/env bash
set -e

if ! kexec -v &>/dev/null; then
    echo 'kexec not found: please install kexec-tools' 2>&1
    exit 1
fi

kexecTree=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

kexec --load \
    --initrd="$kexecTree/initrd" \
    --command-line="$(<"$kexecTree/kernel-params")" \
    -- "$kexecTree/kernel"

kexec -e
