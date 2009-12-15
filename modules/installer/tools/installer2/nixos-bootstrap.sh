#! @shell@
# runs in chroot
# creates mandatory directories such as /var
# finally runs switch-to-configuration optionally registering grub
set -e

usage(){
  cat << EOF
  script --install [--fast] [--no-grub]

  --no-pull:  don't do a nix-pull to get the latest Nixpkgs
              channel manifest

  --no-grub:  don't install grub ( you don't want this ..)

  --debug:    set -x

  options which will be passed to nix-env:

  -j n        : number of build tasks done simultaniously
  --keep-going: Build as much as possible.

  Description:
  This scripts installs NixOS and should be run within the target chroot.

  The minimal nix system must have been installed previously.
  Eg nixos-prepare-install.sh does this for you.

  Probably this script is distributed along with the minimal nix closure used
  for bootstrapping
EOF
  exit 1
}

die(){ echo "!>> " $@; exit 1; }

check(){
  [ -e "$1" ] || die "$1 not found $2"
}
WARN(){ echo "WARNING: $@"; }
INFO(){ echo "INFO: " $@; }

# == configuration ==

HOME=${HOME:-/root}
NIXOS=${NIXOS:-/etc/nixos/nixos}
NIXPKGS=${NIXPKGS:-/etc/nixos/nixpkgs}
NIXOS_CONFIG=${NIXOS_CONFIG:-/etc/nixos/configuration.nix}
NIXOS_PULL=${NIXOS_PULL:-1}
NIXOS_INSTALL_GRUB=${NIXOS_INSTALL_GRUB:-1} 

ps="run-in-chroot"

check "$NIXOS_CONFIG"
check "$NIXOS/modules"  "nixos repo not found"
check "$NIXPKGS/pkgs/top-level/all-packages.nix"  "nixpgks repo not found"
for d in /dev /sys /proc; do
  check "$d" "It should have been mounted by $ps"
done

# try reusing binaries from host system (which is most likely an installation CD)
if [ -d /host-system/nix ]; then
  export NIX_OTHER_STORES=/host-system/nix${NIX_OTHER_STORES:+:}$NIX_OTHER_STORES
else
  WARN "/host-system/nix not found. It should have been --bind mounted by $ps.
  I won't be able to take binaries from the installation media.
  "
fi

# == configuration end ==

INSTALL=

for arg in $@; do
  case $arg in
    --no-pull)     NIXOS_PULL=0;;
    --install)     INSTALL=1;;
    --no-grub)     NIXOS_INSTALL_GRUB=;;
    --debug)       set -x;;
    -j*)           NIX_ENV_ARGS="$NIX_ENV_ARGS $arg";;
    --keep-going)  NIX_ENV_ARGS="$NIX_ENV_ARGS $arg";;
    *)             usage;
  esac
done

if [ "$INSTALL" != 1 ]; then
  usage
fi


# We don't have locale-archive in the chroot, so clear $LANG.
export LANG=

export PATH=@coreutils@/bin

mkdir -m 01777 -p /tmp
mkdir -m 0755 -p /var

# Create the necessary Nix directories on the target device, if they
# don't already exist.
mkdir -m 0755 -p \
    /nix/var/nix/gcroots \
    /nix/var/nix/temproots \
    /nix/var/nix/manifests \
    /nix/var/nix/userpool \
    /nix/var/nix/profiles \
    /nix/var/nix/db \
    /nix/var/log/nix/drvs

# Do a nix-pull to speed up building.
if test -n "@nixpkgsURL@" -a ${NIXOS_PULL} != 0; then
    @nix@/bin/nix-pull @nixpkgsURL@/MANIFEST || true
fi

# Build the specified Nix expression in the target store and install
# it into the system configuration profile.
INFO "building the system configuration..."
@nix@/bin/nix-env \
    -p /nix/var/nix/profiles/system \
    -f "$NIXOS" \
    --arg configuration "import $NIXOS_CONFIG" \
    --set -A system \
    $NIX_ENV_ARGS

# Mark the target as a NixOS installation, otherwise
# switch-to-configuration will chicken out.
touch /etc/NIXOS

# Grub needs an mtab.
ln -sfn /proc/mounts /etc/mtab


# Switch to the new system configuration.  This will install Grub with
# a menu default pointing at the kernel/initrd/etc of the new
# configuration.
INFO "finalising the installation..."
export NIXOS_INSTALL_GRUB
/nix/var/nix/profiles/system/bin/switch-to-configuration boot
