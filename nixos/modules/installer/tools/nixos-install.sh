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


# Mount some stuff in the target root directory.
mkdir -m 0755 -p $mountPoint/dev $mountPoint/proc $mountPoint/sys $mountPoint/etc $mountPoint/run $mountPoint/home
mkdir -m 01777 -p $mountPoint/tmp
mkdir -m 0755 -p $mountPoint/tmp/root
mkdir -m 0755 -p $mountPoint/var/setuid-wrappers
mkdir -m 0700 -p $mountPoint/root
mount --rbind /dev $mountPoint/dev
mount --rbind /proc $mountPoint/proc
mount --rbind /sys $mountPoint/sys
mount --rbind / $mountPoint/tmp/root
mount -t tmpfs -o "mode=0755" none $mountPoint/run
mkdir -p $mountPoint/run/user/0
mount -t tmpfs -o "mode=0755" none $mountPoint/var/setuid-wrappers
rm -rf $mountPoint/var/run
ln -s /run $mountPoint/var/run
rm -f $mountPoint/etc/{resolv.conf,hosts}
cp -Lf /etc/resolv.conf /etc/hosts $mountPoint/etc/

if [ -e "$SSL_CERT_FILE" ]; then
    cp -Lf "$SSL_CERT_FILE" "$mountPoint/tmp/ca-cert.crt"
    export SSL_CERT_FILE=/tmp/ca-cert.crt
    # For Nix 1.7
    export CURL_CA_BUNDLE=/tmp/ca-cert.crt
fi

if [ -n "$runChroot" ]; then
    if ! [ -L $mountPoint/nix/var/nix/profiles/system ]; then
        echo "$0: installation not finished; cannot chroot into installation directory"
        exit 1
    fi
    ln -s /nix/var/nix/profiles/system $mountPoint/run/current-system
    exec chroot $mountPoint "${chrootCommand[@]}"
fi


# Get the path of the NixOS configuration file.
if test -z "$NIXOS_CONFIG"; then
    NIXOS_CONFIG=/etc/nixos/configuration.nix
fi

if ! test -e "$mountPoint/$NIXOS_CONFIG"; then
    echo "configuration file $mountPoint/$NIXOS_CONFIG doesn't exist"
    exit 1
fi


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
chown root:nixbld $mountPoint/nix/store


# There is no daemon in the chroot.
unset NIX_REMOTE


# We don't have locale-archive in the chroot, so clear $LANG.
export LANG=
export LC_ALL=
export LC_TIME=


# Create a temporary Nix config file that causes the nixbld users to
# be used.
echo "build-users-group = nixbld" > $mountPoint/tmp/nix.conf # FIXME: remove in Nix 1.8
binary_caches=$(@perl@/bin/perl -I @nix@/lib/perl5/site_perl/*/* -e 'use Nix::Config; Nix::Config::readConfig; print $Nix::Config::config{"binary-caches"};')
if test -n "$binary_caches"; then
    echo "binary-caches = $binary_caches" >> $mountPoint/tmp/nix.conf
fi
export NIX_CONF_DIR=/tmp

touch $mountPoint/etc/passwd $mountPoint/etc/group
mount --bind -o ro /etc/passwd $mountPoint/etc/passwd
mount --bind -o ro /etc/group $mountPoint/etc/group


# Copy Nix to the Nix store on the target device, unless it's already there.
if ! NIX_DB_DIR=$mountPoint/nix/var/nix/db nix-store --check-validity @nix@ 2> /dev/null; then
    echo "copying Nix to $mountPoint...."
    for i in $(@perl@/bin/perl @pathsFromGraph@ @nixClosure@); do
        echo "  $i"
        chattr -R -i $mountPoint/$i 2> /dev/null || true # clear immutable bit
        rsync -a $i $mountPoint/nix/store/
    done

    # Register the paths in the Nix closure as valid.  This is necessary
    # to prevent them from being deleted the first time we install
    # something.  (I.e., Nix will see that, e.g., the glibc path is not
    # valid, delete it to get it out of the way, but as a result nothing
    # will work anymore.)
    chroot $mountPoint @nix@/bin/nix-store --register-validity < @nixClosure@
fi


# Create the required /bin/sh symlink; otherwise lots of things
# (notably the system() function) won't work.
mkdir -m 0755 -p $mountPoint/bin
# !!! assuming that @shell@ is in the closure
ln -sf @shell@ $mountPoint/bin/sh


# Build hooks likely won't function correctly in the minimal chroot; just disable them.
unset NIX_BUILD_HOOK

# Make the build below copy paths from the CD if possible.  Note that
# /tmp/root in the chroot is the root of the CD.
export NIX_OTHER_STORES=/tmp/root/nix:$NIX_OTHER_STORES

p=@nix@/libexec/nix/substituters
export NIX_SUBSTITUTERS=$p/copy-from-other-stores.pl:$p/download-from-binary-cache.pl


# Make manifests available in the chroot.
rm -f $mountPoint/nix/var/nix/manifests/*
for i in /nix/var/nix/manifests/*.nixmanifest; do
    chroot $mountPoint @nix@/bin/nix-store -r "$(readlink -f "$i")" > /dev/null
    cp -pd "$i" $mountPoint/nix/var/nix/manifests/
done


# Get the absolute path to the NixOS/Nixpkgs sources.
nixpkgs="$(readlink -f $(nix-instantiate --find-file nixpkgs))"


# Build the specified Nix expression in the target store and install
# it into the system configuration profile.
echo "building the system configuration..."
NIX_PATH="nixpkgs=/tmp/root/$nixpkgs:nixos-config=$NIXOS_CONFIG" NIXOS_CONFIG= \
    chroot $mountPoint @nix@/bin/nix-env \
    "${extraBuildFlags[@]}" -p /nix/var/nix/profiles/system -f '<nixpkgs/nixos>' --set -A system


# Copy the NixOS/Nixpkgs sources to the target as the initial contents
# of the NixOS channel.
mkdir -m 0755 -p $mountPoint/nix/var/nix/profiles
mkdir -m 1777 -p $mountPoint/nix/var/nix/profiles/per-user
mkdir -m 0755 -p $mountPoint/nix/var/nix/profiles/per-user/root
srcs=$(nix-env "${extraBuildFlags[@]}" -p /nix/var/nix/profiles/per-user/root/channels -q nixos --no-name --out-path 2>/dev/null || echo -n "")
if test -n "$srcs"; then
    echo "copying NixOS/Nixpkgs sources..."
    chroot $mountPoint @nix@/bin/nix-env \
        "${extraBuildFlags[@]}" -p /nix/var/nix/profiles/per-user/root/channels -i "$srcs" --quiet
fi
mkdir -m 0700 -p $mountPoint/root/.nix-defexpr
ln -sfn /nix/var/nix/profiles/per-user/root/channels $mountPoint/root/.nix-defexpr/channels


# Get rid of the /etc bind mounts.
umount $mountPoint/etc/passwd $mountPoint/etc/group


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


# Run the activation script.
chroot $mountPoint /nix/var/nix/profiles/system/activate


# Ask the user to set a root password.
if [ "$(chroot $mountPoint /run/current-system/sw/bin/sh -l -c "nix-instantiate --eval '<nixpkgs/nixos>' -A config.users.mutableUsers")" = true ] && [ -t 0 ] ; then
    echo "setting root password..."
    chroot $mountPoint /var/setuid-wrappers/passwd
fi


echo "installation finished!"
