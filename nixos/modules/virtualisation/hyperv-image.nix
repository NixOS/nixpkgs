{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.hyperv;

in
{
  options = {
    hyperv = {
      baseImageSize = mkOption {
        type = with types; either (enum [ "auto" ]) int;
        default = "auto";
        example = 2048;
        description = ''
          The size of the hyper-v base image in MiB.
        '';
      };
      vmDerivationName = mkOption {
        type = types.str;
        default = "nixos-hyperv-${config.system.nixos.label}-${pkgs.stdenv.hostPlatform.system}";
        description = ''
          The name of the derivation for the hyper-v appliance.
        '';
      };
      vmFileName = mkOption {
        type = types.str;
        default = "nixos-${config.system.nixos.label}-${pkgs.stdenv.hostPlatform.system}.vhdx";
        description = ''
          The file name of the hyper-v appliance.
        '';
      };
    };
  };

  config = {
    system.build.hypervImage = import ../../lib/make-disk-image.nix {
      name = cfg.vmDerivationName;
      postVM = ''
        ${pkgs.vmTools.qemu}/bin/qemu-img convert -f raw -o subformat=dynamic -O vhdx $diskImage $out/${cfg.vmFileName}
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

    virtualisation.hypervGuest.enable = true;
  };
}
