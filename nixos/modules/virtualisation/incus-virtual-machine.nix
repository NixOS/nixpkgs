{
  config,
  lib,
  pkgs,
  ...
}:

let
  serialDevice = if pkgs.stdenv.hostPlatform.isx86 then "ttyS0" else "ttyAMA0";

  efiArch = pkgs.stdenv.hostPlatform.efiArch;
in
{
  meta = {
    teams = [ lib.teams.lxc ];
  };

  imports = [
    ../image/repart.nix
    ./lxc-instance-common.nix

    ../profiles/qemu-guest.nix
  ];

  config = {
    system.build.qemuImage = import ../../lib/make-disk-image.nix {
      inherit pkgs lib config;

      partitionTableType = "efi";
      format = "qcow2-compressed";
      copyChannel = config.system.installer.channel.enable;
    };

    system.build.repartImage = config.image.repart.image.overrideAttrs (previousAttrs: {
      nativeBuildInputs = previousAttrs.nativeBuildInputs ++ [ pkgs.qemu-utils ];

      postBuild = ''
        qemu-img convert -f raw -O qcow2 -c ${config.image.baseName}.raw ${config.image.baseName}.qcow2
        rm ${config.image.baseName}.raw
      '';

      # expose a hydra build product so lxc-ci can download it
      postInstall = ''
        mkdir $out/nix-support
        echo "file qcow2-image $out/${config.image.baseName}.qcow2" > $out/nix-support/hydra-build-products
      '';
    });

    image.repart = {
      name = "nixos";
      version = null;
      sectorSize = 512;
      compression.enable = false;
      mkfsOptions.ext4 = [
        "-i"
        "8192"
      ];
      partitions = {
        esp = {
          contents = {
            "/EFI/BOOT/BOOT${lib.toUpper efiArch}.EFI".source =
              "${config.systemd.package}/lib/systemd/boot/efi/systemd-boot${efiArch}.efi";
            "/EFI/Linux/${config.system.boot.loader.ukiFile}".source =
              "${config.system.build.uki}/${config.system.boot.loader.ukiFile}";
          };

          repartConfig = {
            Type = "esp";
            Format = "vfat";
            Label = "ESP";
            # support 10 kernels, assuming 50MB on x86 and 100MB on aarch64
            SizeMinBytes = if pkgs.stdenv.hostPlatform.isx86 then "512M" else "1G";
          };
        };
        root = {
          storePaths = [ config.system.build.toplevel ];
          repartConfig = {
            Type = "root";
            Format = "ext4";
            Label = "nixos";
            Minimize = "guess";
            PaddingMinBytes = "512M";
          };
        };
      };
    };

    fileSystems = {
      "/" = {
        device = "/dev/disk/by-label/nixos";
        autoResize = true;
        fsType = "ext4";
      };
      "/boot" = {
        device = "/dev/disk/by-label/ESP";
        fsType = "vfat";
      };
    };

    boot.growPartition = true;
    boot.loader.systemd-boot.enable = true;

    # image building needs to know what device to install bootloader on
    boot.loader.grub.device = "/dev/vda";

    boot.kernelParams = [
      "console=tty1"
      "console=${serialDevice}"
    ];

    # CPU hotplug
    services.udev.extraRules = ''
      SUBSYSTEM=="cpu", CONST{arch}=="x86-64", TEST=="online", ATTR{online}=="0", ATTR{online}="1"
    '';

    virtualisation.incus.agent.enable = lib.mkDefault true;
  };
}
