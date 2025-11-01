#! @bash@/bin/sh -e

shopt -s nullglob

export PATH=/empty:@path@

default=$1
if test -z "$1"; then
    echo "Syntax: generations-dir-builder.sh <DEFAULT-CONFIG>"
    exit 1
fi

echo "updating the boot generations directory..."

mkdir -p /boot

rm -Rf /boot/system* || true

target=/boot/grub/menu.lst
tmp=$target.tmp

# Convert a path to a file in the Nix store such as
# /nix/store/<hash>-<name>/file to <hash>-<name>-<file>.
cleanName() {
    local path="$1"
    echo "$path" | sed 's|^/nix/store/||' | sed 's|/|-|g'
}

# Copy a file from the Nix store to /boot/kernels.
declare -A filesCopied

copyToKernelsDir() {
    local src="$1"
    local dst="/boot/kernels/$(cleanName $src)"
    # Don't copy the file if $dst already exists.  This means that we
    # have to create $dst atomically to prevent partially copied
    # kernels or initrd if this script is ever interrupted.
    if ! test -e $dst; then
        local dstTmp=$dst.tmp.$$
        cp $src $dstTmp
        mv $dstTmp $dst
    fi
    filesCopied[$dst]=1
    result=$dst
}


# Copy its kernel and initrd to /boot/kernels.
addEntry() {
    local path="$1"
    local generation="$2"
    local outdir=/boot/system-$generation
    local defaultdir=/boot/default

    if ! test -e $path/kernel -a -e $path/initrd; then
        return
    fi

    local kernel=$(readlink -f $path/kernel)
    local initrd=$(readlink -f $path/initrd)
    local extraLnArgs=""

    if test -n "@copyKernels@"; then
        copyToKernelsDir $kernel; kernel=$result
        copyToKernelsDir $initrd; initrd=$result
        extraLnArgs="-r"
    fi

    mkdir -p $outdir
    ln -sf $(readlink -f $path) $outdir/system
    ln -sf $(readlink -f $path/init) $outdir/init
    ln -sf $extraLnArgs $initrd $outdir/initrd
    ln -sf $extraLnArgs $kernel $outdir/kernel

    if test $(readlink -f "$path") = "$default"; then
      if test -n "@copyDefault@"; then
        cp "$kernel" /boot/nixos-kernel
        cp "$initrd" /boot/nixos-initrd
        cp "$(readlink -f "$path/init")" /boot/nixos-init
      fi

      # Clean up the /boot/default directory created by earlier
      # versions of generations-dir.
      if test -d $defaultdir -a ! -L $defaultdir; then
        rm -Rf $defaultdir
      fi

      ln -sfrT $outdir $defaultdir
    fi
}

if test -n "@copyKernels@"; then
    mkdir -p /boot/kernels
fi

# Add all generations of the system profile to the menu, in reverse
# (most recent to least recent) order.
for generation in $(
    (cd /nix/var/nix/profiles && ls -d system-*-link) \
    | sed 's/system-\([0-9]\+\)-link/\1/' \
    | sort -n -r); do
    link=/nix/var/nix/profiles/system-$generation-link
    addEntry $link $generation
done

# Remove obsolete files from /boot/kernels.
for fn in /boot/kernels/*; do
    if ! test "${filesCopied[$fn]}" = 1; then
        rm -vf -- "$fn"
    fi
done
