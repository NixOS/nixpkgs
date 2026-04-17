# Tests in: nixos/tests/ec2-image.nix
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
    ;
  inherit (lib.options) literalExpression;
  cfg = config.amazonImage;
  amiBootMode = if config.ec2.efi then "uefi" else "legacy-bios";
  amiArch =
    {
      "aarch64-linux" = "arm64";
      "x86_64-linux" = "x86_64";
    }
    .${pkgs.stdenv.hostPlatform.system}
      or (throw "Unsupported system for AMI architecture: ${pkgs.stdenv.hostPlatform.system}");
  registerImageJSON = builtins.toJSON cfg.registerImage;
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

    registerImage = {
      Architecture = mkOption {
        type = types.enum [
          "x86_64"
          "arm64"
        ];
        default = amiArch;
        description = "The architecture of the AMI.";
      };

      BootMode = mkOption {
        type = types.enum [
          "legacy-bios"
          "uefi"
        ];
        default = amiBootMode;
        description = "The boot mode for the AMI. Must match the builder's boot mode derived from `ec2.efi`.";
      };

      RootDeviceName = mkOption {
        type = types.str;
        default = "/dev/xvda";
        description = "The root device name.";
      };

      VirtualizationType = mkOption {
        type = types.enum [ "hvm" ];
        default = "hvm";
        readOnly = true;
        description = "The virtualization type. Fixed to HVM; non-HVM support has been dropped.";
      };

      EnaSupport = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to enable Enhanced Networking (ENA).";
      };

      ImdsSupport = mkOption {
        type = types.enum [ "v2.0" ];
        default = "v2.0";
        description = "The IMDS version to require.";
      };

      SriovNetSupport = mkOption {
        type = types.enum [ "simple" ];
        default = "simple";
        description = "The SR-IOV network support setting.";
      };

      TpmSupport = mkOption {
        type = types.nullOr (types.enum [ "v2.0" ]);
        default = null;
        description = "TPM support version, or `null` to omit.";
      };

      BlockDeviceMappings = mkOption {
        type = types.listOf (
          types.submodule {
            options = {
              DeviceName = mkOption {
                type = types.str;
                default = "/dev/xvda";
                description = "The device name for the block device mapping.";
              };
              Ebs = mkOption {
                type = types.submodule {
                  options = {
                    VolumeType = mkOption {
                      type = types.str;
                      default = "gp3";
                      description = "The EBS volume type (e.g. `gp3`, `gp2`, `io1`, `io2`, `standard`).";
                    };
                  };
                };
                default = { };
                description = "The EBS block device parameters.";
              };
            };
          }
        );
        default = [ { } ];
        description = "Block device mappings for the AMI.";
      };
    };
  };

  # Use a priority just below mkOptionDefault (1500) instead of lib.mkDefault
  # to avoid breaking existing configs using that.
  config.virtualisation.diskSize = lib.mkOverride 1490 (4 * 1024);
  config.virtualisation.diskSizeAutoSupported = !config.ec2.zfs.enable;

  config.system.nixos.tags = [ "amazon" ];
  config.system.build.image = config.system.build.amazonImage;
  config.image.extension = if cfg.format == "vpc" then "vhd" else cfg.format;

  config.assertions = [
    {
      assertion =
        let
          mappings = cfg.registerImage.BlockDeviceMappings;
        in
        builtins.length mappings == 1
        && (builtins.head mappings).DeviceName == cfg.registerImage.RootDeviceName;
      message = "amazonImage.registerImage must contain exactly one BlockDeviceMapping and its DeviceName must match RootDeviceName.";
    }
    {
      assertion = cfg.registerImage.TpmSupport == null || cfg.registerImage.BootMode == "uefi";
      message = "amazonImage.registerImage.TpmSupport requires BootMode to be \"uefi\".";
    }
    {
      assertion = cfg.registerImage.BootMode == amiBootMode;
      message = "amazonImage.registerImage.BootMode (${cfg.registerImage.BootMode}) does not match the builder's boot mode (${amiBootMode}). Set ec2.efi to change it.";
    }
    {
      assertion = cfg.registerImage.Architecture == amiArch;
      message = "amazonImage.registerImage.Architecture (${cfg.registerImage.Architecture}) does not match the builder's architecture (${amiArch}).";
    }
  ];

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
            --argjson register_image ${lib.escapeShellArg registerImageJSON} \
           '{}
             | .label = $system_version
             | .boot_mode = $boot_mode
             | .system = $system
             | .disks.boot.logical_bytes = $boot_logical_bytes
             | .disks.boot.file = $boot
             | .disks.root.logical_bytes = $root_logical_bytes
             | .disks.root.file = $root
             | .registerImage = $register_image
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
            --argjson register_image ${lib.escapeShellArg registerImageJSON} \
             '{}
             | .label = $system_version
             | .boot_mode = $boot_mode
             | .system = $system
             | .logical_bytes = $logical_bytes
             | .file = $file
             | .disks.root.logical_bytes = $logical_bytes
             | .disks.root.file = $file
             | .registerImage = $register_image
             ' > $out/nix-support/image-info.json
        '';
      };
    in
    if config.ec2.zfs.enable then zfsBuilder else extBuilder;

  meta.maintainers = with lib.maintainers; [ arianvp ];
}
