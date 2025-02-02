{ config, lib, ... }:
let
  cfg = config.boot.tmp;
in
{
  imports = [
    (lib.mkRenamedOptionModule [ "boot" "cleanTmpDir" ] [ "boot" "tmp" "cleanOnBoot" ])
    (lib.mkRenamedOptionModule [ "boot" "tmpOnTmpfs" ] [ "boot" "tmp" "useTmpfs" ])
    (lib.mkRenamedOptionModule [ "boot" "tmpOnTmpfsSize" ] [ "boot" "tmp" "tmpfsSize" ])
  ];

  options = {
    boot.tmp = {
      cleanOnBoot = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to delete all files in {file}`/tmp` during boot.
        '';
      };

      tmpfsSize = lib.mkOption {
        type = lib.types.oneOf [
          lib.types.str
          lib.types.ints.positive
        ];
        default = "50%";
        description = ''
          Size of tmpfs in percentage.
          Percentage is defined by systemd.
        '';
      };

      useTmpfs = lib.mkOption {
        type = lib.types.bool;
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
    systemd.mounts = lib.mkIf cfg.useTmpfs [
      {
        what = "tmpfs";
        where = "/tmp";
        type = "tmpfs";
        mountConfig.Options = lib.concatStringsSep "," [
          "mode=1777"
          "strictatime"
          "rw"
          "nosuid"
          "nodev"
          "size=${toString cfg.tmpfsSize}"
        ];
      }
    ];

    systemd.tmpfiles.rules = lib.optional cfg.cleanOnBoot "D! /tmp 1777 root root";
  };
}
