{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.virtualisation.azureImage;
in
{
  imports = [
    ./azure.nix
    ./azure-init.nix
  ];

  options = {
    virtualisation.azureImage.diskSize = mkOption {
      type = with types; either (enum [ "auto" ]) int;
      default = "auto";
      example = 2048;
      description = lib.mdDoc ''
        Size of disk image. Unit is MB.
      '';
    };
  };
  config = {
    system.build.azureImage = import ../../lib/make-disk-image.nix {
      name = "azure-image";

      # VHD images on Azure [1] must have virtual size aligned to 1MiB.
      # We check image alignment and convert raw image to fixed size vhd image
      postVM = ''
        size=$(${pkgs.vmTools.qemu}/bin/qemu-img info -f raw --output json $diskImage | ${pkgs.jq}/bin/jq '."virtual-size"')

        echo "Check that image size is aligned to 1MiB (1024x1024)"
        if (( size % (1024*1024) )); then
          echo "ERROR: Image size have to be aligned to 1 MiB (1024x1024 bytes)"
          exit 1
        fi

        echo "Convert raw image to vhd image"
        ${pkgs.vmTools.qemu}/bin/qemu-img convert -f raw -o subformat=fixed,force_size -O vpc $diskImage $out/disk.vhd
        rm $diskImage
      '';
      configFile = builtins.toFile "azure-config-user.nix" ''
        { modulesPath, ... }: {
          # Base configuration for nixos on azure vm
          imports = [ "''${modulesPath}/virtualisation/azure.nix" ];
        }
      '';
      format = "raw";
      inherit (cfg) diskSize;
      inherit config lib pkgs;
    };
  };
}

/*
REFERENCES
  1. https://docs.microsoft.com/en-us/azure/virtual-machines/linux/create-upload-generic#resizing-vhds
*/