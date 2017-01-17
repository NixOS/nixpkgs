{ pkgs
, lib

, # The NixOS configuration to be installed onto the disk image.
  config

, # The size of the disk, in megabytes.
  diskSize

, # Whether the disk should be partitioned (with a single partition
  # containing the root filesystem) or contain the root filesystem
  # directly.
  partitioned ? true

  # Whether to invoke switch-to-configuration boot during image creation
, installBootLoader ? true

, # The root file system type.
  fsType ? "ext4"

, # The initial NixOS configuration file to be copied to
  # /etc/nixos/configuration.nix.
  configFile ? null

, # Shell code executed after the VM has finished.
  postVM ? ""

, name ? "nixos-disk-image"

  # This prevents errors while checking nix-store validity, see
  # https://github.com/NixOS/nix/issues/1134
, fixValidity ? true

, format ? "raw"
}:

with lib;

let
  # Copied from https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/installer/cd-dvd/channel.nix
  channelSources = pkgs.runCommand "nixos-${config.system.nixosVersion}" {} ''
    mkdir -p $out
    cp -prd ${pkgs.path} $out/nixos
    chmod -R u+w $out/nixos
    if [ ! -e $out/nixos/nixpkgs ]; then
      ln -s . $out/nixos/nixpkgs
    fi
    rm -rf $out/nixos/.git
    echo -n ${config.system.nixosVersionSuffix} > $out/nixos/.version-suffix
  '';

  metaClosure = pkgs.writeText "meta" ''
    ${config.system.build.toplevel}
    ${config.nix.package.out}
    ${channelSources}
  '';

  prepareImageInputs = with pkgs; [ utillinux parted e2fsprogs rsync fakeroot fakechroot perl lkl config.nix.package ];

  prepareImage = ''
    export PATH=${pkgs.lib.makeSearchPathOutput "bin" "bin" (prepareImageInputs ++ pkgs.stdenv.initialPath)}
    mkdir $out
    diskImage=$out/nixos.img
    truncate -s ${toString diskSize}M $diskImage
  
    ${if partitioned then ''
      parted $diskImage -- mklabel msdos mkpart primary ext4 1M -1s
      offset=$((2048*512))
    '' else ''
      offset=0
    ''}
  
    mkfs.${fsType} -F -L nixos -E offset=$offset $diskImage
  
    umask 0022
  
    root="$PWD/root"

    # A big chunk of this code was stolen from https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/installer/tools/nixos-install.sh
    # which we can't use directly because it assumes it owns the machine. TODO: refactor the code so we can share the relevant parts with it. 
    mkdir -m 0755 -p $root/{dev,proc,sys,etc,run,home}
    mkdir -m 01777 -p $root/tmp
    mkdir -m 0755 -p $root/tmp/root
    mkdir -m 0755 -p $root/var
    mkdir -m 0700 -p $root/root
    ln -s /run $root/var/run
  
    ln -s /nix/var/nix/profiles/system $root/run/current-system
  
    mkdir -m 0755 -p \
      $root/nix/var/nix/gcroots \
      $root/nix/var/nix/temproots \
      $root/nix/var/nix/userpool \
      $root/nix/var/nix/profiles \
      $root/nix/var/nix/db \
      $root/nix/var/log/nix/drvs
  
    mkdir -m 1755 -p $root/nix/store
  
    echo "copying system closure to staging area..."
    for i in $(perl ${pkgs.pathsFromGraph} closure); do
      chattr -R -i $root/$i 2> /dev/null || true # clear immutable bit
      ${pkgs.rsync}/bin/rsync -a $i $root/nix/store
    done

    mkdir -m 0755 -p "$root/bin/"
    ln -sf ${pkgs.stdenv.shell} "$root/bin/sh"
  
    mkdir -m 0755 -p "$root/nix/var/nix/profiles"
    mkdir -m 1777 -p "$root/nix/var/nix/profiles/per-user"
    mkdir -m 0755 -p "$root/nix/var/nix/profiles/per-user/root"
  
    mkdir -m 0700 -p $root/root/.nix-defexpr
    ln -sfn /nix/var/nix/profiles/per-user/root/channels $root/root/.nix-defexpr/channels
  
    ln -sfn /proc/mounts $root/etc/mtab
  
    touch $root/etc/NIXOS

    echo "faking stuff..."
    fakechroot -- chroot $root nix-store --option build-users-group "" --register-validity < closure

    # XXX: do I need to do these with nix-env? Not sure if it does anything except create two symlinks, which I then need to fix up...
    fakechroot -- chroot $root nix-env --option build-users-group "" --option build-use-substitutes false -p /nix/var/nix/profiles/per-user/root/channels --set ${channelSources}
    fakechroot -- chroot $root nix-env --option build-users-group "" --option build-use-substitutes false -p /nix/var/nix/profiles/system --set ${config.system.build.toplevel}
    
    # Fix up the bad symlinks we get as a result of fakechroot above... :(
    ln -snf ${channelSources} $root/nix/var/nix/profiles/per-user/root/$(readlink $root/nix/var/nix/profiles/per-user/root/channels)
    ln -snf ${config.system.build.toplevel} $root/nix/var/nix/profiles/$(readlink $root/nix/var/nix/profiles/system)

    ${pkgs.lib.optionalString fixValidity ''
      echo "fixing validity..."
      fakechroot -- chroot $root nix-store --verify --check-contents --option build-users-group ""
    ''}

    echo "copying staging root to image..."
    cptofs ${pkgs.lib.optionalString partitioned "-P 1"} -t ${fsType} -i $diskImage $root/* /
  '';
in pkgs.vmTools.runInLinuxVM (
  pkgs.runCommand name {
    preVM = prepareImage;
    buildInputs = with pkgs; [ utillinux config.nix.package ];
    exportReferencesGraph = [ "closure" metaClosure ];
    inherit postVM;
    memSize = 1024;
  }
  # This entire VM block exists because the activation and switch-to-configuration scripts assume global things, and currently need to be run
  # inside a real chroot (unlike the fakechroots we have above). If we can kill those parts, we can kill the VM stuff altogether, which takes
  # the majority of the build time on EC2, even with a ~1G store.
  ''
    ${if partitioned then ''
      . /sys/class/block/vda1/uevent
      mknod /dev/vda1 b $MAJOR $MINOR
      rootDisk=/dev/vda1
    '' else ''
      rootDisk=/dev/vda
    ''}

    ln -s vda /dev/xvda
    ln -s vda /dev/sda

    mountPoint=/mnt

    mkdir $mountPoint
    mount $rootDisk $mountPoint

    mount --rbind /dev $mountPoint/dev
    mount --rbind /proc $mountPoint/proc
    mount --rbind /sys $mountPoint/sys

    NIXOS_INSTALL_BOOTLOADER=1 chroot $mountPoint /nix/var/nix/profiles/system/bin/switch-to-configuration boot

    chroot $mountPoint /nix/var/nix/profiles/system/activate

    rm -f $mountPoint/etc/machine-id
  ''
)

