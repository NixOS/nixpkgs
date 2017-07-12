#! @shell@

# - make Nix store etc.
# - copy closure of Nix to target device
# - register validity
# - with a chroot to the target device:
#   * nix-env -p /nix/var/nix/profiles/system -i <nix-expr for the configuration>
#   * install the boot loader

# Ensure a consistent umask.
umask 0022

# Re-exec ourselves in a private mount namespace so that our bind
# mounts get cleaned up automatically.
if [ "$(id -u)" = 0 ]; then
    if [ -z "$NIXOS_INSTALL_REEXEC" ]; then
        export NIXOS_INSTALL_REEXEC=1
        exec unshare --mount --uts -- "$0" "$@"
    else
        mount --make-rprivate /
    fi
fi

# Parse the command line for the -I flag
extraBuildFlags=()
chrootCommand=(/run/current-system/sw/bin/bash)
buildUsersGroup="nixbld"

while [ "$#" -gt 0 ]; do
    i="$1"; shift 1
    case "$i" in
        --max-jobs|-j|--cores|-I)
            j="$1"; shift 1
            extraBuildFlags+=("$i" "$j")
            ;;
        --option)
            j="$1"; shift 1
            k="$1"; shift 1
            extraBuildFlags+=("$i" "$j" "$k")
            ;;
        --root)
            mountPoint="$1"; shift 1
            ;;
        --closure)
            closure="$1"; shift 1
            buildUsersGroup=""
            ;;
        --no-channel-copy)
            noChannelCopy=1
            ;;
        --no-root-passwd)
            noRootPasswd=1
            ;;
        --no-bootloader)
            noBootLoader=1
            ;;
        --show-trace)
            extraBuildFlags+=("$i")
            ;;
        --chroot)
            runChroot=1
            if [[ "$@" != "" ]]; then
                chrootCommand=("$@")
            fi
            break
            ;;
        --help)
            exec man nixos-install
            exit 1
            ;;
        *)
            echo "$0: unknown option \`$i'"
            exit 1
            ;;
    esac
done

set -e
shopt -s nullglob

if test -z "$mountPoint"; then
    mountPoint=/mnt
fi

if ! test -e "$mountPoint"; then
    echo "mount point $mountPoint doesn't exist"
    exit 1
fi

# Get the path of the NixOS configuration file.
if test -z "$NIXOS_CONFIG"; then
    NIXOS_CONFIG=/etc/nixos/configuration.nix
fi

if [ ! -e "$mountPoint/$NIXOS_CONFIG" ] && [ -z "$closure" ]; then
    echo "configuration file $mountPoint/$NIXOS_CONFIG doesn't exist"
    exit 1
fi


# Builds will use users that are members of this group
extraBuildFlags+=(--option "build-users-group" "$buildUsersGroup")

# Inherit binary caches from the host
# TODO: will this still work with Nix 1.12 now that it has no perl? Probably not... 
binary_caches="$(@perl@/bin/perl -I @nix@/lib/perl5/site_perl/*/* -e 'use Nix::Config; Nix::Config::readConfig; print $Nix::Config::config{"binary-caches"};')"
extraBuildFlags+=(--option "binary-caches" "$binary_caches")

# We only need nixpkgs in the path if we don't already have a system closure to install
if [[ -z "$closure" ]]; then
    nixpkgs="$(readlink -f "$(nix-instantiate --find-file nixpkgs)")"
    export NIX_PATH="nixpkgs=$nixpkgs:nixos-config=$mountPoint/$NIXOS_CONFIG"
fi
unset NIXOS_CONFIG

# TODO: do I need to set NIX_SUBSTITUTERS here or is the --option binary-caches above enough?


# A place to drop temporary closures
trap "rm -rf $tmpdir" EXIT
tmpdir="$(mktemp -d)"

# Build a closure (on the host; we then copy it into the guest)
function closure() {
    nix-build "${extraBuildFlags[@]}" --no-out-link -E "with import <nixpkgs> {}; runCommand \"closure\" { exportReferencesGraph = [ \"x\" (buildEnv { name = \"env\"; paths = [ ($1) stdenv ]; }) ]; } \"cp x \$out\""
}

system_closure="$tmpdir/system.closure"
# Use a FIFO for piping nix-store --export into nix-store --import, saving disk
# I/O and space. nix-store --import is run by nixos-prepare-root.
mkfifo $system_closure

if [ -z "$closure" ]; then
    expr="(import <nixpkgs/nixos> {}).system"
    system_root="$(nix-build -E "$expr")"
    system_closure="$(closure "$expr")"
else
    system_root=$closure
    # Create a temporary file ending in .closure (so nixos-prepare-root knows to --import it) to transport the store closure
    # to the filesytem we're preparing. Also delete it on exit!
    # Run in background to avoid blocking while trying to write to the FIFO
    # $system_closure refers to
    nix-store --export $(nix-store -qR $closure) > $system_closure &
fi

channel_root="$(nix-env -p /nix/var/nix/profiles/per-user/root/channels -q nixos --no-name --out-path 2>/dev/null || echo -n "")"
channel_closure="$tmpdir/channel.closure"
nix-store --export $channel_root > $channel_closure

# Populate the target root directory with the basics
@prepare_root@/bin/nixos-prepare-root "$mountPoint" "$channel_root" "$system_root" @nixClosure@ "$system_closure" "$channel_closure"

# nixos-prepare-root doesn't currently do anything with file ownership, so we set it up here instead
chown @root_uid@:@nixbld_gid@ $mountPoint/nix/store

mount --rbind /dev $mountPoint/dev
mount --rbind /proc $mountPoint/proc
mount --rbind /sys $mountPoint/sys

# Grub needs an mtab.
ln -sfn /proc/mounts $mountPoint/etc/mtab

# Switch to the new system configuration.  This will install Grub with
# a menu default pointing at the kernel/initrd/etc of the new
# configuration.
echo "finalising the installation..."
if [ -z "$noBootLoader" ]; then
  NIXOS_INSTALL_BOOTLOADER=1 chroot $mountPoint \
      /nix/var/nix/profiles/system/bin/switch-to-configuration boot
fi

# Run the activation script.
chroot $mountPoint /nix/var/nix/profiles/system/activate


# Ask the user to set a root password.
if [ -z "$noRootPasswd" ] && chroot $mountPoint [ -x /run/wrappers/bin/passwd ] && [ -t 0 ]; then
    echo "setting root password..."
    chroot $mountPoint /run/wrappers/bin/passwd
fi


echo "installation finished!"
