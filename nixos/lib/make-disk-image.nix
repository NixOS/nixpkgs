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

, # The root file system type.
  fsType ? "ext4"

, # The initial NixOS configuration file to be copied to
  # /etc/nixos/configuration.nix.
  configFile ? null

, # Shell code executed after the VM has finished.
  postVM ? ""

, name ? "nixos-disk-image"

, format ? "raw"
}:

with lib;

pkgs.vmTools.runInLinuxVM (
  pkgs.runCommand name
    { preVM =
        ''
          mkdir $out
          diskImage=$out/nixos.${if format == "qcow2" then "qcow2" else "img"}
          ${pkgs.vmTools.qemu}/bin/qemu-img create -f ${format} $diskImage "${toString diskSize}M"
          mv closure xchg/
        '';
      buildInputs = [ pkgs.utillinux pkgs.perl pkgs.e2fsprogs pkgs.parted ];
      exportReferencesGraph =
        [ "closure" config.system.build.toplevel ];
      inherit postVM;
      memSize = 1024;
    }
    ''
      ${if partitioned then ''
        # Create a single / partition.
        parted /dev/vda mklabel msdos
        parted /dev/vda -- mkpart primary ext2 1M -1s
        . /sys/class/block/vda1/uevent
        mknod /dev/vda1 b $MAJOR $MINOR
        rootDisk=/dev/vda1
      '' else ''
        rootDisk=/dev/vda
      ''}

      # Create an empty filesystem and mount it.
      mkfs.${fsType} -L nixos $rootDisk
      ${optionalString (fsType == "ext4") ''
        tune2fs -c 0 -i 0 $rootDisk
      ''}
      mkdir /mnt
      mount $rootDisk /mnt

      # The initrd expects these directories to exist.
      mkdir /mnt/dev /mnt/proc /mnt/sys

      mount -o bind /proc /mnt/proc
      mount -o bind /dev /mnt/dev
      mount -o bind /sys /mnt/sys

      # Copy all paths in the closure to the filesystem.
      storePaths=$(perl ${pkgs.pathsFromGraph} /tmp/xchg/closure)

      mkdir -p /mnt/nix/store
      echo "copying everything (will take a while)..."
      set -f
      cp -prd $storePaths /mnt/nix/store/

      # Register the paths in the Nix database.
      printRegistration=1 perl ${pkgs.pathsFromGraph} /tmp/xchg/closure | \
          chroot /mnt ${config.nix.package.out}/bin/nix-store --load-db --option build-users-group ""

      # Add missing size/hash fields to the database. FIXME:
      # exportReferencesGraph should provide these directly.
      chroot /mnt ${config.nix.package.out}/bin/nix-store --verify --check-contents

      # Create the system profile to allow nixos-rebuild to work.
      chroot /mnt ${config.nix.package.out}/bin/nix-env --option build-users-group "" \
          -p /nix/var/nix/profiles/system --set ${config.system.build.toplevel}

      # `nixos-rebuild' requires an /etc/NIXOS.
      mkdir -p /mnt/etc
      touch /mnt/etc/NIXOS

      # `switch-to-configuration' requires a /bin/sh
      mkdir -p /mnt/bin
      ln -s ${config.system.build.binsh}/bin/sh /mnt/bin/sh

      # Install a configuration.nix.
      mkdir -p /mnt/etc/nixos
      ${optionalString (configFile != null) ''
        cp ${configFile} /mnt/etc/nixos/configuration.nix
      ''}

      # Generate the GRUB menu.
      ln -s vda /dev/xvda
      ln -s vda /dev/sda
      chroot /mnt ${config.system.build.toplevel}/bin/switch-to-configuration boot

      umount /mnt/proc /mnt/dev /mnt/sys
      umount /mnt

      # Do a fsck to make sure resize2fs works.
      fsck.${fsType} -f -y $rootDisk
    ''
)
