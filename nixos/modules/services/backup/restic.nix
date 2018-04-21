{ config, lib, pkgs, ... }:

with lib;
{
  options.services.restic.backups = mkOption {
    description = ''
      Periodic backups to create with Restic.
    '';
    type = types.attrsOf (types.submodule ({ name, config, ... }: {
      options = {
        passwordFile = mkOption {
          type = types.str;
          description = ''
            Read the repository password from a file.
          '';
          example = "/etc/nixos/restic-password";

        };
        repository = mkOption {
          type = types.str;
          description = ''
            repository to backup to.
          '';
          example = "sftp:backup@192.168.1.100:/backups/${name}";
        };
        directories = mkOption {
          type = types.listOf types.str;
          default = [];
          description = ''
            Which directories to backup.
          '';
          example = [
            "/var/lib/postgresql"
            "/home/user/backup"
          ];
        };
        timerConfig = mkOption {
          type = types.attrsOf types.str;
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
        extraArguments = mkOption {
          type = types.listOf types.str;
          default = [];
          description = ''
            Extra arguments to append to the restic command.
          '';
          example = [
            "sftp.command='ssh backup@192.168.1.100 -i /home/user/.ssh/id_rsa -s sftp"
          ];
        };
        initialize = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Create the repository if it doesn't exist.
          '';
        };
      };
    }));
    default = {};
    example = {
      localbackup = {
        directories = [ "/home" ];
        repository = "/mnt/backup-hdd";
        passwordFile = "/etc/nixos/secrets/restic-password";
        initialize = true;
      };
      remotebackup = {
        directories = [ "/home" ];
        repository = "sftp:backup@host:/backups/home";
        passwordFile = "/etc/nixos/secrets/restic-password";
        extraArguments = [
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
          extraArguments = concatMapStringsSep " " (arg: "-o ${arg}") backup.extraArguments;
          connectTo = elemAt (splitString ":" backup.repository) 1;
          resticCmd = "${pkgs.restic}/bin/restic ${extraArguments}";
        in nameValuePair "restic-backups-${name}" ({
          environment = {
            RESTIC_PASSWORD_FILE = backup.passwordFile;
            RESTIC_REPOSITORY = backup.repository;
          };
          path = with pkgs; [
            openssh
          ];
          restartIfChanged = false;
          serviceConfig = {
            Type = "oneshot";
            ExecStart = map (dir: "${resticCmd} backup ${dir}") backup.directories;
            User = backup.user;
          };
        } // optionalAttrs backup.initialize {
          preStart = ''
            ${resticCmd} snapshots || ${resticCmd} init
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
