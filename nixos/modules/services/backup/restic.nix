{
  pkgs,
  lib,
  config,
  utils,
  ...
}:
let
  additionalArguments = lib.mkOption {
    type = with lib.types; listOf str;
    default = [ ];
    example = [ "--retry-lock 10m" ];
    description = "Additional arguments to pass to the command.";
  };
  getRepositoryEnvironment =
    repositoryName: repository:
    {
      RESTIC_CACHE_DIR = "/var/cache/restic-backups-${repositoryName}";
      RESTIC_PASSWORD_FILE = repository.passwordFile;
    }
    // lib.optionalAttrs (repository.repository != null) {
      RESTIC_REPOSITORY = repository.repository;
    }
    // lib.optionalAttrs (repository.repositoryFile != null) {
      RESTIC_REPOSITORY_FILE = repository.repositoryFile;
    }
    // lib.optionalAttrs (repository.progressFps != null) {
      RESTIC_PROGRESS_FPS = toString repository.progressFps;
    };
in
{
  options.services.restic.backups = lib.mkOption {
    description = "A repository configuration for restic.";
    type = lib.types.attrsOf (
      lib.types.submodule (_: {
        options = {
          package = lib.mkPackageOption pkgs "restic" { };

          inherit additionalArguments;

          repository = lib.mkOption {
            type = with lib.types; nullOr str;
            default = null;
            example = "sftp:root@example.com:/backups";
            description = "Repository to use.";
          };

          repositoryFile = lib.mkOption {
            type =
              with lib.types;
              nullOr (pathWith {
                inStore = false;
                absolute = true;
              });
            default = null;
            example = "/run/secrets/restic-repository";
            description = "Path to a file containing the repository to use.";
          };

          passwordFile = lib.mkOption {
            type = lib.types.pathWith {
              inStore = false;
              absolute = true;
            };
            example = "/run/secrets/restic-repository-password";
            description = "Path to a file containing the repository password.";
          };

          createWrapper = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = ''
              Whether to generate and add a script to the system path, that has the same environment variables set
              as the systemd service. This can be used to e.g. mount snapshots or perform other operations, without
              having to manually specify most options.
            '';
          };

          progressFps = lib.mkOption {
            type = with lib.types; nullOr numbers.nonnegative;
            default = null;
            example = 0.1;
            description = "Controls the frequency of progress reporting";
          };

          jobs = lib.mkOption {
            type = lib.types.attrsOf (
              lib.types.submodule (_: {
                options = {
                  inherit additionalArguments;

                  inhibit = {
                    enable = lib.mkEnableOption "systemd-inhibit";

                    mode = lib.mkOption {
                      type = lib.types.enum [
                        "block"
                        "delay"
                        "block-weak"
                      ];
                      default = "block";
                      description = ''
                        Configure how the lock is held.

                        For more details see https://www.freedesktop.org/software/systemd/man/latest/systemd-inhibit.html.
                      '';
                    };

                    what = lib.mkOption {
                      type =
                        with lib.types;
                        listOf (enum [
                          "shutdown"
                          "sleep"
                          "idle"
                          "handle-power-key"
                          "handle-reboot-key"
                          "handle-suspend-key"
                          "handle-hibernate-key"
                          "handle-lid-switch"
                        ]);
                      default = [
                        "idle"
                        "sleep"
                        "shutdown"
                      ];
                      description = ''
                        Configure which operations to inhibit.

                        For more details see https://www.freedesktop.org/software/systemd/man/latest/systemd-inhibit.html.
                      '';
                    };
                  };

                  timerConfig = lib.mkOption {
                    type = with lib.types; nullOr (attrsOf utils.systemdUtils.unitOptions.unitOption);
                    default = null;
                    example = {
                      OnCalendar = "hourly";
                      RandomizedDelaySec = "1h";
                      FixedRandomDelay = true;
                      Persistent = true;
                    };
                    description = ''
                      When to run the backup. If null no timer is created and the backup will only run when explicitly started.

                      For more details see https://www.freedesktop.org/software/systemd/man/latest/systemd.timer.html.
                    '';
                  };

                  user = lib.mkOption {
                    type = lib.types.str;
                    default = "root";
                    example = "postgresql";
                    description = "As which user the job should run.";
                  };

                  initialize = lib.mkOption {
                    type = lib.types.bool;
                    default = false;
                    description = "Create the repository if it does not exist.";
                  };

                  backup = {
                    enable = lib.mkEnableOption "restic backup";

                    inherit additionalArguments;

                    readOnlyPaths = lib.mkOption {
                      type = lib.types.bool;
                      default = true;
                      description = "Bind mount the paths read-only, to prevent changing files during a backup.";
                    };

                    paths = lib.mkOption {
                      type =
                        with lib.types;
                        listOf (pathWith {
                          inStore = false;
                          absolute = true;
                        });
                      default = [ ];
                      example = [
                        "/var"
                        "/home"
                      ];
                      description = "Paths to backup.";
                    };

                    excludePaths = lib.mkOption {
                      type =
                        with lib.types;
                        listOf (pathWith {
                          inStore = false;
                          absolute = true;
                        });
                      default = [ ];
                      example = [
                        "/var/cache"
                        "/home/*/.cache"
                      ];
                      description = ''
                        Paths to exclude from backup.
                        Supports pattern matching.

                        For more details see https://restic.readthedocs.io/en/stable/040_backup.html#excluding-files.
                      '';
                    };

                    prepareCommand = lib.mkOption {
                      type = lib.types.str;
                      default = "";
                      description = "A script that must run before starting the backup.";
                    };

                    cleanupCommand = lib.mkOption {
                      type = lib.types.str;
                      default = "";
                      description = "A script that must run after finishing the backup.";
                    };
                  };

                  forget = {
                    enable = lib.mkEnableOption "restic forget";

                    inherit additionalArguments;
                  };

                  prune = {
                    enable = lib.mkEnableOption "restic prune";

                    inherit additionalArguments;
                  };

                  check = {
                    enable = lib.mkEnableOption "restic check";

                    inherit additionalArguments;
                  };
                };
              })
            );
          };
        };
      })
    );
  };

  config = {
    assertions = lib.flatten (
      lib.mapAttrsToList (
        repositoryName: repository:
        [
          {
            assertion = (repository.repository == null) != (repository.repositoryFile == null);
            message = "Exactly one of `services.restic.backups.${repositoryName}.repository` or `services.restic.backups.${repositoryName}.repositoryFile` must be set.";
          }
        ]
        ++ (lib.mapAttrsToList (jobName: job: [
          {
            assertion = job.backup.enable || job.forget.enable || job.prune.enable || job.check.enable;
            message = "Any of `backup.enable`, `forget.enable`, `prune.enable` or `check.enable` must be `true` in `services.restic.backups.${repositoryName}.jobs.${jobName}`.";
          }
          {
            assertion = !job.backup.enable || builtins.length job.backup.paths > 0;
            message = "`services.restic.backups.${repositoryName}.jobs.${jobName}.paths` must not be empty if `services.restic.backups.${repositoryName}.jobs.${jobName}.backup.enable` is `true`.";
          }
        ]) repository.jobs)
      ) config.services.restic.backups
    );

    systemd = {
      services = lib.mergeAttrsList (
        lib.mapAttrsToList (
          repositoryName: repository:
          lib.mapAttrs' (
            jobName: job:
            lib.nameValuePair "restic-backups-${repositoryName}-${jobName}" {
              environment = getRepositoryEnvironment repositoryName repository;
              restartIfChanged = false;
              serviceConfig = {
                Type = "oneshot";
                RuntimeDirectory = "restic-backups-${repositoryName}";
                CacheDirectory = "restic-backups-${repositoryName}";
                CacheDirectoryMode = "0700";
                User = config.users.users.${job.user}.name;
                BindReadOnlyPaths = lib.mkIf (job.backup.enable && job.backup.readOnlyPaths) job.backup.paths;
                ExecStart =
                  let
                    resticCmd = lib.concatStringsSep " " (
                      [ (lib.getExe repository.package) ] ++ repository.additionalArguments ++ job.additionalArguments
                    );
                    script = lib.getExe (
                      pkgs.writeShellScriptBin "restic-backups-${repositoryName}-${jobName}" ''
                        set -euo pipefail

                        ${lib.optionalString job.initialize ''
                          ${resticCmd} cat config > /dev/null || ${resticCmd} init
                        ''}

                        ${lib.optionalString job.backup.enable ''
                          ${job.backup.prepareCommand}

                          ${resticCmd} unlock
                          ${lib.concatStringsSep " " (
                            [
                              resticCmd
                              "backup"
                            ]
                            ++ job.backup.additionalArguments
                            ++ (map (path: "--exclude ${lib.escapeShellArg path}") job.backup.excludePaths)
                            ++ (map lib.escapeShellArg job.backup.paths)
                          )}

                          ${job.backup.cleanupCommand}
                        ''}

                        ${lib.optionalString job.forget.enable ''
                          ${resticCmd} unlock
                          ${lib.concatStringsSep " " (
                            [
                              resticCmd
                              "forget"
                            ]
                            ++ job.forget.additionalArguments
                          )}
                        ''}

                        ${lib.optionalString job.prune.enable ''
                          ${resticCmd} unlock
                          ${lib.concatStringsSep " " (
                            [
                              resticCmd
                              "prune"
                            ]
                            ++ job.prune.additionalArguments
                          )}
                        ''}

                        ${lib.optionalString job.check.enable ''
                          ${resticCmd} unlock
                          ${lib.concatStringsSep " " (
                            [
                              resticCmd
                              "check"
                            ]
                            ++ job.check.additionalArguments
                          )}
                        ''}
                      ''
                    );
                  in
                  if job.inhibit.enable then
                    "${lib.getExe' pkgs.systemd "systemd-inhibit"} --mode='${job.inhibit.mode}' --what='${lib.concatStringsSep ":" job.inhibit.what}' --who='restic-backups-${repositoryName}' --why=${lib.escapeShellArg "Restic job '${jobName}' on repository '${repositoryName}'"} ${script}"
                  else
                    script;
              };
            }
          ) repository.jobs
        ) config.services.restic.backups
      );

      timers = lib.mergeAttrsList (
        lib.mapAttrsToList (
          repositoryName: repository:
          lib.mapAttrs' (
            jobName: job:
            lib.nameValuePair "restic-backups-${repositoryName}-${jobName}" {
              wantedBy = [ "timers.target" ];
              inherit (job) timerConfig;
            }
          ) (lib.filterAttrs (_: job: job.timerConfig != null) repository.jobs)
        ) config.services.restic.backups
      );
    };

    environment.systemPackages = lib.mapAttrsToList (
      repositoryName: repository:
      let
        resticCmd = lib.concatStringsSep " " (
          [ (lib.getExe repository.package) ] ++ repository.additionalArguments
        );
      in
      pkgs.writeShellScriptBin "restic-${repositoryName}" ''
        ${
          lib.concatStringsSep " " (
            lib.mapAttrsToList (name: value: "${name}=${lib.escapeShellArg value}") (
              getRepositoryEnvironment repositoryName repository
            )
          )
        } ${resticCmd} "$@"
      ''
    ) (lib.filterAttrs (_: repository: repository.createWrapper) config.services.restic.backups);
  };
}
