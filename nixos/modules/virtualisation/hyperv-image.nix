{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.hyperv;
  virtualisationOptions = import ./virtualisation-options.nix;

in
{

  imports = [
    virtualisationOptions.diskSize
    (lib.mkRenamedOptionModuleWith {
      sinceRelease = 2411;
      from = [
        "virtualisation"
        "hyperv"
        "baseImageSize"
      ];
      to = [
        "virtualisation"
        "diskSize"
      ];
    })
  ];

  options = {
    hyperv = {
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
    virtualisation.diskSize = lib.mkDefault (4 * 1024);

    system.build.hypervImage = import ../../lib/make-disk-image.nix {
      name = cfg.vmDerivationName;
      postVM = ''
        ${pkgs.vmTools.qemu}/bin/qemu-img convert -f raw -o subformat=dynamic -O vhdx $diskImage $out/${cfg.vmFileName}
        rm $diskImage
      '';
      format = "raw";
      inherit (config.virtualisation) diskSize;
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
