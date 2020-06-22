#! @bash@/bin/bash

# This can end up being called disregarding the shebang.
set -e

shopt -s nullglob

export PATH=/empty
for i in @path@; do PATH=$PATH:$i/bin; done

usage() {
    echo "usage: $0 -c <path-to-default-configuration> [-d <boot-dir>] [-g <num-generations>]" >&2
    exit 1
}

default=                # Default configuration
target=/boot            # Target directory
numGenerations=0        # Number of other generations to include in the menu

while getopts "c:d:g:" opt; do
    case "$opt" in
        c) default="$OPTARG" ;;
        d) target="$OPTARG" ;;
        g) numGenerations="$OPTARG" ;;
        \?) usage ;;
    esac
done

echo "updating the boot generations directory..."

mkdir -p "$target/old"

# Convert a path to a file in the Nix store such as
# /nix/store/<hash>-<name>/file to <hash>-<name>-<file>.
cleanName() {
    local path="$1"
    echo "$path" | sed 's|^/nix/store/||' | sed 's|/|-|g'
}

atomicCopy() {
    local src="$1"
    local dst="$2"
    local dstTmp=$dst.tmp.$$
    cp "$src" "$dstTmp"
    mv "$dstTmp" "$dst"
}

# Copy a file from the Nix store to $target/nixos.
declare -A filesCopied

copyToOldDir() {
    local src dst
    src=$(readlink -f "$1")
    dst="$target/old/$(cleanName "$src")"
    # Don't copy the file if $dst already exists.  This means that we
    # have to create $dst atomically to prevent partially copied
    # kernels or initrd if this script is ever interrupted.
    if ! test -e "$dst"; then
        atomicCopy "$src" "$dst"
    fi
    filesCopied[$dst]=1
}

copyDtbDir() {
    local dtb_dir="$1"
    local dst_dir="$2"
    mkdir -p "$dst_dir"
    for dtb in "$dtb_dir"/{broadcom,}/bcm*.dtb; do
        local dst
        dst="$dst_dir/$(basename "$dtb")"
        local dstTmp=$dst.tmp.$$
        cp "$dtb" "$dstTmp"
        mv "$dstTmp" "$dst"
        filesCopied[$dst]=1
    done
    filesCopied[$dst_dir]=1
}

cpMarked() {
    local src="$1"
    local dst="$2"
    cp "$src" "$dst"
    filesCopied[$dst]=1
}

echoMarked() {
    local src="$1"
    local dst="$2"
    echo "$src" >"$dst"
    filesCopied[$dst]=1
}

# Copy its kernel, initrd and dtbs to $target/old
addEntry() {
    local path
    path=$(readlink -f "$1")
    local tag="$2" # Generation number or 'default'

    if ! test -e "$path/kernel" -a -e "$path/initrd"; then
        return
    fi

    local kernel initrd dtb_path init kernel_params
    kernel=$(readlink -f "$path/kernel")
    initrd=$(readlink -f "$path/initrd")
    dtb_path=$(readlink -f "$path/dtbs")
    init=$(readlink -f "$path/init")
    kernel_params=$(readlink -f "$path/kernel-params")

    if [ "$tag" = "default" ]; then
        atomicCopy "$kernel" "$target/kernel.img"
        atomicCopy "$initrd" "$target/initrd"
        copyDtbDir "$dtb_path" "$target"
        atomicCopy "$init" "$target/nixos-init"

        tmpFile="$target/cmdline.txt.$$"
        echo "$(cat "$kernel_params") init=$init" >"$tmpFile"
        mv -f "$tmpFile" "$target/cmdline.txt"
    else
        copyToOldDir "$kernel"
        copyToOldDir "$initrd"

        copyDtbDir "$dtb_path" "$target/old/$(cleanName "$dtb_path")"

        echoMarked "$path" "$target/old/$generation-system"
        echoMarked "$init" "$target/old/$generation-init"
        cpMarked "$kernel_params" "$target/old/$generation-cmdline.txt"
        echoMarked "$initrd" "$target/old/$generation-initrd"
        echoMarked "$kernel" "$target/old/$generation-kernel"
        echoMarked "$dtb_path" "$target/old/$generation-dtbs"
    fi
}

addEntry "$default" default

if [ "$numGenerations" -gt 0 ]; then
    # Add up to $numGenerations generations of the system profile to $target/old,
    # in reverse (most recent to least recent) order.
    for generation in $(
            (cd /nix/var/nix/profiles && ls -d system-*-link) \
            | sed 's/system-\([0-9]\+\)-link/\1/' \
            | sort -n -r \
            | head -n "$numGenerations"); do
        link=/nix/var/nix/profiles/system-$generation-link
        addEntry "$link" "$generation"
    done
fi

# Add the firmware files
fwdir=@firmware@/share/raspberrypi/boot/
atomicCopy $fwdir/bootcode.bin  "$target/bootcode.bin"
atomicCopy $fwdir/fixup.dat     "$target/fixup.dat"
atomicCopy $fwdir/fixup4.dat    "$target/fixup4.dat"
atomicCopy $fwdir/fixup4cd.dat  "$target/fixup4cd.dat"
atomicCopy $fwdir/fixup4db.dat  "$target/fixup4db.dat"
atomicCopy $fwdir/fixup4x.dat   "$target/fixup4x.dat"
atomicCopy $fwdir/fixup_cd.dat  "$target/fixup_cd.dat"
atomicCopy $fwdir/fixup_db.dat  "$target/fixup_db.dat"
atomicCopy $fwdir/fixup_x.dat   "$target/fixup_x.dat"
atomicCopy $fwdir/start.elf     "$target/start.elf"
atomicCopy $fwdir/start4.elf    "$target/start4.elf"
atomicCopy $fwdir/start4cd.elf  "$target/start4cd.elf"
atomicCopy $fwdir/start4db.elf  "$target/start4db.elf"
atomicCopy $fwdir/start4x.elf   "$target/start4x.elf"
atomicCopy $fwdir/start_cd.elf  "$target/start_cd.elf"
atomicCopy $fwdir/start_db.elf  "$target/start_db.elf"
atomicCopy $fwdir/start_x.elf   "$target/start_x.elf"

# Add the config.txt
atomicCopy @configTxt@ "$target/config.txt"

# Remove obsolete files from $target and $target/nixos.
for fn in "$target"/old/* "$target"/bcm*.dtb "$target"/cmdline.txt.*; do
    if ! test "${filesCopied[$fn]}" = 1; then
        echo "Removing no longer needed boot file: $fn"
        chmod +w -- "$fn"
        rm -rf -- "$fn"
    fi
done
