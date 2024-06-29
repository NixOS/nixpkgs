#! @bash@/bin/sh

# This can end up being called disregarding the shebang.
set -e

shopt -s nullglob

export PATH=/empty
for i in @path@; do PATH=$PATH:$i/bin; done

usage() {
    echo "usage: $0 -c <path-to-default-configuration> [-d <boot-dir>]" >&2
    exit 1
}

default=                # Default configuration
target=/boot            # Target directory

while getopts "c:d:" opt; do
    case "$opt" in
        c) default="$OPTARG" ;;
        d) target="$OPTARG" ;;
        \?) usage ;;
    esac
done

echo "updating the boot generations directory..."

mkdir -p $target/old

# Convert a path to a file in the Nix store such as
# /nix/store/<hash>-<name>/file to <hash>-<name>-<file>.
cleanName() {
    local path="$1"
    echo "$path" | sed 's|^/nix/store/||' | sed 's|/|-|g'
}

# Copy a file from the Nix store to $target/kernels.
declare -A filesCopied

copyToKernelsDir() {
    local src="$1"
    local dst="$target/old/$(cleanName $src)"
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

copyForced() {
    local src="$1"
    local dst="$2"
    cp $src $dst.tmp
    mv $dst.tmp $dst
}

outdir=$target/old
mkdir -p $outdir || true

# Copy its kernel and initrd to $target/old.
addEntry() {
    local path="$1"
    local generation="$2"

    if ! test -e $path/kernel -a -e $path/initrd; then
        return
    fi

    local kernel=$(readlink -f $path/kernel)
    local initrd=$(readlink -f $path/initrd)
    local dtb_path=$(readlink -f $path/dtbs)

    if test -n "@copyKernels@"; then
        copyToKernelsDir $kernel; kernel=$result
        copyToKernelsDir $initrd; initrd=$result
    fi

    echo $(readlink -f $path) > $outdir/$generation-system
    echo $(readlink -f $path/init) > $outdir/$generation-init
    cp $path/kernel-params $outdir/$generation-cmdline.txt
    echo $initrd > $outdir/$generation-initrd
    echo $kernel > $outdir/$generation-kernel

    if test "$generation" = "default"; then
      copyForced $kernel $target/kernel.img
      copyForced $initrd $target/initrd
      for dtb in $dtb_path/{broadcom,}/bcm*.dtb; do
        dst="$target/$(basename $dtb)"
        copyForced $dtb "$dst"
        filesCopied[$dst]=1
      done
      cp "$(readlink -f "$path/init")" $target/nixos-init
      echo "`cat $path/kernel-params` init=$path/init" >$target/cmdline.txt
    fi
}

addEntry $default default

# Add all generations of the system profile to the menu, in reverse
# (most recent to least recent) order.
for generation in $(
    (cd /nix/var/nix/profiles && ls -d system-*-link) \
    | sed 's/system-\([0-9]\+\)-link/\1/' \
    | sort -n -r); do
    link=/nix/var/nix/profiles/system-$generation-link
    addEntry $link $generation
done

# Add the firmware files
fwdir=@firmware@/share/raspberrypi/boot/
copyForced $fwdir/bootcode.bin  $target/bootcode.bin
copyForced $fwdir/fixup.dat     $target/fixup.dat
copyForced $fwdir/fixup4.dat    $target/fixup4.dat
copyForced $fwdir/fixup4cd.dat  $target/fixup4cd.dat
copyForced $fwdir/fixup4db.dat  $target/fixup4db.dat
copyForced $fwdir/fixup4x.dat   $target/fixup4x.dat
copyForced $fwdir/fixup_cd.dat  $target/fixup_cd.dat
copyForced $fwdir/fixup_db.dat  $target/fixup_db.dat
copyForced $fwdir/fixup_x.dat   $target/fixup_x.dat
copyForced $fwdir/start.elf     $target/start.elf
copyForced $fwdir/start4.elf    $target/start4.elf
copyForced $fwdir/start4cd.elf  $target/start4cd.elf
copyForced $fwdir/start4db.elf  $target/start4db.elf
copyForced $fwdir/start4x.elf   $target/start4x.elf
copyForced $fwdir/start_cd.elf  $target/start_cd.elf
copyForced $fwdir/start_db.elf  $target/start_db.elf
copyForced $fwdir/start_x.elf   $target/start_x.elf

# Add the config.txt
copyForced @configTxt@ $target/config.txt

# Remove obsolete files from $target and $target/old.
for fn in $target/old/*linux* $target/old/*initrd-initrd* $target/bcm*.dtb; do
    if ! test "${filesCopied[$fn]}" = 1; then
        rm -vf -- "$fn"
    fi
done
