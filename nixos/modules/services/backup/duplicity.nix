{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.duplicity;

  stateDirectory = "/var/lib/duplicity";

  localTarget =
    if lib.hasPrefix "file://" cfg.targetUrl then lib.removePrefix "file://" cfg.targetUrl else null;

in
{
  options.services.duplicity = {
    enable = lib.mkEnableOption "backups with duplicity";

    root = lib.mkOption {
      type = lib.types.path;
      default = "/";
      description = ''
        Root directory to backup.
      '';
    };

    include = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "/home" ];
      description = ''
        List of paths to include into the backups. See the FILE SELECTION
        section in {manpage}`duplicity(1)` for details on the syntax.
      '';
    };

    exclude = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        List of paths to exclude from backups. See the FILE SELECTION section in
        {manpage}`duplicity(1)` for details on the syntax.
      '';
    };

    includeFileList = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = /path/to/fileList.txt;
      description = ''
        File containing newline-separated list of paths to include into the
        backups. See the FILE SELECTION section in {manpage}`duplicity(1)` for
        details on the syntax.
      '';
    };

    excludeFileList = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = /path/to/fileList.txt;
      description = ''
        File containing newline-separated list of paths to exclude into the
        backups. See the FILE SELECTION section in {manpage}`duplicity(1)` for
        details on the syntax.
      '';
    };

    targetUrl = lib.mkOption {
      type = lib.types.str;
      example = "s3://host:port/prefix";
      description = ''
        Target url to backup to. See the URL FORMAT section in
        {manpage}`duplicity(1)` for supported urls.
      '';
    };

    secretFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Path of a file containing secrets (gpg passphrase, access key...) in
        the format of EnvironmentFile as described by
        {manpage}`systemd.exec(5)`. For example:
        ```
        PASSPHRASE=«...»
        AWS_ACCESS_KEY_ID=«...»
        AWS_SECRET_ACCESS_KEY=«...»
        ```
      '';
    };

    frequency = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = "daily";
      description = ''
        Run duplicity with the given frequency (see
        {manpage}`systemd.time(7)` for the format).
        If null, do not run automatically.
      '';
    };

    extraFlags = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "--backend-retry-delay"
        "100"
      ];
      description = ''
        Extra command-line flags passed to duplicity. See
        {manpage}`duplicity(1)`.
      '';
    };

    fullIfOlderThan = lib.mkOption {
      type = lib.types.str;
      default = "never";
      example = "1M";
      description = ''
        If `"never"` (the default) always do incremental
        backups (the first backup will be a full backup, of course).  If
        `"always"` always do full backups.  Otherwise, this
        must be a string representing a duration. Full backups will be made
        when the latest full backup is older than this duration. If this is not
        the case, an incremental backup is performed.
      '';
    };

    cleanup = {
      maxAge = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "6M";
        description = ''
          If non-null, delete all backup sets older than the given time.  Old backup sets
          will not be deleted if backup sets newer than time depend on them.
        '';
      };
      maxFull = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
        example = 2;
        description = ''
          If non-null, delete all backups sets that are older than the count:th last full
          backup (in other words, keep the last count full backups and
          associated incremental sets).
        '';
      };
      maxIncr = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
        example = 1;
        description = ''
          If non-null, delete incremental sets of all backups sets that are
          older than the count:th last full backup (in other words, keep only
          old full backups and not their increments).
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd = {
      services.duplicity =
        {
          description = "backup files with duplicity";

          environment.HOME = stateDirectory;

          script =
            let
              target = lib.escapeShellArg cfg.targetUrl;
              extra = lib.escapeShellArgs (
                [
                  "--archive-dir"
                  stateDirectory
                ]
                ++ cfg.extraFlags
              );
              dup = "${pkgs.duplicity}/bin/duplicity";
            in
            ''
              set -x
              ${dup} cleanup ${target} --force ${extra}
              ${lib.optionalString (
                cfg.cleanup.maxAge != null
              ) "${dup} remove-older-than ${lib.escapeShellArg cfg.cleanup.maxAge} ${target} --force ${extra}"}
              ${lib.optionalString (
                cfg.cleanup.maxFull != null
              ) "${dup} remove-all-but-n-full ${toString cfg.cleanup.maxFull} ${target} --force ${extra}"}
              ${lib.optionalString (
                cfg.cleanup.maxIncr != null
              ) "${dup} remove-all-inc-of-but-n-full ${toString cfg.cleanup.maxIncr} ${target} --force ${extra}"}
              exec ${dup} ${if cfg.fullIfOlderThan == "always" then "full" else "incr"} ${
                lib.escapeShellArgs (
                  [
                    cfg.root
                    cfg.targetUrl
                  ]
                  ++ lib.optionals (cfg.includeFileList != null) [
                    "--include-filelist"
                    cfg.includeFileList
                  ]
                  ++ lib.optionals (cfg.excludeFileList != null) [
                    "--exclude-filelist"
                    cfg.excludeFileList
                  ]
                  ++ lib.concatMap (p: [
                    "--include"
                    p
                  ]) cfg.include
                  ++ lib.concatMap (p: [
                    "--exclude"
                    p
                  ]) cfg.exclude
                  ++ (lib.optionals (cfg.fullIfOlderThan != "never" && cfg.fullIfOlderThan != "always") [
                    "--full-if-older-than"
                    cfg.fullIfOlderThan
                  ])
                )
              } ${extra}
            '';
          serviceConfig =
            {
              PrivateTmp = true;
              ProtectSystem = "strict";
              ProtectHome = "read-only";
              StateDirectory = baseNameOf stateDirectory;
            }
            // lib.optionalAttrs (localTarget != null) {
              ReadWritePaths = localTarget;
            }
            // lib.optionalAttrs (cfg.secretFile != null) {
              EnvironmentFile = cfg.secretFile;
            };
        }
        // lib.optionalAttrs (cfg.frequency != null) {
          startAt = cfg.frequency;
        };

      tmpfiles.rules = lib.optional (localTarget != null) "d ${localTarget} 0700 root root -";
    };

    assertions = lib.singleton {
      # Duplicity will fail if the last file selection option is an include. It
      # is not always possible to detect but this simple case can be caught.
      assertion = cfg.include != [ ] -> cfg.exclude != [ ] || cfg.extraFlags != [ ];
      message = ''
        Duplicity will fail if you only specify included paths ("Because the
        default is to include all files, the expression is redundant. Exiting
        because this probably isn't what you meant.")
      '';
    };
  };
}
