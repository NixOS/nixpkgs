{
  config,
  pkgs,
  lib,
  ...
}:
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

in
{
  imports = [
    ../image/file-options.nix
    (lib.mkRenamedOptionModuleWith {
      sinceRelease = 2505;
      from = [
        "virtualisation"
        "vmware"
        "vmFileName"
      ];
      to = [
        "image"
        "fileName"
      ];
    })

  ];

  options = {
    vmware = {
      baseImageSize = lib.mkOption {
        type = with lib.types; either (enum [ "auto" ]) int;
        default = "auto";
        example = 2048;
        description = ''
          The size of the VMWare base image in MiB.
        '';
      };
      vmDerivationName = lib.mkOption {
        type = lib.types.str;
        default = "nixos-vmware-${config.system.nixos.label}-${pkgs.stdenv.hostPlatform.system}";
        description = ''
          The name of the derivation for the VMWare appliance.
        '';
      };
      vmSubformat = lib.mkOption {
        type = lib.types.enum subformats;
        default = "monolithicSparse";
        description = "Specifies which VMDK subformat to use.";
      };
      vmCompat6 = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Create a VMDK version 6 image (instead of version 4).";
      };
    };
  };

  config = {
    system.nixos.tags = [ "vmware" ];
    image.extension = "vmdk";
    system.build.image = config.system.build.vmwareImage;
    system.build.vmwareImage = import ../../lib/make-disk-image.nix {
      name = cfg.vmDerivationName;
      baseName = config.image.baseName;
      postVM = ''
        ${pkgs.vmTools.qemu}/bin/qemu-img convert -f raw -o compat6=${boolToStr cfg.vmCompat6},subformat=${cfg.vmSubformat} -O vmdk $diskImage $out/${config.image.fileName}
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
      device = "nodev";
      efiSupport = true;
      efiInstallAsRemovable = true;
    };

    virtualisation.vmware.guest.enable = true;
  };
}
