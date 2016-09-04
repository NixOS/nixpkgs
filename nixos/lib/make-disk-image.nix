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

      # Register the paths in the Nix database.
      printRegistration=1 perl ${pkgs.pathsFromGraph} /tmp/xchg/closure | \
          ${config.nix.package.out}/bin/nix-store --load-db --option build-users-group ""

      # Add missing size/hash fields to the database. FIXME:
      # exportReferencesGraph should provide these directly.
      ${config.nix.package.out}/bin/nix-store --verify --check-contents --option build-users-group ""

      # In case the bootloader tries to write to /dev/sda…
      ln -s vda /dev/xvda
      ln -s vda /dev/sda

      # Install the closure onto the image
      USER=root ${config.system.build.nixos-install}/bin/nixos-install \
        --closure ${config.system.build.toplevel} \
        --no-channel-copy \
        --no-root-passwd \
        ${optionalString (!installBootLoader) "--no-bootloader"}

      # Install a configuration.nix.
      mkdir -p /mnt/etc/nixos
      ${optionalString (configFile != null) ''
        cp ${configFile} /mnt/etc/nixos/configuration.nix
      ''}

      # Remove /etc/machine-id so that each machine cloning this image will get its own id
      rm -f /mnt/etc/machine-id

      umount /mnt

      # Do a fsck to make sure resize2fs works.
      fsck.${fsType} -f -y $rootDisk
    ''
)
