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

      tmpfsHugeMemoryPages = lib.mkOption {
        type = lib.types.enum [
          "never"
          "always"
          "within_size"
          "advise"
        ];
        default = "never";
        example = "within_size";
        description = ''
          - `never`        - Do not allocate huge memory pages. This is the default.
          - `always`       - Attempt to allocate huge memory page every time a new page is needed.
          - `within_size`  - Only allocate huge memory pages if it will be fully within i_size. Also respect madvise(2) hints. Recommended.
          - `advise`       - Only allocate huge memory pages if requested with madvise(2).
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

      tmpfsOptions = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "nosuid"
          "nodev"
        ];
        example = [
          "nosuid"
          "nodev"
          "noexec"
        ];
        description = ''
          Extra options to use when mounting {file}`/tmp` as a tmpfs.
        '';
      };

      # These options are also shared with virtualisation/qemu-vm.nix
      tmpfsFinalOptions = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        readOnly = true;
        internal = true;
        description = ''
          Final list of options that will be used for the {file}`/tmp` tmpfs
          mount.
        '';
      };
    };
  };

  config = {
    boot.tmp.tmpfsFinalOptions = [
      "mode=1777"
      "strictatime"
      "rw"
      "size=${toString cfg.tmpfsSize}"
      "huge=${cfg.tmpfsHugeMemoryPages}"
    ]
    ++ cfg.tmpfsOptions;

    systemd.mounts = lib.mkIf cfg.useTmpfs [
      {
        what = "tmpfs";
        where = "/tmp";
        type = "tmpfs";
        mountConfig.Options = lib.concatStringsSep "," cfg.tmpfsFinalOptions;
      }
    ];

    systemd.tmpfiles.rules = lib.optional cfg.cleanOnBoot "D! /tmp 1777 root root";
  };
}
