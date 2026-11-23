{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) literalExpression types;
  zfsRemoved = ''
    The ZFS Amazon image was removed. On an instance built from it, replace
    `ec2.zfs.enable = true;` with:

      fileSystems."/boot" = { device = "/dev/disk/by-label/ESP"; fsType = "vfat"; };
      services.zfs.expandOnBoot = "all";
      boot.zfs.devNodes = "/dev/";
  '';
in
{
  imports = [
    (lib.mkRemovedOptionModule [ "ec2" "zfs" "enable" ] zfsRemoved)
    (lib.mkRemovedOptionModule [ "ec2" "zfs" "datasets" ] zfsRemoved)
  ];

  options = {
    ec2 = {
      efi = lib.mkOption {
        default = pkgs.stdenv.hostPlatform.isAarch64;
        defaultText = literalExpression "pkgs.stdenv.hostPlatform.isAarch64";
        internal = true;
        description = ''
          Whether the EC2 instance is using EFI.
        '';
      };
      bootMode = lib.mkOption {
        type = types.enum [
          "legacy-bios"
          "uefi"
          "uefi-preferred"
        ];
        default = if config.ec2.efi then "uefi" else "legacy-bios";
        defaultText = literalExpression ''if config.ec2.efi then "uefi" else "legacy-bios"'';
        description = ''
          The boot mode the instance uses on EC2. `uefi-preferred` installs the
          boot loader for both UEFI and legacy BIOS, so the instance boots on
          every instance type.
        '';
      };
      hvm = lib.mkOption {
        description = "Unused legacy option. While support for non-hvm has been dropped, we keep this option around so that NixOps remains compatible with a somewhat recent `nixpkgs` and machines with an old `stateVersion`.";
        internal = true;
        default = true;
        readOnly = true;
      };
    };
  };
}
