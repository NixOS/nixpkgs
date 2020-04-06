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
        in nameValuePair "restic-backups-${name}" ({
          environment = {
            RESTIC_PASSWORD_FILE = backup.passwordFile;
            RESTIC_REPOSITORY = backup.repository;
          };
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
