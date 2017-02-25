{ pkgs
, lib

, # The NixOS configuration to be installed onto the disk image.
  config

, # The size of the disk, in megabytes.
  diskSize

  # The files and directories to be placed in the target file system.
  # This is a list of attribute sets {source, target} where `source'
  # is the file system object (regular file or directory) to be
  # grafted in the file system at path `target'.
, contents ? []

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

pkgs.vmTools.runInLinuxVM (
  pkgs.runCommand name
    { preVM =
        ''
          mkdir $out
          diskImage=$out/nixos.${if format == "qcow2" then "qcow2" else "img"}
          ${pkgs.vmTools.qemu}/bin/qemu-img create -f ${format} $diskImage "${toString diskSize}M"
          mv closure xchg/
        '';
      buildInputs = with pkgs; [ utillinux perl e2fsprogs parted rsync ];

      # I'm preserving the line below because I'm going to search for it across nixpkgs to consolidate
      # image building logic. The comment right below this now appears in 4 different places in nixpkgs :)
      # !!! should use XML.
      sources = map (x: x.source) contents;
      targets = map (x: x.target) contents;

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
      mkdir /mnt
      mount $rootDisk /mnt

      # Register the paths in the Nix database.
      printRegistration=1 perl ${pkgs.pathsFromGraph} /tmp/xchg/closure | \
          ${config.nix.package.out}/bin/nix-store --load-db --option build-users-group ""

      ${if fixValidity then ''
        # Add missing size/hash fields to the database. FIXME:
        # exportReferencesGraph should provide these directly.
        ${config.nix.package.out}/bin/nix-store --verify --check-contents --option build-users-group ""
      '' else ""}

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

      # Copy arbitrary other files into the image
      # Semi-shamelessly copied from make-etc.sh. I (@copumpkin) shall factor this stuff out as part of
      # https://github.com/NixOS/nixpkgs/issues/23052.
      set -f
      sources_=($sources)
      targets_=($targets)
      set +f

      for ((i = 0; i < ''${#targets_[@]}; i++)); do
        source="''${sources_[$i]}"
        target="''${targets_[$i]}"

        if [[ "$source" =~ '*' ]]; then

          # If the source name contains '*', perform globbing.
          mkdir -p /mnt/$target
          for fn in $source; do
            rsync -a --no-o --no-g "$fn" /mnt/$target/
          done

        else

          mkdir -p /mnt/$(dirname $target)
          if ! [ -e /mnt/$target ]; then
            rsync -a --no-o --no-g $source /mnt/$target
          else
            echo "duplicate entry $target -> $source"
            exit 1
          fi
        fi
      done

      umount /mnt

      # Make sure resize2fs works
      ${optionalString (fsType == "ext4") ''
        tune2fs -c 0 -i 0 $rootDisk
      ''}
    ''
)
