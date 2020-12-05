# This module creates a bootable SD card image containing the given NixOS
# configuration. The generated image is MBR partitioned, with a FAT
# /boot partition, and f2fs root partition. The generated image
# is sized to fit its contents, and a boot script automatically resizes
# the root partition to fit the device on the first boot.
#
# The derivation for the SD image will be placed in
# config.system.build.sdImage

{ config, lib, pkgs, ... }:

with lib;

let
  rootfsImage = pkgs.callPackage ../../../lib/make-f2fs-fs.nix ({
    inherit (config.sdImage) storePaths;
    compressImage = true;
    populateImageCommands = config.sdImage.populateRootCommands;
    volumeLabel = "NIXOS_SD";
  } // optionalAttrs (config.sdImage.rootPartitionUUID != null) {
    uuid = config.sdImage.rootPartitionUUID;
  });
in
{
  options.sdImage = {
    imageName = mkOption {
      default = "${config.sdImage.imageBaseName}-${config.system.nixos.label}-${pkgs.stdenv.hostPlatform.system}.img";
      description = ''
        Name of the generated image file.
      '';
    };

    imageBaseName = mkOption {
      default = "nixos-sd-image";
      description = ''
        Prefix of the name of the generated image file.
      '';
    };

    storePaths = mkOption {
      type = with types; listOf package;
      example = literalExample "[ pkgs.stdenv ]";
      description = ''
        Derivations to be included in the Nix store in the generated SD image.
      '';
    };

    bootPartitionID = mkOption {
      type = types.str;
      default = "0x2178694e";
      description = ''
        Volume ID for the /boot partition on the SD card. This value
        must be a 32-bit hexadecimal number.
      '';
    };

    bootPartitionName = mkOption {
      type = types.str;
      default = "NIXOS_BOOT";
      description = ''
        Name of the filesystem which holds /boot.
      '';
    };

    rootPartitionUUID = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "14e19a7b-0ae0-484d-9d54-43bd6fdc20c7";
      description = ''
        UUID for the filesystem on the main NixOS partition on the SD card.
      '';
    };

    bootSize = mkOption {
      type = types.int;
      # As of 2019-08-18 the Raspberry pi firmware + u-boot takes ~18MiB
      # A kernel, initrd, and dtbs are about 60MiB, and we want room for at least 2
      default = 248;
      description = ''
        Size of the /boot partition, in megabytes.
      '';
    };

    populateBootCommands = mkOption {
      example = literalExample "'' cp \${pkgs.myBootLoader}/u-boot.bin boot/ ''";
      description = ''
        Shell commands to populate the ./boot directory.
        All files in that directory are copied to the
        /boot partition on the SD image.
      '';
    };

    populateRootCommands = mkOption {
      default = "";
      description = ''
        Shell commands to populate the ./files directory.
        All files in that directory are copied to the
        root (/) partition on the SD image. This can be used
        to inject files into the rootfs.
      '';
    };

    postBuildCommands = mkOption {
      example = literalExample "'' dd if=\${pkgs.myBootLoader}/SPL of=$img bs=1024 seek=1 conv=notrunc ''";
      default = "";
      description = ''
        Shell commands to run after the image is built.
        Can be used for boards requiring to dd u-boot SPL before actual partitions.
      '';
    };

    compressImage = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether the SD image should be compressed using
        <command>zstd</command>.
      '';
    };

  };

  config = {
    fileSystems = {
      "/boot" = {
        device = "/dev/disk/by-label/${config.sdImage.bootPartitionName}";
        fsType = "vfat";
      };
      "/" = {
        device = "/dev/disk/by-label/NIXOS_SD";
        fsType = "f2fs";
        autoResize = true;
        autoExpand = true;
      };
    };

    sdImage.storePaths = [ config.system.build.toplevel ];

    system.build.sdImage = pkgs.callPackage ({ stdenv, dosfstools, f2fs-tools,
    mtools, libfaketime, utillinux, zstd }: stdenv.mkDerivation {
      name = config.sdImage.imageName;

      nativeBuildInputs = [ dosfstools f2fs-tools mtools libfaketime utillinux zstd ];

      inherit (config.sdImage) compressImage;

      buildCommand = ''
        mkdir -p $out/nix-support $out/sd-image
        export img=$out/sd-image/${config.sdImage.imageName}

        echo "${pkgs.stdenv.buildPlatform.system}" > $out/nix-support/system
        if test -n "$compressImage"; then
          echo "file sd-image $img.zst" >> $out/nix-support/hydra-build-products
        else
          echo "file sd-image $img" >> $out/nix-support/hydra-build-products
        fi

        echo "Decompressing rootfs image"
        zstd -d --no-progress "${rootfsImage}" -o ./root-fs.img

        # Gap in front of the first partition, in MiB
        gap=8

        # Create the image file sized to fit /boot and /, plus slack for the gap.
        rootSizeBlocks=$(du -B 512 --apparent-size ./root-fs.img | awk '{ print $1 }')
        bootSizeBlocks=$((${toString config.sdImage.bootSize} * 1024 * 1024 / 512))
        imageSize=$((rootSizeBlocks * 512 + bootSizeBlocks * 512 + gap * 1024 * 1024))
        truncate -s $imageSize $img

        # type=b is 'W95 FAT32', type=83 is 'Linux'.
        # The "bootable" partition is where u-boot will look file for the bootloader
        # information (dtbs, extlinux.conf file).
        sfdisk $img <<EOF
            label: dos
            label-id: ${config.sdImage.bootPartitionID}

            start=''${gap}M, size=$bootSizeBlocks, type=b, bootable
            start=$((gap + ${toString config.sdImage.bootSize}))M, type=83
        EOF

        # Copy the rootfs into the SD image
        eval $(partx $img -o START,SECTORS --nr 2 --pairs)
        dd conv=notrunc if=./root-fs.img of=$img seek=$START count=$SECTORS

        # Create a FAT32 /boot partition of suitable size into bootpart.img
        eval $(partx $img -o START,SECTORS --nr 1 --pairs)
        truncate -s $((SECTORS * 512)) bootpart.img
        faketime "1970-01-01 00:00:00" mkfs.vfat -i ${config.sdImage.bootPartitionID} -n ${config.sdImage.bootPartitionName} bootpart.img

        # Populate the files intended for /boot
        mkdir boot
        ${config.sdImage.populateBootCommands}

        # Copy the populated /boot into the SD image
        (cd boot; mcopy -psvm -i ../bootpart.img ./* ::)
        # Verify the FAT partition before copying it.
        fsck.vfat -vn bootpart.img
        dd conv=notrunc if=bootpart.img of=$img seek=$START count=$SECTORS

        ${config.sdImage.postBuildCommands}

        if test -n "$compressImage"; then
            zstd -T$NIX_BUILD_CORES --rm $img
        fi
      '';
    }) {};

    boot.postBootCommands = ''
      # On the first boot do some maintenance tasks
      if [ -f /nix-path-registration ]; then
        set -euo pipefail
        set -x

        # Register the contents of the initial Nix store
        ${config.nix.package.out}/bin/nix-store --load-db < /nix-path-registration

        # nixos-rebuild also requires a "system" profile and an /etc/NIXOS tag.
        touch /etc/NIXOS
        ${config.nix.package.out}/bin/nix-env -p /nix/var/nix/profiles/system --set /run/current-system

        # Prevents this from running on later boots.
        rm -f /nix-path-registration
      fi
    '';
  };
}
