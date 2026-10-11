{
  config,
  lib,
  pkgs,
  ...
}:
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

      perUser = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Create per-user directories in {file}`/tmp/user/<uid>` and set
          {env}`TMPDIR` env variable.

          Many programs use {env}`TMPDIR` for storing temporary files. Not all
          of them are good at securing the permissions of those files.
          libpam-tmpdir sets {env}`TMPDIR` for PAM sessions and sets the
          permissions quite tight. This helps system security by having an
          extra layer of security, making such symlink attacks and other
          {file}`/tmp` based attacks harder or impossible.

          ::: {.note}
          Creation of per-user directory is tied to setting {env}`TMPDIR`. If
          {option}`security.pam.services.<name>.setEnvironment` is disabled for
          all PAM services in a login chain, directory won't be created.
          :::
        '';
      };
    };
  };

  config = {
    assertions = [
      {
        assertion = cfg.perUser -> config.security.enableWrappers;
        message = "Per-user tmp directories module requires security wrappers";
      }
      {
        assertion = cfg.perUser -> config.security.pam.enable;
        message = "Per-user tmp directories module requires PAM";
      }
    ];

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
          "huge=${cfg.tmpfsHugeMemoryPages}"
        ];
      }
    ];

    systemd.tmpfiles.rules = lib.optional cfg.cleanOnBoot "D! /tmp 1777 root root";

    security.wrappers.pam-tmpdir-helper = lib.mkIf cfg.perUser {
      owner = "root";
      group = "root";
      setuid = true;
      source = "${pkgs.pam_tmpdir}/libexec/pam-tmpdir/pam-tmpdir-helper";
    };
  };
}
