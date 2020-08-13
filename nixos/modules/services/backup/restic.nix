{ config, lib, pkgs, ... }:

with lib;

let
  # Type for a valid systemd unit option. Needed for correctly passing "timerConfig" to "systemd.timers"
  unitOption = (import ../../system/boot/systemd-unit-options.nix { inherit config lib; }).unitOption;
in
{
  options.services.restic.backups = mkOption {
    description = ''
      Periodic backups to create with Restic.
    '';
    type = types.attrsOf (types.submodule ({ name, ... }: {
      options = {
        passwordFile = mkOption {
          type = types.str;
          description = ''
            Read the repository password from a file.
          '';
          example = "/etc/nixos/restic-password";
        };

        s3CredentialsFile = mkOption {
          type = with types; nullOr str;
          default = null;
          description = ''
            file containing the AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY
            for an S3-hosted repository, in the format of an EnvironmentFile
            as described by systemd.exec(5)
          '';
        };

        rcloneOptions = mkOption {
          type = with types; nullOr (attrsOf (oneOf [ str bool ]));
          default = null;
          description = ''
            Options to pass to rclone to control its behavior.
            See <link xlink:href="https://rclone.org/docs/#options"/> for
            available options. When specifying option names, strip the
            leading <literal>--</literal>. To set a flag such as
            <literal>--drive-use-trash</literal>, which does not take a value,
            set the value to the Boolean <literal>true</literal>.
          '';
          example = {
            bwlimit = "10M";
            drive-use-trash = "true";
          };
        };

        rcloneConfig = mkOption {
          type = with types; nullOr (attrsOf (oneOf [ str bool ]));
          default = null;
          description = ''
            Configuration for the rclone remote being used for backup.
            See the remote's specific options under rclone's docs at
            <link xlink:href="https://rclone.org/docs/"/>. When specifying
            option names, use the "config" name specified in the docs.
            For example, to set <literal>--b2-hard-delete</literal> for a B2
            remote, use <literal>hard_delete = true</literal> in the
            attribute set.
            Warning: Secrets set in here will be world-readable in the Nix
            store! Consider using the <literal>rcloneConfigFile</literal>
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
          description = ''
            Path to the file containing rclone configuration. This file
            must contain configuration for the remote specified in this backup
            set and also must be readable by root. Options set in
            <literal>rcloneConfig</literal> will override those set in this
            file.
          '';
        };

        repository = mkOption {
          type = types.str;
          description = ''
            repository to backup to.
          '';
          example = "sftp:backup@192.168.1.100:/backups/${name}";
        };

        paths = mkOption {
          type = types.listOf types.str;
          default = [];
          description = ''
            Which paths to backup.
          '';
          example = [
            "/var/lib/postgresql"
            "/home/user/backup"
          ];
        };

        timerConfig = mkOption {
          type = types.attrsOf unitOption;
          default = {
            OnCalendar = "daily";
          };
          description = ''
            When to run the backup. See man systemd.timer for details.
          '';
          example = {
            OnCalendar = "00:05";
            RandomizedDelaySec = "5h";
          };
        };

        user = mkOption {
          type = types.str;
          default = "root";
          description = ''
            As which user the backup should run.
          '';
          example = "postgresql";
        };

        extraBackupArgs = mkOption {
          type = types.listOf types.str;
          default = [];
          description = ''
            Extra arguments passed to restic backup.
          '';
          example = [
            "--exclude-file=/etc/nixos/restic-ignore"
          ];
        };

        extraOptions = mkOption {
          type = types.listOf types.str;
          default = [];
          description = ''
            Extra extended options to be passed to the restic --option flag.
          '';
          example = [
            "sftp.command='ssh backup@192.168.1.100 -i /home/user/.ssh/id_rsa -s sftp'"
          ];
        };

        initialize = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Create the repository if it doesn't exist.
          '';
        };

        pruneOpts = mkOption {
          type = types.listOf types.str;
          default = [];
          description = ''
            A list of options (--keep-* et al.) for 'restic forget
            --prune', to automatically prune old snapshots.  The
            'forget' command is run *after* the 'backup' command, so
            keep that in mind when constructing the --keep-* options.
          '';
          example = [
            "--keep-daily 7"
            "--keep-weekly 5"
            "--keep-monthly 12"
            "--keep-yearly 75"
          ];
        };

        dynamicFilesFrom = mkOption {
          type = with types; nullOr str;
          default = null;
          description = ''
            A script that produces a list of files to back up.  The
            results of this command are given to the '--files-from'
            option.
          '';
          example = "find /home/matt/git -type d -name .git";
        };
      };
    }));
    default = {};
    example = {
      localbackup = {
        paths = [ "/home" ];
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
    systemd.services =
      mapAttrs' (name: backup:
        let
          extraOptions = concatMapStrings (arg: " -o ${arg}") backup.extraOptions;
          resticCmd = "${pkgs.restic}/bin/restic${extraOptions}";
          filesFromTmpFile = "/run/restic-backups-${name}/includes";
          backupPaths = if (backup.dynamicFilesFrom == null)
                        then concatStringsSep " " backup.paths
                        else "--files-from ${filesFromTmpFile}";
          pruneCmd = optionals (builtins.length backup.pruneOpts > 0) [
            ( resticCmd + " forget --prune " + (concatStringsSep " " backup.pruneOpts) )
            ( resticCmd + " check" )
          ];
          # Helper functions for rclone remotes
          rcloneRemoteName = builtins.elemAt (splitString ":" backup.repository) 1;
          rcloneAttrToOpt = v: "RCLONE_" + toUpper (builtins.replaceStrings [ "-" ] [ "_" ] v);
          rcloneAttrToConf = v: "RCLONE_CONFIG_" + toUpper (rcloneRemoteName + "_" + v);
          toRcloneVal = v: if lib.isBool v then lib.boolToString v else v;
        in nameValuePair "restic-backups-${name}" ({
          environment = {
            RESTIC_PASSWORD_FILE = backup.passwordFile;
            RESTIC_REPOSITORY = backup.repository;
          } // optionalAttrs (backup.rcloneOptions != null) (mapAttrs' (name: value:
            nameValuePair (rcloneAttrToOpt name) (toRcloneVal value)
          ) backup.rcloneOptions) // optionalAttrs (backup.rcloneConfigFile != null) {
            RCLONE_CONFIG = backup.rcloneConfigFile;
          } // optionalAttrs (backup.rcloneConfig != null) (mapAttrs' (name: value:
            nameValuePair (rcloneAttrToConf name) (toRcloneVal value)
          ) backup.rcloneConfig);
          path = [ pkgs.openssh ];
          restartIfChanged = false;
          serviceConfig = {
            Type = "oneshot";
            ExecStart = [ "${resticCmd} backup ${concatStringsSep " " backup.extraBackupArgs} ${backupPaths}" ] ++ pruneCmd;
            User = backup.user;
            RuntimeDirectory = "restic-backups-${name}";
          } // optionalAttrs (backup.s3CredentialsFile != null) {
            EnvironmentFile = backup.s3CredentialsFile;
          };
        } // optionalAttrs (backup.initialize || backup.dynamicFilesFrom != null) {
          preStart = ''
            ${optionalString (backup.initialize) ''
              ${resticCmd} snapshots || ${resticCmd} init
            ''}
            ${optionalString (backup.dynamicFilesFrom != null) ''
              ${pkgs.writeScript "dynamicFilesFromScript" backup.dynamicFilesFrom} > ${filesFromTmpFile}
            ''}
          '';
        } // optionalAttrs (backup.dynamicFilesFrom != null) {
          postStart = ''
            rm ${filesFromTmpFile}
          '';
        })
      ) config.services.restic.backups;
    systemd.timers =
      mapAttrs' (name: backup: nameValuePair "restic-backups-${name}" {
        wantedBy = [ "timers.target" ];
        timerConfig = backup.timerConfig;
      }) config.services.restic.backups;
  };
}
