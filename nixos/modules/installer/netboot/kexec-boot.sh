#!/usr/bin/env bash
set -e

kexecTree=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
kernelParams=$(<"$kexecTree/kernel-params")

usage() {
    printf >&2 'usage: %s [%s]\n' "$0" \
        '--append <cmdline>'
    exit 2
}

while (( $# )); do
    arg=$1; shift 1
    case "$arg" in
        --append)
            (( $# )) || usage
            kernelParams="$kernelParams $1"; shift 1
            ;;
        *)
            usage
            ;;
    esac
done

if ! kexec --version &>/dev/null; then
    printf >&2 'kexec not found: please install kexec-tools\n'
    exit 1
fi

if (( EUID != 0 )); then
    printf >&2 'kexec-boot must be run as root\n'
    exit 1
fi

kexec --load \
    --kexec-syscall-auto \
    --initrd="$kexecTree/initrd" \
    --append="$kernelParams" \
    -- "$kexecTree/kernel"

if [[ -d /run/systemd/system ]] && command -v systemctl >/dev/null; then
    systemctl kexec
else
    kexec -e
fi
