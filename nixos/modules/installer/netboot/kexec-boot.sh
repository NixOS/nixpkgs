#!/usr/bin/env bash
set -e

if ! kexec --version &>/dev/null; then
    printf >&2 'kexec not found: please install kexec-tools\n'
    exit 1
fi

if (( EUID != 0 )); then
    printf >&2 'kexec-boot must be run as root\n'
    exit 1
fi

kexecTree=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

kexec --load \
    --kexec-syscall-auto \
    --initrd="$kexecTree/initrd" \
    --command-line="$(<"$kexecTree/kernel-params")" \
    -- "$kexecTree/kernel"

if [[ -d /run/systemd/system ]] && command -v systemctl >/dev/null; then
    systemctl kexec
else
    kexec -e
fi
