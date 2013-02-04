#! @shell@

# - [mount target device] <- currently disabled
# - make Nix store etc.
# - copy closure of Nix to target device
# - register validity
# - with a chroot to the target device:
#   * nix-env -p /nix/var/nix/profiles/system -i <nix-expr for the configuration>
#   * run the activation script of the configuration (also installs Grub)

set -e
shopt -s nullglob

if test -z "$mountPoint"; then
    mountPoint=/mnt
fi

if test -z "$NIXOS_CONFIG"; then
    NIXOS_CONFIG=/etc/nixos/configuration.nix
fi

if ! test -e "$mountPoint"; then
    echo "mount point $mountPoint doesn't exist"
    exit 1
fi

if ! grep -F -q " $mountPoint " /proc/mounts; then
    echo "$mountPoint doesn't appear to be a mount point"
    exit 1
fi

if ! test -e "$mountPoint/$NIXOS_CONFIG"; then
    echo "configuration file $NIXOS_CONFIG doesn't exist"
    exit 1
fi



# Mount some stuff in the target root directory.  We bind-mount /etc
# into the chroot because we need networking and the nixbld user
# accounts in /etc/passwd.  But we do need the target's /etc/nixos.
mkdir -m 0755 -p $mountPoint/dev $mountPoint/proc $mountPoint/sys $mountPoint/mnt $mountPoint/mnt2 $mountPoint/etc /etc/nixos
mount --make-private / # systemd makes / shared, which is annoying
mount --bind / $mountPoint/mnt
mount --bind /nix $mountPoint/mnt/nix
mount --bind /nix/store $mountPoint/mnt/nix/store
mount --bind /dev $mountPoint/dev
mount --bind /dev/shm $mountPoint/dev/shm
mount --bind /proc $mountPoint/proc
mount --bind /sys $mountPoint/sys
mount --bind $mountPoint/etc/nixos $mountPoint/mnt2
mount --bind /etc $mountPoint/etc
mount --bind $mountPoint/mnt2 $mountPoint/etc/nixos

cleanup() {
    set +e
    mountpoint -q $mountPoint/etc/nixos && umount $mountPoint/etc/nixos
    mountpoint -q $mountPoint/etc && umount $mountPoint/etc
    umount $mountPoint/mnt2
    umount $mountPoint/sys
    umount $mountPoint/proc
    umount $mountPoint/dev/shm
    umount $mountPoint/dev
    umount $mountPoint/mnt/nix/store
    umount $mountPoint/mnt/nix
    umount $mountPoint/mnt
    rmdir $mountPoint/mnt $mountPoint/mnt2
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

mkdir -m 1775 -p $mountPoint/nix/store
build_users_group=$(@perl@/bin/perl -e 'use Nix::Config; Nix::Config::readConfig; print $Nix::Config::config{"build-users-group"};')
if test -n "$build_users_group"; then
    chown root:"$build_users_group" $mountPoint/nix/store
else
    chown root $mountPoint/nix/store
fi


# Get the store paths to copy from the references graph.
storePaths=$(@perl@/bin/perl @pathsFromGraph@ @nixClosure@)


# Copy Nix to the Nix store on the target device.
echo "copying Nix to $mountPoint...."
for i in $storePaths; do
    echo "  $i"
    chattr -R -i $mountPoint/$i 2> /dev/null || true # clear immutable bit
    rsync -a $i $mountPoint/nix/store/
done


# We don't have locale-archive in the chroot, so clear $LANG.
export LANG=
export LC_ALL=
export LC_TIME=


# Create a temporary Nix config file that causes the nixbld users to
# be used.
if test -n "$build_users_group"; then
    echo "build-users-group = $build_users_group" > $mountPoint/tmp/nix.conf
fi
binary_caches=$(@perl@/bin/perl -e 'use Nix::Config; Nix::Config::readConfig; print $Nix::Config::config{"binary-caches"};')
if test -n "$binary_caches"; then
    echo "binary-caches $binary_caches" >> $mountPoint/tmp/nix.conf
fi
export NIX_CONF_DIR=/tmp


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


if test -n "$NIXOS_PREPARE_CHROOT_ONLY"; then
    echo "User requested only to prepare chroot. Exiting."
    exit 0
fi


# Make the build below copy paths from the CD if possible.  Note that
# /mnt in the chroot is the root of the CD.
export NIX_OTHER_STORES=/mnt/nix:$NIX_OTHER_STORES


# Make manifests available in the chroot.
rm -f $mountPoint/nix/var/nix/manifests/*
for i in /nix/var/nix/manifests/*.nixmanifest; do
    chroot $mountPoint @nix@/bin/nix-store -r "$(readlink -f "$i")" > /dev/null
    cp -pd "$i" $mountPoint/nix/var/nix/manifests/
done


# Get the absolute path to the NixOS/Nixpkgs sources.
nixpkgs_src=$(nix-instantiate --find-file nixpkgs)
nixos_src=$(nix-instantiate --find-file nixos)


# Build the specified Nix expression in the target store and install
# it into the system configuration profile.
echo "building the system configuration..."
NIX_PATH="nixpkgs=/mnt$nixpkgs_src:nixos=/mnt$nixos_src:nixos-config=$NIXOS_CONFIG" NIXOS_CONFIG= \
    chroot $mountPoint @nix@/bin/nix-env \
    -p /nix/var/nix/profiles/system -f '<nixos>' --set -A system --show-trace


# Copy the NixOS/Nixpkgs sources to the target as the initial contents
# of the NixOS channel.
mkdir -m 0755 -p $mountPoint/nix/var/nix/profiles
mkdir -m 1777 -p $mountPoint/nix/var/nix/profiles/per-user
mkdir -m 0755 -p $mountPoint/nix/var/nix/profiles/per-user/root
srcs=$(nix-env -p /nix/var/nix/profiles/per-user/root/channels -q nixos --no-name --out-path 2>/dev/null || echo -n "")
if test -n "$srcs"; then
    echo "copying NixOS/Nixpkgs sources..."
    chroot $mountPoint @nix@/bin/nix-env \
        -p /nix/var/nix/profiles/per-user/root/channels -i "$srcs" --quiet
fi
mkdir -m 0700 -p $mountPoint/root/.nix-defexpr
ln -sfn /nix/var/nix/profiles/per-user/root/channels $mountPoint/root/.nix-defexpr/channels


# We're done building/downloading, so we don't need the /etc bind
# mount anymore.  In fact, below we want to modify the target's /etc.
umount $mountPoint/etc/nixos
umount $mountPoint/etc


# Grub needs an mtab.
ln -sfn /proc/mounts $mountPoint/etc/mtab


# Mark the target as a NixOS installation, otherwise
# switch-to-configuration will chicken out.
touch $mountPoint/etc/NIXOS


# Switch to the new system configuration.  This will install Grub with
# a menu default pointing at the kernel/initrd/etc of the new
# configuration.
echo "finalising the installation..."
NIXOS_INSTALL_GRUB=1 chroot $mountPoint \
    /nix/var/nix/profiles/system/bin/switch-to-configuration boot
