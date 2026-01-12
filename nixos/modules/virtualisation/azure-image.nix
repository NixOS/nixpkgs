{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.virtualisation.azureImage;
in
{
  imports = [
    ./azure-common.nix
    ./disk-size-option.nix
    ../image/file-options.nix
    (lib.mkRenamedOptionModuleWith {
      sinceRelease = 2411;
      from = [
        "virtualisation"
        "azureImage"
        "diskSize"
      ];
      to = [
        "virtualisation"
        "diskSize"
      ];
    })
  ];

  options.virtualisation.azureImage = {
    bootSize = mkOption {
      type = types.int;
      default = 256;
      description = ''
        ESP partition size. Unit is MB.
        Only effective when vmGeneration is `v2`.
      '';
    };

    contents = mkOption {
      type = with types; listOf attrs;
      default = [ ];
      description = ''
        Extra contents to add to the image.
      '';
    };

    label = mkOption {
      type = types.str;
      default = "nixos";
      description = ''
        NixOS partition label.
      '';
    };

    vmGeneration = mkOption {
      type =
        with types;
        enum [
          "v1"
          "v2"
        ];
      default = "v1";
      description = ''
        VM Generation to use.
        For v2, secure boot needs to be turned off during creation.
      '';
    };
  };

  config = {
    image.extension = "vhd";
    system.nixos.tags = [ "azure" ];
    system.build.image = config.system.build.azureImage;
    system.build.azureImage = import ../../lib/make-disk-image.nix {
      name = "azure-image";
      inherit (config.image) baseName;

      # Azure expects vhd format with fixed size,
      # generating raw format and convert with subformat args afterwards
      format = "raw";
      postVM = ''
        ${pkgs.vmTools.qemu}/bin/qemu-img convert -f raw -o subformat=fixed,force_size -O vpc $diskImage $out/${config.image.fileName}
        rm $diskImage
      '';
      configFile = ./azure-config-user.nix;

      bootSize = "${toString cfg.bootSize}M";
      partitionTableType = if (cfg.vmGeneration == "v2") then "efi" else "legacy";

      inherit (cfg) contents label;
      inherit (config.virtualisation) diskSize;
      inherit config lib pkgs;
    };

    boot.growPartition = true;
    boot.loader.grub = rec {
      efiSupport = (cfg.vmGeneration == "v2");
      device = if efiSupport then "nodev" else "/dev/sda";
      efiInstallAsRemovable = efiSupport;
      # Force grub to run in text mode and output to console
      # by disabling font and splash image
      font = null;
      splashImage = null;
      # For Gen 1 VM, configurate grub output to serial_com0.
      # Not needed for Gen 2 VM wbere serial_com0 does not exist,
      # and outputting to console is enough to make Azure Serial Console working
      extraConfig = lib.mkIf (!efiSupport) ''
        serial --unit=0 --speed=115200 --word=8 --parity=no --stop=1
        terminal_input --append serial
        terminal_output --append serial
      '';
    };

    fileSystems = {
      "/" = {
        device = "/dev/disk/by-label/${cfg.label}";
        inherit (cfg) label;
        fsType = "ext4";
        autoResize = true;
      };

      "/boot" = lib.mkIf (cfg.vmGeneration == "v2") {
        device = "/dev/disk/by-label/ESP";
        fsType = "vfat";
      };
    };
  };
}
