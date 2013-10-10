#! @bash@/bin/sh -e

shopt -s nullglob

export PATH=/empty
for i in @path@; do PATH=$PATH:$i/bin:$i/sbin; done

default=$1
if test -z "$1"; then
    echo "Syntax: efi-boot-stub-builder.sh <DEFAULT-CONFIG>"
    exit 1
fi

echo "updating the efi system partition..."

# Convert a path to a file in the Nix store such as
# /nix/store/<hash>-<name>/file to <hash>-<name>-<file>.
# Also, efi executables need the .efi extension
cleanName() {
    local path="$1"
    echo "$path" | sed 's|^/nix/store/||' | sed 's|/|-|g' | sed 's|@kernelFile@$|@kernelFile@.efi|'
}

# Copy a file from the Nix store to the EFI system partition
declare -A filesCopied

copyToKernelsDir() {
    local src="$1"
    local dst="@efiSysMountPoint@/efi/nixos/$(cleanName $src)"
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

# Copy its kernel, initrd, and startup script to the efi system partition
# Add the efibootmgr entry if requested
addEntry() {
    local path="$1"
    local generation="$2"

    if ! test -e $path/kernel -a -e $path/initrd; then
        return
    fi

    local kernel=$(readlink -f $path/kernel)
    local initrd=$(readlink -f $path/initrd)
    copyToKernelsDir $kernel; kernel=$result
    copyToKernelsDir $initrd; initrd=$result

    local startup="@efiSysMountPoint@/efi/nixos/generation-$generation-startup.nsh"
    if ! test -e $startup; then
        local dstTmp=$startup.tmp.$$
	echo "$(echo $kernel | sed 's|@efiSysMountPoint@||' | sed 's|/|\\|g') systemConfig=$(readlink -f $path) init=$(readlink -f $path/init) initrd=$(echo $initrd | sed 's|@efiSysMountPoint@||' | sed 's|/|\\|g') $(cat $path/kernel-params)" > $dstTmp
        mv $dstTmp $startup
    fi
    filesCopied[$startup]=1

    if test -n "@runEfibootmgr@"; then
      set +e
      efibootmgr -c -d "@efiDisk@" -g -l $(echo $kernel | sed 's|@efiSysMountPoint@||' | sed 's|/|\\|g') -L "NixOS $generation Generation" -p "@efiPartition@" \
        -u systemConfig=$(readlink -f $path) init=$(readlink -f $path/init) initrd=$(echo $initrd | sed 's|@efiSysMountPoint@||' | sed 's|/|\\|g') $(cat $path/kernel-params) > /dev/null 2>&1
      set -e
    fi

    if test $(readlink -f "$path") = "$default"; then
      if test -n "@runEfibootmgr@"; then
        set +e
        defaultbootnum=$(efibootmgr | grep "NixOS $generation Generation" | sed 's/Boot//' | sed 's/\*.*//')
	set -e
      fi

      if test -n "@installStartupNsh@"; then
        sed 's|.*@kernelFile@.efi|@kernelFile@.efi|' < $startup > "@efiSysMountPoint@/startup.nsh"
        cp $kernel "@efiSysMountPoint@/@kernelFile@.efi"
      fi
    fi
}

mkdir -p "@efiSysMountPoint@/efi/nixos/"

# Remove all old boot manager entries
if test -n "@runEfibootmgr@"; then
  set +e
  modprobe efivars > /dev/null 2>&1
  for bootnum in $(efibootmgr | grep "NixOS" | grep "Generation" | sed 's/Boot//' | sed 's/\*.*//'); do
    efibootmgr -B -b "$bootnum" > /dev/null 2>&1
  done
  set -e
fi

# Add all generations of the system profile to the system partition, in reverse
# (most recent to least recent) order.
for generation in $(
    (cd /nix/var/nix/profiles && ls -d system-*-link) \
    | sed 's/system-\([0-9]\+\)-link/\1/' \
    | sort -n -r); do
    link=/nix/var/nix/profiles/system-$generation-link
    addEntry $link $generation
done

if test -n "@runEfibootmgr@"; then
  set +e
  efibootmgr -o $defaultbootnum > /dev/null 2>&1
  set -e
fi

if test -n "@efiShell@"; then
  mkdir -pv "@efiSysMountPoint@"/efi/boot
  cp "@efiShell@" "@efiSysMountPoint@"/efi/boot/boot"@targetArch@".efi
fi

# Remove obsolete files from the EFI system partition
for fn in "@efiSysMountPoint@/efi/nixos/"*; do
    if ! test "${filesCopied[$fn]}" = 1; then
        rm -vf -- "$fn"
    fi
done

# Run any extra commands users may need
if test -n "@runEfibootmgr@"; then
  set +e
  @postEfiBootMgrCommands@
  set -e
fi
