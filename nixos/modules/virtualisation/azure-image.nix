{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.virtualisation.azureImage;
in
{
  imports = [ ./azure-common.nix ];

  options = {
    virtualisation.azureImage.diskSize = mkOption {
      type = with types; either (enum [ "auto" ]) int;
      default = "auto";
      example = 2048;
      description = lib.mdDoc ''
        Size of disk image. Unit is MB.
      '';
    };
    virtualisation.azureImage.contents = mkOption {
      type = with types; listOf attrs;
      default = [ ];
      description = lib.mdDoc ''
        Extra contents to add to the image.
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
      inherit (cfg) diskSize contents;
      inherit config lib pkgs;
    };

  };
}
