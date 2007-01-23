#! @shell@

# Syntax: installer.sh <DEVICE> <NIX-EXPR>
# (e.g., installer.sh /mnt/root ./my-machine.nix)

# - mount target device
# - make Nix store etc.
# - copy closure of rescue env to target device
# - register validity
# - start the "target" installer in a chroot to the target device
#   * do a nix-pull
#   * nix-env -p system-profile -i <nix-expr for the configuration>
#   * run hook scripts provided by packages in the configuration?
# - install/update grub

set -e

mountPoint="$1"
nixosDir="$2"
configuration="$3"

if test -z "$mountPoint" -o -z "$nixosDir" -o -z "$configuration"; then
    echo "Syntax: nixos-installer.sh <targetRootDir> <nixosDir> <configuration>"
    exit 1
fi

if ! test -e "$mountPoint"; then
    echo "mount point $mountPoint doesn't exist"
    exit 1
fi
    
if ! test -e "$nixosDir"; then
    echo "NixOS source directory $nixosDir doesn't exist"
    exit 1
fi
    
if ! test -e "$configuration"; then
    echo "configuration file $configuration doesn't exist"
    exit 1
fi
    

nixosDir=$(readlink -f "$nixosDir")
configuration=$(readlink -f "$configuration")


# Mount some stuff in the target root directory.
mkdir -m 0755 -p $mountPoint/dev $mountPoint/proc $mountPoint/sys $mountPoint/mnt
mount --rbind / $mountPoint/mnt
mount --bind /dev $mountPoint/dev
mount --bind /proc $mountPoint/proc
mount --bind /sys $mountPoint/sys

cleanup() {
    # !!! don't umount any we didn't mount ourselves
    for i in $(grep -F "$mountPoint" /proc/mounts \
        | @perl@/bin/perl -e 'while (<>) { /^\S+\s+(\S+)\s+/; print "$1\n"; }' \
        | sort -r);
    do
        umount $i
    done
}

trap "cleanup" EXIT

mkdir -m 01777 -p $mountPoint/tmp
mkdir -m 0755 -p $mountPoint/var


# Create the necessary Nix directories on the target device, if they
# don't already exist.
mkdir -m 0755 -p \
    $mountPoint/nix/var/nix/gcroots \
    $mountPoint/nix/var/nix/temproots \
    $mountPoint/nix/var/nix/manifests \
    $mountPoint/nix/var/nix/userpool \
    $mountPoint/nix/var/nix/profiles \
    $mountPoint/nix/var/nix/db \
    $mountPoint/nix/var/log/nix/drvs

mkdir -m 1777 -p \
    $mountPoint/nix/store \


# Get the store paths to copy from the references graph.
storePaths=$(@perl@/bin/perl @pathsFromGraph@ @nixClosure@)

# Copy Nix to the Nix store on the target device.
echo "copying Nix to $mountPoint...."
for i in $storePaths; do
    echo "  $i"
    rsync -a $i $mountPoint/nix/store/
done


# Register the paths in the Nix closure as valid.  This is necessary
# to prevent them from being deleted the first time we install
# something.  (I.e., Nix will see that, e.g., the glibc path is not
# valid, delete it to get it out of the way, but as a result nothing
# will work anymore.)
chroot $mountPoint @nix@/bin/nix-store --register-validity < @nixClosure@


# Create the required /bin/sh symlink; otherwise lots of things
# (notably the system() function) won't work.
mkdir -m 0755 -p $mountPoint/bin
# !!! assuming that @shell@ is in the closure
ln -sf @shell@ $mountPoint/bin/sh


# Enable networking in the chroot.
mkdir -m 0755 -p $mountPoint/etc
cp /etc/resolv.conf $mountPoint/etc/


# Pull the manifest on the CD so that everything in the Nix store on
# the CD can be copied directly.
echo "registering substitutes to speed up builds..."
chroot $mountPoint @nix@/bin/nix-store --clear-substitutes
chroot $mountPoint @nix@/bin/nix-pull file:///mnt/MANIFEST
rm -f $mountPoint/tmp/inst-store
ln -s /mnt/nix/store $mountPoint/tmp/inst-store


# Do a nix-pull to speed up building.
if test -n "@nixpkgsURL@"; then
    chroot $mountPoint @nix@/bin/nix-pull @nixpkgsURL@/MANIFEST || true
fi


# Build the specified Nix expression in the target store and install
# it into the system configuration profile.
echo "building the system configuration..."
chroot $mountPoint @nix@/bin/nix-env \
    -p /nix/var/nix/profiles/system \
    -f "/mnt$nixosDir/system/system.nix" \
    --arg configuration "import /mnt$configuration" \
    --set -A system


# Copy the configuration to /etc/nixos.
targetConfig=$mountPoint/etc/nixos/configuration.nix
mkdir -p $(dirname $targetConfig)
if test -e $targetConfig -o -L $targetConfig; then
    cp -f $targetConfig $targetConfig.backup-$(date "+%Y%m%d%H%M%S")
fi
if test "$configuration" != "$targetConfig"; then
    cp -f $configuration $targetConfig
fi


# Grub needs a mtab.
rootDevice=$(df $mountPoint | grep '^/' | sed 's^ .*^^')
echo "$rootDevice / somefs rw 0 0" > $mountPoint/etc/mtab


# Mark the target as a NixOS installation, otherwise
# switch-to-configuration will chicken out.
touch $mountPoint/etc/NIXOS


# Switch to the new system configuration.  This will install Grub with
# a menu default pointing at the kernel/initrd/etc of the new
# configuration.
echo "finalising the installation..."
NIXOS_INSTALL_GRUB=1 chroot $mountPoint \
    /nix/var/nix/profiles/system/bin/switch-to-configuration boot
