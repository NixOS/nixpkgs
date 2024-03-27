{ config, lib, pkgs, utils, ... }:

with lib;

let
  # Type for a valid systemd unit option. Needed for correctly passing "timerConfig" to "systemd.timers"
  inherit (utils.systemdUtils.unitOptions) unitOption;
in
{
  options.services.rustic.backups = mkOption {
    description = lib.mdDoc ''
      Periodic backups to create with Rustic.
    '';
    type = types.attrsOf (types.submodule ({ config, name, ... }: {
      options = {
        passwordFile = mkOption {
          type = types.str;
          description = lib.mdDoc ''
            Read the repository password from a file.
          '';
          example = "/etc/nixos/rustic-password";
        };

        environmentFile = mkOption {
          type = with types; nullOr str;
          default = null;
          description = lib.mdDoc ''
            file containing the credentials to access the repository, in the
            format of an EnvironmentFile as described by systemd.exec(5)
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
          # This is nullable for legacy reasons only. We should consider making it a pure listOf
          # after some time has passed since this comment was added.
          type = types.nullOr (types.listOf types.str);
          default = [ ];
          description = lib.mdDoc ''
            Which paths to backup.
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
            https://rustic.cli.rs/docs/commands/backup/excluding_files.html       for details on syntax.
            The glob patterns have to be negated with ! for exclusion.
          '';
          example = [
            "!/var/cache"
            "!/home/*/.cache"
            "!.git"
          ];
        };

        timerConfig = mkOption {
          type = types.nullOr (types.attrsOf unitOption);
          default = {
            OnCalendar = "daily";
            Persistent = true;
          };
          description = lib.mdDoc ''
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
            Extra arguments passed to rustic backup.
          '';
          example = [
            "--glob-file=/etc/nixos/rustic-ignore"
          ];
        };

        extraOptions = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = lib.mdDoc ''
            Extra extended options to be passed to the rustic --option flag.
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
            A list of options (--keep-\* et al.) for 'rustic forget
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
            A list of options for 'rustic check', which is run after
            pruning.
          '';
          example = [
            "--no-cache"
          ];
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

        package = mkPackageOption pkgs "rustic-rs" { };

        createWrapper = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = ''
            Whether to generate and add a script to the system path, that has the same environment variables set
            as the systemd service. This can be used to e.g. mount snapshots or perform other opterations, without
            having to manually specify most options.
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
        passwordFile = "/etc/nixos/secrets/rustic-password";
        initialize = true;
      };
      remotebackup = {
        paths = [ "/home" ];
        repository = "sftp:backup@host:/backups/home";
        passwordFile = "/etc/nixos/secrets/rustic-password";
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
    assertions = mapAttrsToList (n: v: {
      assertion = (v.repository == null) != (v.repositoryFile == null);
      message = "services.rustic.backups.${n}: exactly one of repository or repositoryFile should be set";
    }) config.services.rustic.backups;
    systemd.services =
      mapAttrs'
        (name: backup:
          let
            extraOptions = concatMapStrings (arg: " -o ${arg}") backup.extraOptions;
            rusticCmd = "${backup.package}/bin/rustic${extraOptions}";
            excludeFlags = optional (backup.exclude != []) "--glob-file=${pkgs.writeText "exclude-patterns" (concatStringsSep "\n" backup.exclude)}";
            doBackup = backup.paths != [];
            pruneCmd = optionals (builtins.length backup.pruneOpts > 0) [
              (rusticCmd + " forget " + (concatStringsSep " " backup.pruneOpts))
              (rusticCmd + " check " + (concatStringsSep " " backup.checkOpts))
            ];
            # Helper functions for rclone remotes
            rcloneRemoteName = builtins.elemAt (splitString ":" backup.repository) 1;
            rcloneAttrToOpt = v: "RCLONE_" + toUpper (builtins.replaceStrings [ "-" ] [ "_" ] v);
            rcloneAttrToConf = v: "RCLONE_CONFIG_" + toUpper (rcloneRemoteName + "_" + v);
            toRcloneVal = v: if lib.isBool v then lib.boolToString v else v;
          in
          nameValuePair "rustic-backups-${name}" ({
            environment = {
              # not %C, because that wouldn't work in the wrapper script
              RUSTIC_CACHE_DIR = "/var/cache/rustic-backups-${name}";
              RUSTIC_PASSWORD_FILE = backup.passwordFile;
              RUSTIC_REPOSITORY = backup.repository;
              RUSTIC_REPOSITORY_FILE = backup.repositoryFile;
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
            path = [ config.programs.ssh.package ];
            restartIfChanged = false;
            wants = [ "network-online.target" ];
            after = [ "network-online.target" ];
            serviceConfig = {
              Type = "oneshot";
              ExecStart = [ "" ] ++ (optionals doBackup [ "${rusticCmd} backup ${concatStringsSep " " backup.paths} ${concatStringsSep " " (backup.extraBackupArgs ++ excludeFlags)}" ])
                ++ pruneCmd;
              User = backup.user;
              RuntimeDirectory = "rustic-backups-${name}";
              CacheDirectory = "rustic-backups-${name}";
              CacheDirectoryMode = "0700";
              PrivateTmp = true;
            } // optionalAttrs (backup.environmentFile != null) {
              EnvironmentFile = backup.environmentFile;
            };
          } // optionalAttrs (backup.initialize || doBackup || backup.backupPrepareCommand != null) {
            preStart = ''
              ${optionalString (backup.backupPrepareCommand != null) ''
                ${pkgs.writeScript "backupPrepareCommand" backup.backupPrepareCommand}
              ''}
              ${optionalString (backup.initialize) ''
                ${rusticCmd} snapshots || ${rusticCmd} init
              ''}
            '';
          } // optionalAttrs (doBackup || backup.backupCleanupCommand != null) {
            postStop = ''
              ${optionalString (backup.backupCleanupCommand != null) ''
                ${pkgs.writeScript "backupCleanupCommand" backup.backupCleanupCommand}
              ''}
            '';
          })
        )
        config.services.rustic.backups;
    systemd.timers =
      mapAttrs'
        (name: backup: nameValuePair "rustic-backups-${name}" {
          wantedBy = [ "timers.target" ];
          timerConfig = backup.timerConfig;
        })
        (filterAttrs (_: backup: backup.timerConfig != null) config.services.rustic.backups);

    # generate wrapper scripts, as described in the createWrapper option
    environment.systemPackages = lib.mapAttrsToList (name: backup: let
      extraOptions = lib.concatMapStrings (arg: " -o ${arg}") backup.extraOptions;
      rusticCmd = "${backup.package}/bin/rustic${extraOptions}";
    in pkgs.writeShellScriptBin "rustic-${name}" ''
      set -a  # automatically export variables
      ${lib.optionalString (backup.environmentFile != null) "source ${backup.environmentFile}"}
      # set same environment variables as the systemd service
      ${lib.pipe config.systemd.services."rustic-backups-${name}".environment [
        (lib.filterAttrs (n: v: v != null && n != "PATH"))
        (lib.mapAttrsToList (n: v: "${n}=${v}"))
        (lib.concatStringsSep "\n")
      ]}
      PATH=${config.systemd.services."rustic-backups-${name}".environment.PATH}:$PATH

      exec ${rusticCmd} $@
    '') (lib.filterAttrs (_: v: v.createWrapper) config.services.rustic.backups);
  };
}
