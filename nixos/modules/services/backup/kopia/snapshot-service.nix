{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let
  inherit (utils.systemdUtils.unitOptions) unitOption;
  cfg = config.services.kopia;
  helpers = import ./helpers.nix { inherit lib; };
in
{
  options.services.kopia.backups = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule {
        options = {
          paths = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
            description = ''
              Paths to back up with Kopia snapshots.
            '';
            example = [
              "/home"
              "/var/lib/postgresql"
            ];
          };

          extraSnapshotArgs = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
            description = ''
              Extra arguments passed to `kopia snapshot create`.
            '';
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
              This runs in ExecStopPost, so it executes even if the backup fails.
            '';
          };

          nice = lib.mkOption {
            type = lib.types.ints.between (-20) 19;
            default = 19;
            description = ''
              Niceness value for the backup service process.
              See {manpage}`nice(1)`.
            '';
          };

          ioSchedulingClass = lib.mkOption {
            type = lib.types.enum [
              "idle"
              "best-effort"
              "realtime"
              "none"
            ];
            default = "idle";
            description = ''
              I/O scheduling class for the backup service (see {manpage}`ionice(1)`).
              Note that this only takes effect with the CFQ I/O scheduler.
              NVMe drives typically use mq-deadline or none, which do not
              honor this setting. Use {option}`ioWeight` instead on such
              systems.
              Set to `"none"` to leave unset.
            '';
          };

          ioWeight = lib.mkOption {
            type = with lib.types; nullOr (ints.between 1 10000);
            default = 10;
            description = ''
              cgroup v2 I/O weight for the backup service (1–10000, default 100).
              Lower values mean lower I/O priority. This works with modern I/O
              schedulers (mq-deadline, bfq, none) where {option}`ioSchedulingClass`
              has no effect.
              Set to `null` to leave unset.
            '';
          };

          timerConfig = lib.mkOption {
            type = lib.types.nullOr (lib.types.attrsOf unitOption);
            default = {
              OnCalendar = "daily";
              Persistent = true;
            };
            description = ''
              When to run the backup. See {manpage}`systemd.timer(5)` for details.
              If null no timer is created and the backup will only run when
              explicitly started.
            '';
            example = {
              OnCalendar = "00:05";
              RandomizedDelaySec = "5h";
              Persistent = true;
            };
          };
        };
      }
    );
  };

  config = lib.mkIf (cfg.backups != { }) {
    systemd.timers = lib.mapAttrs' (
      name: backup:
      lib.nameValuePair "kopia-snapshot-${name}" {
        wantedBy = [ "timers.target" ];
        inherit (backup) timerConfig;
      }
    ) (lib.filterAttrs (_: b: b.timerConfig != null && b.paths != [ ]) cfg.backups);

    systemd.services = lib.mapAttrs' (
      name: backup:
      let
        kopiaExe = lib.getExe cfg.package;
        extraArgs = lib.concatStringsSep " " (map lib.escapeShellArg backup.extraSnapshotArgs);
        snapshotScript = ''
          set -euo pipefail
          export KOPIA_PASSWORD="$(cat ${lib.escapeShellArg backup.passwordFile})"

          ${lib.concatMapStringsSep "\n" (path: ''
            ${kopiaExe} snapshot create ${lib.escapeShellArg path} ${extraArgs}
          '') backup.paths}
        '';
      in
      lib.nameValuePair "kopia-snapshot-${name}" (
        {
          description = "Kopia snapshot for ${name}";
          requires = [ "kopia-repository-${name}.service" ];
          after = [ "kopia-repository-${name}.service" ];
          environment = {
            KOPIA_CONFIG_PATH = "/var/lib/kopia/${name}/repository.config";
          };
          restartIfChanged = false;
          script = snapshotScript;
          serviceConfig = {
            Type = "oneshot";
            User = backup.user;
            StateDirectory = "kopia/${name}";
            PrivateTmp = true;
            NoNewPrivileges = true;
            ProtectSystem = "strict";
            ReadWritePaths = [
              "/var/lib/kopia/${name}"
            ]
            ++ lib.optional (backup.repository ? filesystem) backup.repository.filesystem.path;
          }
          // {
            Nice = backup.nice;
          }
          // lib.optionalAttrs (backup.ioSchedulingClass != "none") {
            IOSchedulingClass = backup.ioSchedulingClass;
          }
          // lib.optionalAttrs (backup.ioWeight != null) {
            IOWeight = backup.ioWeight;
          };
        }
        // lib.optionalAttrs (backup.backupPrepareCommand != null) {
          preStart = toString (pkgs.writeScript "kopia-backup-prepare-${name}" backup.backupPrepareCommand);
        }
        // lib.optionalAttrs (backup.backupCleanupCommand != null) {
          postStop = toString (pkgs.writeScript "kopia-backup-cleanup-${name}" backup.backupCleanupCommand);
        }
      )
    ) (lib.filterAttrs (_: b: b.paths != [ ]) cfg.backups);
  };
}
