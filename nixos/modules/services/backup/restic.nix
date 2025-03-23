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
            passwordFile = lib.mkOption {
              type = lib.types.str;
              description = ''
                Read the repository password from a file.
              '';
              example = "/etc/nixos/restic-password";
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
              description = ''
                Options to pass to rclone to control its behavior.
                See <https://rclone.org/docs/#options> for
                available options. When specifying option names, strip the
                leading `--`. To set a flag such as
                `--drive-use-trash`, which does not take a value,
                set the value to the Boolean `true`.
              '';
              example = {
                bwlimit = "10M";
                drive-use-trash = "true";
              };
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
              description = ''
                Configuration for the rclone remote being used for backup.
                See the remote's specific options under rclone's docs at
                <https://rclone.org/docs/>. When specifying
                option names, use the "config" name specified in the docs.
                For example, to set `--b2-hard-delete` for a B2
                remote, use `hard_delete = true` in the
                attribute set.
                Warning: Secrets set in here will be world-readable in the Nix
                store! Consider using the `rcloneConfigFile`
                option instead to specify secret values separately. Note that
                options set here will override those set in the config file.
              '';
              example = {
                type = "b2";
                account = "xxx";
                key = "xxx";
                hard_delete = true;
              };
            };

            rcloneConfigFile = lib.mkOption {
              type = with lib.types; nullOr path;
              default = null;
              description = ''
                Path to the file containing rclone configuration. This file
                must contain configuration for the remote specified in this backup
                set and also must be readable by root. Options set in
                `rcloneConfig` will override those set in this
                file.
              '';
            };

            inhibitsSleep = lib.mkOption {
              default = false;
              type = lib.types.bool;
              example = true;
              description = ''
                Prevents the system from sleeping while backing up.
              '';
            };

            repository = lib.mkOption {
              type = with lib.types; nullOr str;
              default = null;
              description = ''
                repository to backup to.
              '';
              example = "sftp:backup@192.168.1.100:/backups/${name}";
            };

            repositoryFile = lib.mkOption {
              type = with lib.types; nullOr path;
              default = null;
              description = ''
                Path to the file containing the repository location to backup to.
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
              default = (builtins.length config.services.restic.backups.${name}.checkOpts > 0);
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

            progressFps = lib.mkOption {
              type = with lib.types; nullOr numbers.nonnegative;
              default = null;
              description = ''
                Controls the frequency of progress reporting.
              '';
              example = 0.1;
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
        repository = "/mnt/backup-hdd";
        passwordFile = "/etc/nixos/secrets/restic-password";
        initialize = true;
      };
      remotebackup = {
        paths = [ "/home" ];
        repository = "sftp:backup@host:/backups/home";
        passwordFile = "/etc/nixos/secrets/restic-password";
        extraOptions = [
          "sftp.command='ssh backup@host -i /etc/nixos/secrets/backup-private-key -s sftp'"
        ];
        timerConfig = {
          OnCalendar = "00:05";
          RandomizedDelaySec = "5h";
        };
      };
    };
  };

  config = {
    assertions = lib.mapAttrsToList (n: v: {
      assertion = (v.repository == null) != (v.repositoryFile == null);
      message = "services.restic.backups.${n}: exactly one of repository or repositoryFile should be set";
    }) config.services.restic.backups;
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
        doBackup = (backup.dynamicFilesFrom != null) || (backup.paths != null && backup.paths != [ ]);
        pruneCmd = lib.optionals (builtins.length backup.pruneOpts > 0) [
          (resticCmd + " unlock")
          (resticCmd + " forget --prune " + (lib.concatStringsSep " " backup.pruneOpts))
        ];
        checkCmd = lib.optionals backup.runCheck [
          (resticCmd + " check " + (lib.concatStringsSep " " backup.checkOpts))
        ];
        # Helper functions for rclone remotes
        rcloneRemoteName = builtins.elemAt (lib.splitString ":" backup.repository) 1;
        rcloneAttrToOpt = v: "RCLONE_" + lib.toUpper (builtins.replaceStrings [ "-" ] [ "_" ] v);
        rcloneAttrToConf = v: "RCLONE_CONFIG_" + lib.toUpper (rcloneRemoteName + "_" + v);
        toRcloneVal = v: if lib.isBool v then lib.boolToString v else v;
      in
      lib.nameValuePair "restic-backups-${name}" (
        {
          environment =
            {
              # not %C, because that wouldn't work in the wrapper script
              RESTIC_CACHE_DIR = "/var/cache/restic-backups-${name}";
              RESTIC_PASSWORD_FILE = backup.passwordFile;
              RESTIC_REPOSITORY = backup.repository;
              RESTIC_REPOSITORY_FILE = backup.repositoryFile;
            }
            // lib.optionalAttrs (backup.rcloneOptions != null) (
              lib.mapAttrs' (
                name: value: lib.nameValuePair (rcloneAttrToOpt name) (toRcloneVal value)
              ) backup.rcloneOptions
            )
            // lib.optionalAttrs (backup.rcloneConfigFile != null) {
              RCLONE_CONFIG = backup.rcloneConfigFile;
            }
            // lib.optionalAttrs (backup.rcloneConfig != null) (
              lib.mapAttrs' (
                name: value: lib.nameValuePair (rcloneAttrToConf name) (toRcloneVal value)
              ) backup.rcloneConfig
            )
            // lib.optionalAttrs (backup.progressFps != null) {
              RESTIC_PROGRESS_FPS = toString backup.progressFps;
            };
          path = [ config.programs.ssh.package ];
          restartIfChanged = false;
          wants = [ "network-online.target" ];
          after = [ "network-online.target" ];
          serviceConfig =
            {
              Type = "oneshot";
              ExecStart =
                (lib.optionals doBackup [
                  "${resticCmd} backup ${
                    lib.concatStringsSep " " (backup.extraBackupArgs ++ excludeFlags)
                  } --files-from=${filesFromTmpFile}"
                ])
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
            ${lib.optionalString (backup.initialize) ''
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
            ${lib.optionalString doBackup ''
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
        timerConfig = backup.timerConfig;
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
          (lib.mapAttrsToList (n: v: "${n}=${v}"))
          (lib.concatStringsSep "\n")
        ]}
        PATH=${config.systemd.services."restic-backups-${name}".environment.PATH}:$PATH

        exec ${resticCmd} "$@"
      ''
    ) (lib.filterAttrs (_: v: v.createWrapper) config.services.restic.backups);
  };
}
