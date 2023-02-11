{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.amazonImage;
  amiBootMode = if config.ec2.efi then "uefi" else "legacy-bios";

in {

  imports = [ ../../../modules/virtualisation/amazon-image.nix ];

  # Amazon recomments setting this to the highest possible value for a good EBS
  # experience, which prior to 4.15 was 255.
  # https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/nvme-ebs-volumes.html#timeout-nvme-ebs-volumes
  config.boot.kernelParams =
    let timeout =
      if pkgs.lib.versionAtLeast config.boot.kernelPackages.kernel.version "4.15"
      then "4294967295"
      else  "255";
    in [ "nvme_core.io_timeout=${timeout}" ];

  options.amazonImage = {
    name = mkOption {
      type = types.str;
      description = lib.mdDoc "The name of the generated derivation";
      default = "nixos-amazon-image-${config.system.nixos.label}-${pkgs.stdenv.hostPlatform.system}";
    };

    contents = mkOption {
      example = literalExpression ''
        [ { source = pkgs.memtest86 + "/memtest.bin";
            target = "boot/memtest.bin";
          }
        ]
      '';
      default = [];
      description = lib.mdDoc ''
        This option lists files to be copied to fixed locations in the
        generated image. Glob patterns work.
      '';
    };

    sizeMB = mkOption {
      type = with types; either (enum [ "auto" ]) int;
      default = 2048;
      example = 8192;
      description = lib.mdDoc "The size in MB of the image";
    };

    format = mkOption {
      type = types.enum [ "raw" "qcow2" "vpc" ];
      default = "vpc";
      description = lib.mdDoc "The image format to output";
    };
  };

  config.system.build.amazonImage = let
    configFile = pkgs.writeText "configuration.nix"
      ''
        { modulesPath, ... }: {
          imports = [ "''${modulesPath}/virtualisation/amazon-image.nix" ];
          ${optionalString config.ec2.efi ''
            ec2.efi = true;
          ''}
          ${optionalString config.ec2.zfs.enable ''
            ec2.zfs.enable = true;
            networking.hostId = "${config.networking.hostId}";
          ''}
        }
      '';

    zfsBuilder = import ../../../lib/make-multi-disk-zfs-image.nix {
      inherit lib config configFile;
      inherit (cfg) contents format name;
      pkgs = import ../../../.. { inherit (pkgs) system; }; # ensure we use the regular qemu-kvm package

      includeChannel = true;

      bootSize = 1000; # 1G is the minimum EBS volume

      rootSize = cfg.sizeMB;
      rootPoolProperties = {
        ashift = 12;
        autoexpand = "on";
      };

      datasets = config.ec2.zfs.datasets;

      postVM = ''
        extension=''${rootDiskImage##*.}
        friendlyName=$out/${cfg.name}
        rootDisk="$friendlyName.root.$extension"
        bootDisk="$friendlyName.boot.$extension"
        mv "$rootDiskImage" "$rootDisk"
        mv "$bootDiskImage" "$bootDisk"

        mkdir -p $out/nix-support
        echo "file ${cfg.format} $bootDisk" >> $out/nix-support/hydra-build-products
        echo "file ${cfg.format} $rootDisk" >> $out/nix-support/hydra-build-products

       ${pkgs.jq}/bin/jq -n \
         --arg system_label ${lib.escapeShellArg config.system.nixos.label} \
         --arg system ${lib.escapeShellArg pkgs.stdenv.hostPlatform.system} \
         --arg root_logical_bytes "$(${pkgs.qemu}/bin/qemu-img info --output json "$rootDisk" | ${pkgs.jq}/bin/jq '."virtual-size"')" \
         --arg boot_logical_bytes "$(${pkgs.qemu}/bin/qemu-img info --output json "$bootDisk" | ${pkgs.jq}/bin/jq '."virtual-size"')" \
         --arg boot_mode "${amiBootMode}" \
         --arg root "$rootDisk" \
         --arg boot "$bootDisk" \
        '{}
          | .label = $system_label
          | .boot_mode = $boot_mode
          | .system = $system
          | .disks.boot.logical_bytes = $boot_logical_bytes
          | .disks.boot.file = $boot
          | .disks.root.logical_bytes = $root_logical_bytes
          | .disks.root.file = $root
          ' > $out/nix-support/image-info.json
      '';
    };

    extBuilder = import ../../../lib/make-disk-image.nix {
      inherit lib config configFile;

      inherit (cfg) contents format name;
      pkgs = import ../../../.. { inherit (pkgs) system; }; # ensure we use the regular qemu-kvm package

      fsType = "ext4";
      partitionTableType = if config.ec2.efi then "efi" else "legacy+gpt";

      diskSize = cfg.sizeMB;

      postVM = ''
        extension=''${diskImage##*.}
        friendlyName=$out/${cfg.name}.$extension
        mv "$diskImage" "$friendlyName"
        diskImage=$friendlyName

        mkdir -p $out/nix-support
        echo "file ${cfg.format} $diskImage" >> $out/nix-support/hydra-build-products

       ${pkgs.jq}/bin/jq -n \
         --arg system_label ${lib.escapeShellArg config.system.nixos.label} \
         --arg system ${lib.escapeShellArg pkgs.stdenv.hostPlatform.system} \
         --arg logical_bytes "$(${pkgs.qemu}/bin/qemu-img info --output json "$diskImage" | ${pkgs.jq}/bin/jq '."virtual-size"')" \
         --arg boot_mode "${amiBootMode}" \
         --arg file "$diskImage" \
          '{}
          | .label = $system_label
          | .boot_mode = $boot_mode
          | .system = $system
          | .logical_bytes = $logical_bytes
          | .file = $file
          | .disks.root.logical_bytes = $logical_bytes
          | .disks.root.file = $file
          ' > $out/nix-support/image-info.json
      '';
    };
  in if config.ec2.zfs.enable then zfsBuilder else extBuilder;
}
