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
  helpers = import ./helpers.nix { inherit lib config; };
in
{
  options.services.kopia.backups = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule {
        options.snapshots = lib.mkOption {
          type = lib.types.attrsOf (
            lib.types.submodule {
              options = {
                path = lib.mkOption {
                  type = lib.types.str;
                  description = "Path to back up with `kopia snapshot create`.";
                  example = "/home";
                };

                user = lib.mkOption {
                  type = with lib.types; nullOr str;
                  default = null;
                  description = ''
                    OS user the systemd snapshot service runs as. Defaults to
                    the enclosing backup's {option}`user`. The user component
                    of the kopia source identifier (`user@host:/path`) is
                    derived from this by default; override independently with
                    {option}`source.user`.
                  '';
                };

                source = {
                  user = lib.mkOption {
                    type = with lib.types; nullOr str;
                    default = null;
                    description = ''
                      User component of the kopia source identifier
                      (`user@host:/path`). Defaults to the effective
                      {option}`user`. Set this when you want the OS user the
                      snapshot runs as to differ from the logical user the
                      snapshot is registered under in the repository.
                    '';
                  };

                  host = lib.mkOption {
                    type = with lib.types; nullOr str;
                    default = null;
                    description = ''
                      Host component of the kopia source identifier
                      (`user@host:/path`). Defaults to
                      {option}`networking.hostName`. Set this to consolidate
                      snapshots from multiple machines under one logical
                      hostname.
                    '';
                  };

                  path = lib.mkOption {
                    type = with lib.types; nullOr str;
                    default = null;
                    description = ''
                      Path component of the kopia source identifier
                      (`user@host:/path`). Defaults to {option}`path` (the
                      filesystem location being walked). Set this when the
                      logical identity of the snapshot should differ from the
                      physical path, e.g. to make snapshots portable across
                      machines that mount the same source under different
                      paths.
                    '';
                  };
                };

                policy = lib.mkOption {
                  type = lib.types.attrsOf lib.types.anything;
                  default = { };
                  description = ''
                    Per-snapshot kopia policy. Merged into
                    {option}`services.kopia.backups.<name>.policies.entries`
                    under the target `''${user}@''${host}:''${path}`, with explicit
                    entries from `policies.entries` taking precedence. Use
                    `kopia policy export` to inspect the format.
                  '';
                  example = lib.literalExpression ''
                    {
                      retention.keepDaily = 7;
                      compression.compressorName = "zstd";
                    }
                  '';
                };

                extraSnapshotArgs = lib.mkOption {
                  type = lib.types.listOf lib.types.str;
                  default = [ ];
                  description = "Extra arguments passed to `kopia snapshot create`.";
                };

                backupPrepareCommand = lib.mkOption {
                  type = with lib.types; nullOr str;
                  default = null;
                  description = "Script that runs before starting the snapshot.";
                };

                backupCleanupCommand = lib.mkOption {
                  type = with lib.types; nullOr str;
                  default = null;
                  description = ''
                    Script that runs after the snapshot finishes (ExecStopPost,
                    so it executes even if the snapshot fails).
                  '';
                };

                extraServiceConfig = lib.mkOption {
                  type = lib.types.attrsOf unitOption;
                  default = {
                    Nice = 19;
                    CPUWeight = 10;
                    IOSchedulingClass = "idle";
                    IOWeight = 10;
                  };
                  description = ''
                    Extra systemd service config merged on top of the module's
                    hardening defaults. The default value sets background-task
                    priority via `Nice`, `CPUWeight`, `IOSchedulingClass`, and
                    `IOWeight`; override individual keys to tune. Any systemd
                    {manpage}`systemd.exec(5)` directive can be set here.
                  '';
                };

                timer = {
                  enable = lib.mkOption {
                    type = lib.types.bool;
                    default = false;
                    description = ''
                      Whether to create a systemd timer for this snapshot.
                      Off by default. Flip this on to schedule
                      recurring snapshots via {option}`timer.options`.

                      Keep in mind that kopia has its own in-built
                      scheduler. It's advised to turn it off for
                      snapshots you intend to manage via systemd
                      to avoid redundant snapshots.
                    '';
                  };
                  options = lib.mkOption {
                    type = lib.types.attrsOf unitOption;
                    default = {
                      OnCalendar = "daily";
                      Persistent = true;
                    };
                    description = "When to run the snapshot. See {manpage}`systemd.timer(5)`.";
                    example = {
                      OnCalendar = "00:05";
                      RandomizedDelaySec = "5h";
                      Persistent = true;
                    };
                  };
                };
              };
            }
          );
          default = { };
          description = ''
            Snapshots to take against this backup's repository. Each entry
            produces a `kopia-snapshot-<backupName>-<snapshotName>.service` unit
            (and optional matching `.timer`).
          '';
          example = lib.literalExpression ''
            {
              home = {
                path = "/home";
                timer.options.OnCalendar = "hourly";
              };
              db = {
                path = "/var/lib/postgresql";
                user = "postgres";
              };
            }
          '';
        };
      }
    );
  };

  config = lib.mkIf (cfg.backups != { }) {
    systemd.timers = lib.concatMapAttrs (
      backupName: backup:
      lib.concatMapAttrs (
        snapName: snapshot:
        lib.optionalAttrs snapshot.timer.enable {
          "kopia-snapshot-${backupName}-${snapName}" = {
            wantedBy = [ "timers.target" ];
            timerConfig = snapshot.timer.options;
          };
        }
      ) backup.snapshots
    ) cfg.backups;

    systemd.services = lib.concatMapAttrs (
      backupName: backup:
      lib.concatMapAttrs (
        snapName: snapshot:
        let
          kopiaExe = lib.getExe cfg.package;
          user = helpers.resolveOsUser backup snapshot;
          source = helpers.snapshotTarget backup snapshot;
          extraArgs = lib.concatStringsSep " " (
            [ "--override-source=${lib.escapeShellArg source}" ]
            ++ map lib.escapeShellArg snapshot.extraSnapshotArgs
          );
        in
        {
          "kopia-snapshot-${backupName}-${snapName}" = {
            description = "Kopia snapshot ${snapName} for ${backupName}";
            requires = [ "kopia-repository-${backupName}.service" ];
            wants = [ "kopia-policy-${backupName}.service" ];
            after = [
              "kopia-repository-${backupName}.service"
              "kopia-policy-${backupName}.service"
            ];
            environment = {
              KOPIA_CONFIG_PATH = "/var/lib/kopia/${backupName}/repository.config";
            };
            restartIfChanged = false;
            preStart = lib.mkIf (snapshot.backupPrepareCommand != null) snapshot.backupPrepareCommand;
            postStop = lib.mkIf (snapshot.backupCleanupCommand != null) snapshot.backupCleanupCommand;
            script = ''
              set -euo pipefail
              export KOPIA_PASSWORD="$(cat ${lib.escapeShellArg backup.passwordFile})"
              ${kopiaExe} snapshot create ${lib.escapeShellArg snapshot.path} ${extraArgs}
            '';
            serviceConfig = {
              Type = "oneshot";
              User = user;
              StateDirectory = "kopia/${backupName}";
              PrivateTmp = true;
              NoNewPrivileges = true;
              ProtectSystem = "strict";
              ReadWritePaths = [
                "/var/lib/kopia/${backupName}"
              ]
              ++ lib.optional (backup.repository ? filesystem) backup.repository.filesystem.path;
            }
            // snapshot.extraServiceConfig;
          };
        }
      ) backup.snapshots
    ) cfg.backups;
  };
}
