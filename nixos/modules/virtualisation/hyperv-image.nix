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

  imports = [
    ./disk-size-option.nix
    ../image/file-options.nix
    (lib.mkRenamedOptionModuleWith {
      sinceRelease = 2411;
      from = [
        "hyperv"
        "baseImageSize"
      ];
      to = [
        "virtualisation"
        "diskSize"
      ];
    })
    (lib.mkRenamedOptionModuleWith {
      sinceRelease = 2505;
      from = [
        "virtualisation"
        "hyperv"
        "vmFileName"
      ];
      to = [
        "image"
        "fileName"
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
    };
  };

  config = {
    # Use a priority just below mkOptionDefault (1500) instead of lib.mkDefault
    # to avoid breaking existing configs using that.
    virtualisation.diskSize = lib.mkOverride 1490 (4 * 1024);

    system.nixos.tags = [ "hyperv" ];
    image.extension = "vhdx";
    system.build.image = config.system.build.hypervImage;
    system.build.hypervImage = import ../../lib/make-disk-image.nix {
      name = cfg.vmDerivationName;
      baseName = config.image.baseName;
      postVM = ''
        ${pkgs.vmTools.qemu}/bin/qemu-img convert -f raw -o subformat=dynamic -O vhdx $diskImage $out/${config.image.fileName}
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
