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
  imports = [ ./azure-common.nix ];

  options.virtualisation.azureImage = {
    diskSize = mkOption {
      type = with types; either (enum [ "auto" ]) int;
      default = "auto";
      example = 2048;
      description = ''
        Size of disk image. Unit is MB.
      '';
    };

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
    system.build.azureImage = import ../../lib/make-disk-image.nix {
      name = "azure-image";
      postVM = ''
        ${pkgs.vmTools.qemu}/bin/qemu-img convert -f raw -o subformat=fixed,force_size -O vpc $diskImage $out/disk.vhd
        rm $diskImage
      '';
      configFile = ./azure-config-user.nix;
      format = "raw";

      bootSize = "${toString cfg.bootSize}M";
      partitionTableType = if cfg.vmGeneration == "v2" then "efi" else "legacy";

      inherit (cfg) diskSize contents;
      inherit config lib pkgs;
    };
  };
}
