#!/usr/bin/env bash
set -e

kexecTree=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
initrd=$kexecTree/initrd
kernelParams=$(<"$kexecTree/kernel-params")

usage() {
    printf >&2 'usage: %s [%s] [%s]\n' "$0" \
        '--ssh-authorized-keys <file>' \
        '--append <cmdline>'
    exit 2
}

while (( $# )); do
    arg=$1; shift 1
    case "$arg" in
        --ssh-authorized-keys)
            (( $# )) || usage
            authorizedKeysFile=$1; shift 1
            ;;
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

cleanup() {
    if [[ -v workDir ]]; then
        rm -rf "$workDir"
    fi
}

trap cleanup EXIT

if [[ -v authorizedKeysFile ]]; then
    workDir=$(mktemp -d --tmpdir nixos-kexec-initrd.XXXXXXXXXX)
    keysDir=$workDir/overlay/etc/ssh/authorized_keys.d
    mkdir -p -- "$keysDir"
    install --mode=0644 -- "$authorizedKeysFile" "$keysDir/nixos"
    {
        (
            cd -- "$workDir"
            find overlay -print0 | cpio -o -H newc --null --quiet
        )
        cat -- "$initrd"
    } >"$workDir/initrd"
    initrd="$workDir/initrd"
fi

kexec --load \
    --kexec-syscall-auto \
    --initrd="$initrd" \
    --append="$kernelParams" \
    -- "$kexecTree/kernel"

cleanup

if [[ -d /run/systemd/system ]] && command -v systemctl >/dev/null; then
    systemctl kexec
else
    kexec -e
fi
