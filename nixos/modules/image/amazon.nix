{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.image.amazon;
in
{
  imports = [ ./repart.nix ];
  options = {
    image.amazon = {
      bootMode = lib.mkOption {
        type = lib.types.enum [
          "uefi-preferred"
          "uefi"
        ];
        default = if pkgs.hostPlatform.isAarch64 then "uefi" else "uefi-preferred";
      };
    };

  };
  config = {
    boot.loader.grub = {
      enable = true;
      efiSupport = true;
      efiInstallAsRemovable = true;
      device = if cfg.bootMode == "uefi-preferred" then "/dev/vda" else "nodev";
    };
    fileSystems."/" = {
      fsType = "ext4";
      device = "/dev/disk/by-partlabel/root";
    };
    # Grows on first boot
    systemd.repart.partitions = {
      "10-root".repartConfig.Type = "root";
    };
    systemd.services.nix-store-load-db = {
      wantedBy = [ "multi-user.target" ];
      before = [ "nix-daemon.socket" ];
      unitConfig.ConditionFirstBoot = true;
      serviceConfig.ExecStart = "nix-store --load-db < /nix/store/.registration";
    };
    system.image.id = config.system.name;
    system.image.version = config.system.nixos.version;
    image.repart = {
      name = config.system.name;
      partitions = {
        "00-esp" = {
          repartConfig = {
            Type = "esp";
            Format = "vfat";
            SizeMinBytes = "1G";
            SizeMaxBytes = "1G";
          };
        };
        "05-bios" = lib.mkIf (config.image.amazon.bootMode == "uefi-preferred") {
          repartConfig = {
            Type = "21686148-6449-6e6f-744e-656564454649";
            SizeMinBytes = "1M";
            SizeMaxBytes = "1M";
          };
        };
        "10-root" = {
          storePaths = [ config.system.build.toplevel ];
          contents = {
            # This is needed for nixos-enter to work
            "/etc/NIXOS".source = pkgs.writeText "NIXOS" "";
            "/nix/var/nix/profiles".source = pkgs.runCommand "profiles" { } ''
              mkdir -p $out
              ln -s ${config.system.build.toplevel} $out/system-1-link
              ln -s /nix/var/nix/profiles/system-1-link $out/system
            '';
          };
          repartConfig = {
            Type = "root";
            Label = "root";
            Format = config.fileSystems."/".fsType;
            Minimize = "guess";
          };
        };
      };
    };

    system.build.amazonImage = pkgs.vmTools.runInLinuxVM (
      pkgs.runCommand config.system.build.image.name
        {
          preVM = ''
            cp ${config.system.build.image}/${config.image.repart.imageFile} ${config.image.repart.imageFile}
            chmod u+w ${config.image.repart.imageFile}
            diskImage=${config.image.repart.imageFile}
          '';
          postVM = ''
            mkdir -p $out
            cp $diskImage $out/${config.image.repart.imageFile}
          '';
          buildInputs = with pkgs; [
            nixos-enter
            util-linux
          ];
        }
        ''
          rootDisk=/dev/vda3
          mkdir /dev/block
          ln -s /dev/vda1 /dev/block/254:1
          mountPoint=/mnt
          mkdir $mountPoint
          mount $rootDisk $mountPoint
          mkdir -p $mountPoint/boot
          mount /dev/vda1 $mountPoint/boot

          HOME=$TMPDIR NIXOS_INSTALL_BOOTLOADER=1 nixos-enter --root $mountPoint -- ${config.system.build.toplevel}/bin/switch-to-configuration boot
        ''
    );
  };

}
