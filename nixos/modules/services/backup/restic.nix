{ config, lib, pkgs, utils, ... }:

with lib;

let
  # Type for a valid systemd unit option. Needed for correctly passing "timerConfig" to "systemd.timers"
  inherit (utils.systemdUtils.unitOptions) unitOption;
in
{
  options.services.restic.backups = mkOption {
    description = lib.mdDoc ''
      Periodic backups to create with Restic.
    '';
    type = types.attrsOf (types.submodule ({ config, name, ... }: {
      options = {
        passwordFile = mkOption {
          type = types.str;
          description = lib.mdDoc ''
            Read the repository password from a file.
          '';
          example = "/etc/nixos/restic-password";
        };

        environmentFile = mkOption {
          type = with types; nullOr str;
          # added on 2021-08-28, s3CredentialsFile should
          # be removed in the future (+ remember the warning)
          default = config.s3CredentialsFile;
          description = lib.mdDoc ''
            file containing the credentials to access the repository, in the
            format of an EnvironmentFile as described by systemd.exec(5)
          '';
        };

        s3CredentialsFile = mkOption {
          type = with types; nullOr str;
          default = null;
          description = lib.mdDoc ''
            file containing the AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY
            for an S3-hosted repository, in the format of an EnvironmentFile
            as described by systemd.exec(5)
          '';
        };

        rcloneOptions = mkOption {
          type = with types; nullOr (attrsOf (oneOf [ str bool ]));
          default = null;
          description = lib.mdDoc ''
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

        rcloneConfig = mkOption {
          type = with types; nullOr (attrsOf (oneOf [ str bool ]));
          default = null;
          description = lib.mdDoc ''
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

        rcloneConfigFile = mkOption {
          type = with types; nullOr path;
          default = null;
          description = lib.mdDoc ''
            Path to the file containing rclone configuration. This file
            must contain configuration for the remote specified in this backup
            set and also must be readable by root. Options set in
            `rcloneConfig` will override those set in this
            file.
          '';
        };

        repository = mkOption {
          type = with types; nullOr str;
          default = null;
          description = lib.mdDoc ''
            repository to backup to.
          '';
          example = "sftp:backup@192.168.1.100:/backups/${name}";
        };

        repositoryFile = mkOption {
          type = with types; nullOr path;
          default = null;
          description = lib.mdDoc ''
            Path to the file containing the repository location to backup to.
          '';
        };

        paths = mkOption {
          type = types.nullOr (types.listOf types.str);
          default = null;
          description = lib.mdDoc ''
            Which paths to backup.  If null or an empty array, no
            backup command will be run.  This can be used to create a
            prune-only job.
          '';
          example = [
            "/var/lib/postgresql"
            "/home/user/backup"
          ];
        };

        exclude = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = lib.mdDoc ''
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

        timerConfig = mkOption {
          type = types.attrsOf unitOption;
          default = {
            OnCalendar = "daily";
            Persistent = true;
          };
          description = lib.mdDoc ''
            When to run the backup. See {manpage}`systemd.timer(5)` for details.
          '';
          example = {
            OnCalendar = "00:05";
            RandomizedDelaySec = "5h";
            Persistent = true;
          };
        };

        user = mkOption {
          type = types.str;
          default = "root";
          description = lib.mdDoc ''
            As which user the backup should run.
          '';
          example = "postgresql";
        };

        extraBackupArgs = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = lib.mdDoc ''
            Extra arguments passed to restic backup.
          '';
          example = [
            "--exclude-file=/etc/nixos/restic-ignore"
          ];
        };

        extraOptions = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = lib.mdDoc ''
            Extra extended options to be passed to the restic --option flag.
          '';
          example = [
            "sftp.command='ssh backup@192.168.1.100 -i /home/user/.ssh/id_rsa -s sftp'"
          ];
        };

        initialize = mkOption {
          type = types.bool;
          default = false;
          description = lib.mdDoc ''
            Create the repository if it doesn't exist.
          '';
        };

        pruneOpts = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = lib.mdDoc ''
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

        checkOpts = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = lib.mdDoc ''
            A list of options for 'restic check', which is run after
            pruning.
          '';
          example = [
            "--with-cache"
          ];
        };

        dynamicFilesFrom = mkOption {
          type = with types; nullOr str;
          default = null;
          description = lib.mdDoc ''
            A script that produces a list of files to back up.  The
            results of this command are given to the '--files-from'
            option.
          '';
          example = "find /home/matt/git -type d -name .git";
        };

        backupPrepareCommand = mkOption {
          type = with types; nullOr str;
          default = null;
          description = lib.mdDoc ''
            A script that must run before starting the backup process.
          '';
        };

        backupCleanupCommand = mkOption {
          type = with types; nullOr str;
          default = null;
          description = lib.mdDoc ''
            A script that must run after finishing the backup process.
          '';
        };

        package = mkOption {
          type = types.package;
          default = pkgs.restic;
          defaultText = literalExpression "pkgs.restic";
          description = lib.mdDoc ''
            Restic package to use.
          '';
        };
      };
    }));
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
    warnings = mapAttrsToList (n: v: "services.restic.backups.${n}.s3CredentialsFile is deprecated, please use services.restic.backups.${n}.environmentFile instead.") (filterAttrs (n: v: v.s3CredentialsFile != null) config.services.restic.backups);
    assertions = mapAttrsToList (n: v: {
      assertion = (v.repository == null) != (v.repositoryFile == null);
      message = "services.restic.backups.${n}: exactly one of repository or repositoryFile should be set";
    }) config.services.restic.backups;
    systemd.services =
      mapAttrs'
        (name: backup:
          let
            extraOptions = concatMapStrings (arg: " -o ${arg}") backup.extraOptions;
            resticCmd = "${backup.package}/bin/restic${extraOptions}";
            excludeFlags = optional (backup.exclude != []) "--exclude-file=${pkgs.writeText "exclude-patterns" (concatStringsSep "\n" backup.exclude)}";
            filesFromTmpFile = "/run/restic-backups-${name}/includes";
            backupPaths =
              if (backup.dynamicFilesFrom == null)
              then optionalString (backup.paths != null) (concatStringsSep " " backup.paths)
              else "--files-from ${filesFromTmpFile}";
            pruneCmd = optionals (builtins.length backup.pruneOpts > 0) [
              (resticCmd + " forget --prune " + (concatStringsSep " " backup.pruneOpts))
              (resticCmd + " check " + (concatStringsSep " " backup.checkOpts))
            ];
            # Helper functions for rclone remotes
            rcloneRemoteName = builtins.elemAt (splitString ":" backup.repository) 1;
            rcloneAttrToOpt = v: "RCLONE_" + toUpper (builtins.replaceStrings [ "-" ] [ "_" ] v);
            rcloneAttrToConf = v: "RCLONE_CONFIG_" + toUpper (rcloneRemoteName + "_" + v);
            toRcloneVal = v: if lib.isBool v then lib.boolToString v else v;
          in
          nameValuePair "restic-backups-${name}" ({
            environment = {
              RESTIC_CACHE_DIR = "%C/restic-backups-${name}";
              RESTIC_PASSWORD_FILE = backup.passwordFile;
              RESTIC_REPOSITORY = backup.repository;
              RESTIC_REPOSITORY_FILE = backup.repositoryFile;
            } // optionalAttrs (backup.rcloneOptions != null) (mapAttrs'
              (name: value:
                nameValuePair (rcloneAttrToOpt name) (toRcloneVal value)
              )
              backup.rcloneOptions) // optionalAttrs (backup.rcloneConfigFile != null) {
              RCLONE_CONFIG = backup.rcloneConfigFile;
            } // optionalAttrs (backup.rcloneConfig != null) (mapAttrs'
              (name: value:
                nameValuePair (rcloneAttrToConf name) (toRcloneVal value)
              )
              backup.rcloneConfig);
            path = [ pkgs.openssh ];
            restartIfChanged = false;
            wants = [ "network-online.target" ];
            after = [ "network-online.target" ];
            serviceConfig = {
              Type = "oneshot";
              ExecStart = (optionals (backupPaths != "") [ "${resticCmd} backup ${concatStringsSep " " (backup.extraBackupArgs ++ excludeFlags)} ${backupPaths}" ])
                ++ pruneCmd;
              User = backup.user;
              RuntimeDirectory = "restic-backups-${name}";
              CacheDirectory = "restic-backups-${name}";
              CacheDirectoryMode = "0700";
              PrivateTmp = true;
            } // optionalAttrs (backup.environmentFile != null) {
              EnvironmentFile = backup.environmentFile;
            };
          } // optionalAttrs (backup.initialize || backup.dynamicFilesFrom != null || backup.backupPrepareCommand != null) {
            preStart = ''
              ${optionalString (backup.backupPrepareCommand != null) ''
                ${pkgs.writeScript "backupPrepareCommand" backup.backupPrepareCommand}
              ''}
              ${optionalString (backup.initialize) ''
                ${resticCmd} snapshots || ${resticCmd} init
              ''}
              ${optionalString (backup.dynamicFilesFrom != null) ''
                ${pkgs.writeScript "dynamicFilesFromScript" backup.dynamicFilesFrom} > ${filesFromTmpFile}
              ''}
            '';
          } // optionalAttrs (backup.dynamicFilesFrom != null || backup.backupCleanupCommand != null) {
            postStop = ''
              ${optionalString (backup.backupCleanupCommand != null) ''
                ${pkgs.writeScript "backupCleanupCommand" backup.backupCleanupCommand}
              ''}
              ${optionalString (backup.dynamicFilesFrom != null) ''
                rm ${filesFromTmpFile}
              ''}
            '';
          })
        )
        config.services.restic.backups;
    systemd.timers =
      mapAttrs'
        (name: backup: nameValuePair "restic-backups-${name}" {
          wantedBy = [ "timers.target" ];
          timerConfig = backup.timerConfig;
        })
        config.services.restic.backups;
  };
}
