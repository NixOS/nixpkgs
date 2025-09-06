{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let
  # Type for a valid systemd unit option. Needed for correctly passing "timerConfig" to "systemd.timers"
  inherit (utils.systemdUtils.unitOptions) unitOption;
  passwordFileBase = lib.mkOption {
    type = lib.types.str;
    default = "";
    description = ''
      Read the repository password from a file.
    '';
    example = "/etc/nixos/restic-password";
  };
  repositoryBase = lib.mkOption {
    type = with lib.types; nullOr str;
    default = null;
    description = ''
      repository to backup to.
    '';
    example = "sftp:backup@192.168.1.100:/backups/my-backup";
  };
  repositoryFileBase = lib.mkOption {
    type = with lib.types; nullOr path;
    default = null;
    description = ''
      Path to the file containing the repository location to backup to.
    '';
  };
  progressFpsBase = lib.mkOption {
    type = with lib.types; nullOr numbers.nonnegative;
    default = null;
    description = ''
      Controls the frequency of progress reporting.
    '';
    example = 0.1;
  };
in
{
  options.services.restic.backups = lib.mkOption {
    description = ''
      Periodic backups to create with Restic.
    '';
    type = lib.types.attrsOf (
      lib.types.submodule (
        { name, ... }:
        {
          options = {
            passwordFile = passwordFileBase // {
              internal = true;
            };
            repository = repositoryBase // {
              internal = true;
            };
            repositoryFile = repositoryFileBase // {
              internal = true;
            };

            environmentFile = lib.mkOption {
              type = with lib.types; nullOr str;
              default = null;
              description = ''
                file containing the credentials to access the repository, in the
                format of an EnvironmentFile as described by {manpage}`systemd.exec(5)`
              '';
            };

            rcloneOptions = lib.mkOption {
              type =
                with lib.types;
                nullOr (
                  attrsOf (oneOf [
                    str
                    bool
                  ])
                );
              default = null;
              internal = true;
            };

            rcloneConfig = lib.mkOption {
              type =
                with lib.types;
                nullOr (
                  attrsOf (oneOf [
                    str
                    bool
                  ])
                );
              default = null;
              internal = true;
            };

            rcloneConfigFile = lib.mkOption {
              type = with lib.types; nullOr path;
              default = null;
              internal = true;
            };

            inhibitsSleep = lib.mkOption {
              default = false;
              type = lib.types.bool;
              example = true;
              description = ''
                Prevents the system from sleeping while backing up.
              '';
            };

            paths = lib.mkOption {
              # This is nullable for legacy reasons only. We should consider making it a pure listOf
              # after some time has passed since this comment was added.
              type = lib.types.nullOr (lib.types.listOf lib.types.str);
              default = [ ];
              description = ''
                Which paths to backup, in addition to ones specified via
                `dynamicFilesFrom`.  If null or an empty array and
                `dynamicFilesFrom` is also null, no backup command will be run.
                 This can be used to create a prune-only job.
              '';
              example = [
                "/var/lib/postgresql"
                "/home/user/backup"
              ];
            };

            command = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ ];
              description = ''
                Command to pass to --stdin-from-command. If null or an empty array, and `paths`/`dynamicFilesFrom`
                are also null, no backup command will be run.
              '';
              example = [
                "sudo"
                "-u"
                "postgres"
                "pg_dumpall"
              ];
            };

            exclude = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ ];
              description = ''
                Patterns to exclude when backing up. See
                https://restic.readthedocs.io/en/latest/040_backup.html#excluding-files for
                details on syntax.
              '';
              example = [
                "/var/cache"
                "/home/*/.cache"
                ".git"
              ];
            };

            timerConfig = lib.mkOption {
              type = lib.types.nullOr (lib.types.attrsOf unitOption);
              default = {
                OnCalendar = "daily";
                Persistent = true;
              };
              description = ''
                When to run the backup. See {manpage}`systemd.timer(5)` for
                details. If null no timer is created and the backup will only
                run when explicitly started.
              '';
              example = {
                OnCalendar = "00:05";
                RandomizedDelaySec = "5h";
                Persistent = true;
              };
            };

            user = lib.mkOption {
              type = lib.types.str;
              default = "root";
              description = ''
                As which user the backup should run.
              '';
              example = "postgresql";
            };

            extraBackupArgs = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ ];
              description = ''
                Extra arguments passed to restic backup.
              '';
              example = [
                "--cleanup-cache"
                "--exclude-file=/etc/nixos/restic-ignore"
              ];
            };

            extraOptions = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ ];
              description = ''
                Extra extended options to be passed to the restic --option flag.
              '';
              example = [
                "sftp.command='ssh backup@192.168.1.100 -i /home/user/.ssh/id_rsa -s sftp'"
              ];
            };

            initialize = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Create the repository if it doesn't exist.
              '';
            };

            pruneOpts = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ ];
              description = ''
                A list of options (--keep-\* et al.) for 'restic forget
                --prune', to automatically prune old snapshots.  The
                'forget' command is run *after* the 'backup' command, so
                keep that in mind when constructing the --keep-\* options.
              '';
              example = [
                "--keep-daily 7"
                "--keep-weekly 5"
                "--keep-monthly 12"
                "--keep-yearly 75"
              ];
            };

            runCheck = lib.mkOption {
              type = lib.types.bool;
              default = builtins.length config.services.restic.backups.${name}.checkOpts > 0;
              defaultText = lib.literalExpression ''builtins.length config.services.backups.${name}.checkOpts > 0'';
              description = "Whether to run the `check` command with the provided `checkOpts` options.";
              example = true;
            };

            checkOpts = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ ];
              description = ''
                A list of options for 'restic check'.
              '';
              example = [
                "--with-cache"
              ];
            };

            dynamicFilesFrom = lib.mkOption {
              type = with lib.types; nullOr str;
              default = null;
              description = ''
                A script that produces a list of files to back up.  The
                results of this command are given to the '--files-from'
                option. The result is merged with paths specified via `paths`.
              '';
              example = "find /home/matt/git -type d -name .git";
            };

            backupPrepareCommand = lib.mkOption {
              type = with lib.types; nullOr str;
              default = null;
              description = ''
                A script that must run before starting the backup process.
              '';
            };

            backupCleanupCommand = lib.mkOption {
              type = with lib.types; nullOr str;
              default = null;
              description = ''
                A script that must run after finishing the backup process.
              '';
            };

            package = lib.mkPackageOption pkgs "restic" { };

            createWrapper = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = ''
                Whether to generate and add a script to the system path, that has the same environment variables set
                as the systemd service. This can be used to e.g. mount snapshots or perform other opterations, without
                having to manually specify most options.
              '';
            };

            progressFps = progressFpsBase // {
              internal = true;
            };

            settings = lib.mkOption {
              description = ''
                Restic settings. They are provided as environment variables. They should be provided in upper snake
                case (e.g. {env}`RESTIC_PASSWORD_FILE`). See
                <https://restic.readthedocs.io/en/stable/040_backup.html#environment-variables> for supported options.

                This option can also take rclone settings, also as environment variables. They should be provided in
                upper snake case (e.g. {env}`RCLONE_SKIP_LINKS`). See <https://rclone.org/docs/#options> for supported
                options. Restic will automatically supply the remote type and name for you. To provide secrets to the
                backend, it's recommended to create rclone config file yourself, and use {env}`RCLONE_CONFIG` option
                to point to it. It is also recommended to use a separate config file if you care about
                case-sensitivity for your remote name.
              '';
              type = lib.types.submodule {
                freeformType = with lib.types; attrsOf str;

                options = {
                  RESTIC_PASSWORD_FILE = passwordFileBase;
                  RESTIC_REPOSITORY = repositoryBase;
                  RESTIC_REPOSITORY_FILE = repositoryFileBase;
                  RESTIC_PROGRESS_FPS = progressFpsBase;

                  # not %C, because that wouldn't work in the wrapper script
                  RESTIC_CACHE_DIR = lib.mkOption {
                    type = with lib.types; nullOr path;
                    default = "/var/cache/restic-backups-${name}";
                    description = ''
                      Location of the cache directory.
                    '';
                  };

                  RCLONE_CONFIG = lib.mkOption {
                    type =
                      with lib.types;
                      nullOr (oneOf [
                        str
                        path
                      ]);
                    default = null;
                    description = ''
                      Location of the rclone configuration file.
                    '';
                  };
                };
              };
              example = lib.literalExpression ''
                RESTIC_PASSWORD_FILE = "/secrets/password-file";
                RESTIC_REPOSITORY = "s3:s3.us-east-1.amazonaws.com/bucket_name/restic";
                AWS_ACCESS_KEY_ID = "XXXX";
                AWS_SECRET_ACCESS_KEY = "YYYY";
                RCLONE_BWLIMIT = "10M";
                RCLONE_HARD_DELETE = "true";
                # RCLONE_S3_PROVIDER = "AWS";
                # RCLONE_CONFIG_MYS3_ACCESS_KEY_ID = "XXXX";
                # RCLONE_CONFIG = "/my/config/file";
              '';
            };
          };
        }
      )
    );
    default = { };
    example = {
      localbackup = {
        paths = [ "/home" ];
        exclude = [ "/home/*/.cache" ];
        initialize = true;
        settings = {
          RESTIC_REPOSITORY = "/mnt/backup-hdd";
          RESTIC_PASSWORD_FILE = "/etc/nixos/secrets/restic-password";
        };
      };
      remotebackup = {
        paths = [ "/home" ];
        settings = {
          RESTIC_REPOSITORY = "sftp:backup@host:/backups/home";
          RESTIC_PASSWORD_FILE = "/etc/nixos/secrets/restic-password";
        };
        extraOptions = [
          "sftp.command='ssh backup@host -i /etc/nixos/secrets/backup-private-key -s sftp'"
        ];
        timerConfig = {
          OnCalendar = "00:05";
          RandomizedDelaySec = "5h";
        };
      };
      commandbackup = {
        command = [
          "\${lib.getExe pkgs.sudo}"
          "-u postgres"
          "\${pkgs.postgresql}/bin/pg_dumpall"
        ];
        extraBackupArgs = [ "--tag database" ];
        repository = "s3:example.com/mybucket";
        passwordFile = "/etc/nixos/secrets/restic-password";
        environmentFile = "/etc/nixos/secrets/restic-environment";
        pruneOpts = [
          "--keep-daily 14"
          "--keep-weekly 4"
          "--keep-monthly 2"
          "--group-by tags"
        ];
      };
    };
  };

  config = {
    assertions = lib.flatten (
      lib.mapAttrsToList (n: v: [
        {
          assertion = (v.settings.RESTIC_REPOSITORY == null) != (v.settings.RESTIC_REPOSITORY_FILE == null);
          message = "services.restic.backups.${n}.settings: exactly one of RESTIC_REPOSITORY or RESTIC_REPOSITORY_FILE should be set";
        }
        {
          assertion =
            let
              fileBackup = (v.paths != null && v.paths != [ ]) || v.dynamicFilesFrom != null;
              commandBackup = v.command != [ ];
            in
            !(fileBackup && commandBackup);
          message = "services.restic.backups.${n}: cannot do both a command backup and a file backup at the same time.";
        }
        # Start block of RFC42 changes. Added after 25.05 release. Ideally this would be `mkRenamedOptionModule`, but this doesn't work
        # with `attrsOf` submodules; see #96006. For this reason, we also have to keep the old options around (`internal` flag is set to
        # have accurate documentation).
        {
          assertion = (v.passwordFile == "");
          message = "services.restic.backups.${n}.passwordFile: option was renamed to services.restic.backups.${n}.settings.RESTIC_PASSWORD_FILE";
        }
        {
          assertion = (v.repository == null);
          message = "services.restic.backups.${n}.repository: option was renamed to services.restic.backups.${n}.settings.RESTIC_REPOSITORY";
        }
        {
          assertion = (v.repositoryFile == null);
          message = "services.restic.backups.${n}.repositoryFile: option was renamed to services.restic.backups.${n}.settings.RESTIC_REPOSITORY_FILE";
        }
        {
          assertion = (v.rcloneOptions == null);
          message = "services.restic.backups.${n}.rcloneOptions: option was removed. Use services.restic.backups.${n}.settings instead. `rcloneOptions` can be converted to `settings` by replacing `-` with `_`, making all letters uppercase and prefixing them with `RCLONE_`. For example, `rcloneOptions.drive-use-trash = \"true\"` becomes `settings.RCLONE_DRIVE_USE_TRASH = \"true\"`.";
        }
        {
          assertion = (v.rcloneConfig == null);
          message = "services.restic.backups.${n}.rcloneConfig: option was removed. Use services.restic.backups.${n}.settings instead. `rcloneConfig` can be converted to `settings` by making all letters uppercase and prefixing them with `RCLONE_`. For example, `rcloneOptions.hard_delete = true` becomes `settings.RCLONE_HARD_DELETE = \"true\"`.";
        }
        {
          assertion = (v.rcloneConfigFile == null);
          message = "services.restic.backups.${n}.rcloneConfigFile: option was renamed to services.restic.backups.${n}.settings.RCLONE_CONFIG";
        }
        {
          assertion = (v.progressFps == null);
          message = "services.restic.backups.${n}.progressFps: option was renamed to services.restic.backups.${n}.settings.RESTIC_PROGRESS_FPS";
        }
      ]) config.services.restic.backups
    );
    # End block of RFC42 changes.

    systemd.services = lib.mapAttrs' (
      name: backup:
      let
        extraOptions = lib.concatMapStrings (arg: " -o ${arg}") backup.extraOptions;
        inhibitCmd = lib.concatStringsSep " " [
          "${pkgs.systemd}/bin/systemd-inhibit"
          "--mode='block'"
          "--who='restic'"
          "--what='sleep'"
          "--why=${lib.escapeShellArg "Scheduled backup ${name}"} "
        ];
        resticCmd = "${lib.optionalString backup.inhibitsSleep inhibitCmd}${lib.getExe backup.package}${extraOptions}";
        excludeFlags = lib.optional (
          backup.exclude != [ ]
        ) "--exclude-file=${pkgs.writeText "exclude-patterns" (lib.concatStringsSep "\n" backup.exclude)}";
        filesFromTmpFile = "/run/restic-backups-${name}/includes";
        fileBackup = (backup.dynamicFilesFrom != null) || (backup.paths != null && backup.paths != [ ]);
        commandBackup = backup.command != [ ];
        doBackup = fileBackup || commandBackup;
        pruneCmd = lib.optionals (builtins.length backup.pruneOpts > 0) [
          (resticCmd + " unlock")
          (resticCmd + " forget --prune " + (lib.concatStringsSep " " backup.pruneOpts))
        ];
        checkCmd = lib.optionals backup.runCheck [
          (resticCmd + " check " + (lib.concatStringsSep " " backup.checkOpts))
        ];
      in
      lib.nameValuePair "restic-backups-${name}" (
        {
          environment = backup.settings;
          path = [ config.programs.ssh.package ];
          restartIfChanged = false;
          wants = [ "network-online.target" ];
          after = [ "network-online.target" ];
          serviceConfig = {
            Type = "oneshot";
            ExecStart =
              lib.optionals doBackup [
                "${resticCmd} backup ${
                  lib.concatStringsSep " " (
                    backup.extraBackupArgs
                    ++ lib.optionals fileBackup (excludeFlags ++ [ "--files-from=${filesFromTmpFile}" ])
                    ++ lib.optionals commandBackup ([ "--stdin-from-command=true --" ] ++ backup.command)
                  )
                }"
              ]
              ++ pruneCmd
              ++ checkCmd;
            User = backup.user;
            RuntimeDirectory = "restic-backups-${name}";
            CacheDirectory = "restic-backups-${name}";
            CacheDirectoryMode = "0700";
            PrivateTmp = true;
          }
          // lib.optionalAttrs (backup.environmentFile != null) {
            EnvironmentFile = backup.environmentFile;
          };
        }
        // lib.optionalAttrs (backup.initialize || doBackup || backup.backupPrepareCommand != null) {
          preStart = ''
            ${lib.optionalString (backup.backupPrepareCommand != null) ''
              ${pkgs.writeScript "backupPrepareCommand" backup.backupPrepareCommand}
            ''}
            ${lib.optionalString backup.initialize ''
              ${resticCmd} cat config > /dev/null || ${resticCmd} init
            ''}
            ${lib.optionalString (backup.paths != null && backup.paths != [ ]) ''
              cat ${pkgs.writeText "staticPaths" (lib.concatLines backup.paths)} >> ${filesFromTmpFile}
            ''}
            ${lib.optionalString (backup.dynamicFilesFrom != null) ''
              ${pkgs.writeScript "dynamicFilesFromScript" backup.dynamicFilesFrom} >> ${filesFromTmpFile}
            ''}
          '';
        }
        // lib.optionalAttrs (doBackup || backup.backupCleanupCommand != null) {
          postStop = ''
            ${lib.optionalString (backup.backupCleanupCommand != null) ''
              ${pkgs.writeScript "backupCleanupCommand" backup.backupCleanupCommand}
            ''}
            ${lib.optionalString fileBackup ''
              rm ${filesFromTmpFile}
            ''}
          '';
        }
      )
    ) config.services.restic.backups;
    systemd.timers = lib.mapAttrs' (
      name: backup:
      lib.nameValuePair "restic-backups-${name}" {
        wantedBy = [ "timers.target" ];
        inherit (backup) timerConfig;
      }
    ) (lib.filterAttrs (_: backup: backup.timerConfig != null) config.services.restic.backups);

    # generate wrapper scripts, as described in the createWrapper option
    environment.systemPackages = lib.mapAttrsToList (
      name: backup:
      let
        extraOptions = lib.concatMapStrings (arg: " -o ${arg}") backup.extraOptions;
        resticCmd = "${lib.getExe backup.package}${extraOptions}";
      in
      pkgs.writeShellScriptBin "restic-${name}" ''
        set -a  # automatically export variables
        ${lib.optionalString (backup.environmentFile != null) "source ${backup.environmentFile}"}
        # set same environment variables as the systemd service
        ${lib.pipe config.systemd.services."restic-backups-${name}".environment [
          (lib.filterAttrs (n: v: v != null && n != "PATH"))
          (lib.mapAttrs (_: v: "${v}"))
          lib.toShellVars
        ]}
        PATH=${config.systemd.services."restic-backups-${name}".environment.PATH}:$PATH

        exec ${resticCmd} "$@"
      ''
    ) (lib.filterAttrs (_: v: v.createWrapper) config.services.restic.backups);
  };
}
