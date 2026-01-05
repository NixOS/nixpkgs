{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkOption
    optionalString
    types
    versionAtLeast
    ;
  inherit (lib.options) literalExpression;
  cfg = config.amazonImage;
  amiBootMode = if config.ec2.efi then "uefi" else "legacy-bios";
in
{
  imports = [
    ../../../modules/virtualisation/amazon-image.nix
    ../../../modules/virtualisation/disk-size-option.nix
    ../../../modules/image/file-options.nix
    (lib.mkRenamedOptionModuleWith {
      sinceRelease = 2411;
      from = [
        "amazonImage"
        "sizeMB"
      ];
      to = [
        "virtualisation"
        "diskSize"
      ];
    })
    (lib.mkRenamedOptionModuleWith {
      sinceRelease = 2505;
      from = [
        "amazonImage"
        "name"
      ];
      to = [
        "image"
        "baseName"
      ];
    })
  ];

  # Amazon recommends setting this to the highest possible value for a good EBS
  # experience, which prior to 4.15 was 255.
  # https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/nvme-ebs-volumes.html#timeout-nvme-ebs-volumes
  config.boot.kernelParams =
    let
      timeout =
        if versionAtLeast config.boot.kernelPackages.kernel.version "4.15" then "4294967295" else "255";
    in
    [ "nvme_core.io_timeout=${timeout}" ];

  options.amazonImage = {
    contents = mkOption {
      example = literalExpression ''
        [ { source = pkgs.memtest86 + "/memtest.bin";
            target = "boot/memtest.bin";
          }
        ]
      '';
      default = [ ];
      description = ''
        This option lists files to be copied to fixed locations in the
        generated image. Glob patterns work.
      '';
    };

    format = mkOption {
      type = types.enum [
        "raw"
        "qcow2"
        "vpc"
      ];
      default = "vpc";
      description = "The image format to output";
    };
  };

  # Use a priority just below mkOptionDefault (1500) instead of lib.mkDefault
  # to avoid breaking existing configs using that.
  config.virtualisation.diskSize = lib.mkOverride 1490 (4 * 1024);
  config.virtualisation.diskSizeAutoSupported = !config.ec2.zfs.enable;

  config.system.nixos.tags = [ "amazon" ];
  config.system.build.image = config.system.build.amazonImage;
  config.image.extension = if cfg.format == "vpc" then "vhd" else cfg.format;

  config.system.build.amazonImage =
    let
      configFile = pkgs.writeText "configuration.nix" ''
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
        inherit
          lib
          config
          configFile
          pkgs
          ;
        inherit (cfg) contents format;
        name = config.image.baseName;

        includeChannel = true;

        bootSize = 1000; # 1G is the minimum EBS volume

        rootSize = config.virtualisation.diskSize;
        rootPoolProperties = {
          ashift = 12;
          autoexpand = "on";
        };

        datasets = config.ec2.zfs.datasets;

        postVM = ''
           extension=''${rootDiskImage##*.}
           friendlyName=$out/${config.image.baseName}
           rootDisk="$friendlyName.root.$extension"
           bootDisk="$friendlyName.boot.$extension"
           mv "$rootDiskImage" "$rootDisk"
           mv "$bootDiskImage" "$bootDisk"

           mkdir -p $out/nix-support
           echo "file ${cfg.format} $bootDisk" >> $out/nix-support/hydra-build-products
           echo "file ${cfg.format} $rootDisk" >> $out/nix-support/hydra-build-products

          ${pkgs.jq}/bin/jq -n \
            --arg system_version ${lib.escapeShellArg config.system.nixos.version} \
            --arg system ${lib.escapeShellArg pkgs.stdenv.hostPlatform.system} \
            --arg root_logical_bytes "$(${pkgs.qemu_kvm}/bin/qemu-img info --output json "$rootDisk" | ${pkgs.jq}/bin/jq '."virtual-size"')" \
            --arg boot_logical_bytes "$(${pkgs.qemu_kvm}/bin/qemu-img info --output json "$bootDisk" | ${pkgs.jq}/bin/jq '."virtual-size"')" \
            --arg boot_mode "${amiBootMode}" \
            --arg root "$rootDisk" \
            --arg boot "$bootDisk" \
           '{}
             | .label = $system_version
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
        inherit
          lib
          config
          configFile
          pkgs
          ;

        inherit (cfg) contents format;
        inherit (config.image) baseName;
        name = config.image.baseName;

        fsType = "ext4";
        partitionTableType = if config.ec2.efi then "efi" else "legacy+gpt";

        inherit (config.virtualisation) diskSize;

        postVM = ''
           mkdir -p $out/nix-support
           echo "file ${cfg.format} $diskImage" >> $out/nix-support/hydra-build-products

          ${pkgs.jq}/bin/jq -n \
            --arg system_version ${lib.escapeShellArg config.system.nixos.version} \
            --arg system ${lib.escapeShellArg pkgs.stdenv.hostPlatform.system} \
            --arg logical_bytes "$(${pkgs.qemu_kvm}/bin/qemu-img info --output json "$diskImage" | ${pkgs.jq}/bin/jq '."virtual-size"')" \
            --arg boot_mode "${amiBootMode}" \
            --arg file "$diskImage" \
             '{}
             | .label = $system_version
             | .boot_mode = $boot_mode
             | .system = $system
             | .logical_bytes = $logical_bytes
             | .file = $file
             | .disks.root.logical_bytes = $logical_bytes
             | .disks.root.file = $file
             ' > $out/nix-support/image-info.json
        '';
      };
    in
    if config.ec2.zfs.enable then zfsBuilder else extBuilder;

  meta.maintainers = with lib.maintainers; [ arianvp ];
}
