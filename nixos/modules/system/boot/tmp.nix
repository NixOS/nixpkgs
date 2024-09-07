{ config, lib, ... }:

with lib;

let
  cfg = config.boot.tmp;
in
{
  imports = [
    (mkRenamedOptionModule [ "boot" "cleanTmpDir" ] [ "boot" "tmp" "cleanOnBoot" ])
    (mkRenamedOptionModule [ "boot" "tmpOnTmpfs" ] [ "boot" "tmp" "useTmpfs" ])
    (mkRenamedOptionModule [ "boot" "tmpOnTmpfsSize" ] [ "boot" "tmp" "tmpfsSize" ])
  ];

  options = {
    boot.tmp = {
      cleanOnBoot = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to delete all files in {file}`/tmp` during boot.
        '';
      };

      tmpfsSize = mkOption {
        type = types.oneOf [ types.str types.types.ints.positive ];
        default = "50%";
        description = ''
          Size of tmpfs in percentage.
          Percentage is defined by systemd.
        '';
      };

      useTmpfs = mkOption {
        type = types.bool;
        default = false;
        description = ''
           Whether to mount a tmpfs on {file}`/tmp` during boot.

           ::: {.note}
           Large Nix builds can fail if the mounted tmpfs is not large enough.
           In such a case either increase the tmpfsSize or disable this option.
           :::
        '';
      };
    };
  };

  config = {
    # When changing remember to update /tmp mount in virtualisation/qemu-vm.nix
    systemd.mounts = mkIf cfg.useTmpfs [
      {
        what = "tmpfs";
        where = "/tmp";
        type = "tmpfs";
        mountConfig.Options = concatStringsSep "," [
          "mode=1777"
          "strictatime"
          "rw"
          "nosuid"
          "nodev"
          "size=${toString cfg.tmpfsSize}"
        ];
      }
    ];

    systemd.tmpfiles.rules = optional cfg.cleanOnBoot "D! /tmp 1777 root root";
  };
}
