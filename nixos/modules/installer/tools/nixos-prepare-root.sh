#! @shell@

# This script's goal is to perform all "static" setup of a filesystem structure from pre-built store paths. Everything
# in here should run in a non-root context and inside a Nix builder. It's designed primarily to be called from image-
# building scripts and from nixos-install, but because it makes very few assumptions about the context in which it runs,
# it could be useful in other contexts as well.
#
# Current behavior:
#  - set up basic filesystem structure
#  - make Nix store etc.
#  - copy Nix, system, channel, and misceallaneous closures to target Nix store
#  - register validity of all paths in the target store
#  - set up channel and system profiles

# Ensure a consistent umask.
umask 0022

set -e

mountPoint="$1"
channel="$2"
system="$3"
shift 3
closures="$@"

PATH="@coreutils@/bin:@nix@/bin:@perl@/bin:@utillinux@/bin:@rsync@/bin"

if ! test -e "$mountPoint"; then
    echo "mount point $mountPoint doesn't exist"
    exit 1
fi

# Create a few of the standard directories in the target root directory.
mkdir -m 0755 -p $mountPoint/dev $mountPoint/proc $mountPoint/sys $mountPoint/etc $mountPoint/run $mountPoint/home
mkdir -m 01777 -p $mountPoint/tmp
mkdir -m 0755 -p $mountPoint/tmp/root
mkdir -m 0755 -p $mountPoint/var
mkdir -m 0700 -p $mountPoint/root

ln -sf /run $mountPoint/var/run

# Create the necessary Nix directories on the target device
mkdir -m 0755 -p \
    $mountPoint/nix/var/nix/gcroots \
    $mountPoint/nix/var/nix/temproots \
    $mountPoint/nix/var/nix/userpool \
    $mountPoint/nix/var/nix/profiles \
    $mountPoint/nix/var/nix/db \
    $mountPoint/nix/var/log/nix/drvs

mkdir -m 1775 -p $mountPoint/nix/store

# All Nix operations below should operate on our target store, not /nix/store.
# N.B: this relies on Nix 1.12 or higher
export NIX_REMOTE=local?root=$mountPoint

# Copy our closures to the Nix store on the target mount point, unless they're already there.
for i in $closures; do
    # We support closures both in the format produced by `nix-store --export` and by `exportReferencesGraph`,
    # mostly because there doesn't seem to be a single format that can be produced outside of a nix build and
    # inside one. See https://github.com/NixOS/nix/issues/1242 for more discussion.
    if [[ "$i" =~ \.closure$ ]]; then
        echo "importing serialized closure $i to $mountPoint..."
        nix-store --import < $i
    else
        # There has to be a better way to do this, right?
        echo "copying closure $i to $mountPoint..."
        for j in $(perl @pathsFromGraph@ $i); do
            echo "  $j... "
            rsync -a $j $mountPoint/nix/store/
        done

        nix-store --option build-users-group root --register-validity < $i
    fi
done

# Create the required /bin/sh symlink; otherwise lots of things
# (notably the system() function) won't work.
if [ ! -x $mountPoint/@shell@ ]; then
    echo "Error: @shell@ wasn't included in the closure" >&2
    exit 1
fi
mkdir -m 0755 -p $mountPoint/bin
ln -sf @shell@ $mountPoint/bin/sh

echo "setting the system closure to '$system'..."
nix-env "${extraBuildFlags[@]}" -p $mountPoint/nix/var/nix/profiles/system --set "$system"

ln -sfn /nix/var/nix/profiles/system $mountPoint/run/current-system

# Copy the NixOS/Nixpkgs sources to the target as the initial contents of the NixOS channel.
mkdir -m 0755 -p $mountPoint/nix/var/nix/profiles
mkdir -m 1777 -p $mountPoint/nix/var/nix/profiles/per-user
mkdir -m 0755 -p $mountPoint/nix/var/nix/profiles/per-user/root

if [ -z "$noChannelCopy" ] && [ -n "$channel" ]; then
    echo "copying channel..."
    nix-env --option build-use-substitutes false "${extraBuildFlags[@]}" -p $mountPoint/nix/var/nix/profiles/per-user/root/channels --set "$channel" --quiet
fi
mkdir -m 0700 -p $mountPoint/root/.nix-defexpr
ln -sfn /nix/var/nix/profiles/per-user/root/channels $mountPoint/root/.nix-defexpr/channels

# Mark the target as a NixOS installation, otherwise switch-to-configuration will chicken out.
touch $mountPoint/etc/NIXOS

