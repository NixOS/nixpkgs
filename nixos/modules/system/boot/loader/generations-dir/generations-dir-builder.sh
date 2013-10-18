#! @bash@/bin/sh -e

shopt -s nullglob

export PATH=/empty
for i in @path@; do PATH=$PATH:$i/bin; done

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

    if ! test -e $path/kernel -a -e $path/initrd; then
        return
    fi

    local kernel=$(readlink -f $path/kernel)
    local initrd=$(readlink -f $path/initrd)

    if test -n "@copyKernels@"; then
        copyToKernelsDir $kernel; kernel=$result
        copyToKernelsDir $initrd; initrd=$result
    fi
    
    mkdir -p $outdir
    ln -sf $(readlink -f $path) $outdir/system
    ln -sf $(readlink -f $path/init) $outdir/init
    ln -sf $initrd $outdir/initrd
    ln -sf $kernel $outdir/kernel

    if test $(readlink -f "$path") = "$default"; then
      cp "$kernel" /boot/nixos-kernel
      cp "$initrd" /boot/nixos-initrd
      cp "$(readlink -f "$path/init")" /boot/nixos-init

      mkdir -p /boot/default
      # ln -sfT: overrides target even if it exists.
      ln -sfT $(readlink -f $path) /boot/default/system
      ln -sfT $(readlink -f $path/init) /boot/default/init
      ln -sfT $initrd /boot/default/initrd
      ln -sfT $kernel /boot/default/kernel
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
