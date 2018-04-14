{ config, lib, pkgs, ... }:

with import <stockholm/lib>;

{
  options.services.restic = mkOption {
    type = types.attrsOf (types.submodule ({ config, ... }: {
      options = {
        name = mkOption {
          type = types.str;
          default = config._module.args.name;
        };
        passwordFile = mkOption {
          type = types.str;
          description = ''
            Read the repository password from a file.
          '';
          example = "/etc/nixos/restic-password";

        };
        repo = mkOption {
          type = types.str;
          description = ''
            repository to backup to.
          '';
          example = "sftp:backup@192.168.1.100:/backups/${config.name}";
        };
        dirs = mkOption {
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
  };

  config = {
    systemd.services =
      mapAttrs' (_: plan:
        let
          extraArguments = concatMapStringsSep " " (arg: "-o ${arg}") plan.extraArguments;
          connectTo = elemAt (splitString ":" plan.repo) 1;
          resticCmd = "${pkgs.restic}/bin/restic ${extraArguments}";
        in nameValuePair "backup.${plan.name}" {
          environment = {
            RESTIC_PASSWORD_FILE = plan.passwordFile;
            RESTIC_REPOSITORY = plan.repo;
          };
          path = with pkgs; [
            openssh
          ];
          restartIfChanged = false;
          serviceConfig = {
            ExecStartPre = mkIf plan.initialize (pkgs.writeScript "rustic-${plan.name}-init" ''
              #! ${pkgs.bash}/bin/bash
              ${resticCmd} snapshots || ${resticCmd} init
            '');
            ExecStart = pkgs.writeScript "rustic-${plan.name}" ''
              #! ${pkgs.bash}/bin/bash\n
              ${concatMapStringsSep "\n" (dir: "${resticCmd} backup ${dir}") plan.dirs}
            '';
            User = plan.user;
          };
        }
      ) config.services.restic;
    systemd.timers =
      mapAttrs' (_: plan: nameValuePair "backup.${plan.name}" {
        wantedBy = [ "timers.target" ];
        timerConfig = plan.timerConfig;
      }) config.services.restic;
  };
}
