{ config, pkgs, lib, ... }:

with lib;

let
  boolToStr = value: if value then "on" else "off";
  cfg = config.vmware;

  subformats = [
    "monolithicSparse"
    "monolithicFlat"
    "twoGbMaxExtentSparse"
    "twoGbMaxExtentFlat"
    "streamOptimized"
  ];

in {
  options = {
    vmware = {
      baseImageSize = mkOption {
        type = types.int;
        default = 2048;
        description = ''
          The size of the VMWare base image in MiB.
        '';
      };
      vmDerivationName = mkOption {
        type = types.str;
        default = "nixos-vmware-${config.system.nixos.label}-${pkgs.stdenv.hostPlatform.system}";
        description = ''
          The name of the derivation for the VMWare appliance.
        '';
      };
      vmFileName = mkOption {
        type = types.str;
        default = "nixos-${config.system.nixos.label}-${pkgs.stdenv.hostPlatform.system}.vmdk";
        description = ''
          The file name of the VMWare appliance.
        '';
      };
      vmSubformat = mkOption {
        type = types.enum subformats;
        default = "monolithicSparse";
        description = "Specifies which VMDK subformat to use.";
      };
      vmCompat6 = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = "Create a VMDK version 6 image (instead of version 4).";
      };
    };
  };

  config = {
    system.build.vmwareImage = import ../../lib/make-disk-image.nix {
      name = cfg.vmDerivationName;
      postVM = ''
        ${pkgs.vmTools.qemu}/bin/qemu-img convert -f raw -o compat6=${boolToStr cfg.vmCompat6},subformat=${cfg.vmSubformat} -O vmdk $diskImage $out/${cfg.vmFileName}
        rm $diskImage
      '';
      format = "raw";
      diskSize = cfg.baseImageSize;
      partitionTableType = "efi";
      inherit config lib pkgs;
    };

    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      autoResize = true;
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-label/ESP";
      fsType = "vfat";
    };

    boot.growPartition = true;

    boot.loader.grub = {
      version = 2;
      device = "nodev";
      efiSupport = true;
      efiInstallAsRemovable = true;
    };

    virtualisation.vmware.guest.enable = true;
  };
}
