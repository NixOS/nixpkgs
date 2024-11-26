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
      postVM = ''
        ${pkgs.vmTools.qemu}/bin/qemu-img convert -f raw -o subformat=fixed,force_size -O vpc $diskImage $out/${config.image.fileName}
        rm $diskImage
      '';
      configFile = ./azure-config-user.nix;
      format = "raw";

      bootSize = "${toString cfg.bootSize}M";
      partitionTableType = if cfg.vmGeneration == "v2" then "efi" else "legacy";

      inherit (cfg) contents;
      inherit (config.virtualisation) diskSize;
      inherit config lib pkgs;
    };
  };
}
