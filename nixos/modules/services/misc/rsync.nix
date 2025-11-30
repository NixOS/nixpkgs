{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let
  cfg = config.services.rsync;
  inherit (lib) types;
  inherit (utils.systemdUtils.unitOptions) unitOption;
in
{
  options.services.rsync = {
    enable = lib.mkEnableOption "periodic directory syncing via rsync";

    package = lib.mkPackageOption pkgs "rsync" { };

    jobs = lib.mkOption {
      description = ''
        Synchronization jobs to run.
      '';
      default = { };
      type = types.attrsOf (
        types.submodule {
          options = {
            sources = lib.mkOption {
              type = types.nonEmptyListOf types.str;
              example = [
                "/srv/src1/"
                "/srv/src2/"
              ];
              description = ''
                Source directories.
              '';
            };

            destination = lib.mkOption {
              type = types.str;
              example = "/srv/dst";
              description = ''
                Destination directory.
              '';
            };

            settings = lib.mkOption {
              type =
                let
                  simples = [
                    types.bool
                    types.str
                    types.int
                    types.float
                  ];
                in
                types.attrsOf (
                  types.oneOf (
                    simples
                    ++ [
                      (types.listOf (types.oneOf simples))
                    ]
                  )
                );
              default = { };
              example = {
                verbose = true;
                archive = true;
                delete = true;
                mkpath = true;
              };
              description = ''
                Settings that should be passed to rsync via long options.
                See {manpage}`rsync(1)` for available options.
              '';
            };

            user = lib.mkOption {
              type = types.str;
              default = "root";
              description = ''
                The name of an existing user account under which the rsync process should run.
              '';
            };

            group = lib.mkOption {
              type = types.str;
              default = "root";
              description = ''
                The name of an existing user group under which the rsync process should run.
              '';
            };

            timerConfig = lib.mkOption {
              type = types.nullOr (types.attrsOf unitOption);
              default = {
                OnCalendar = "daily";
                Persistent = true;
              };
              description = ''
                When to run the job.
              '';
            };

            inhibit = lib.mkOption {
              default = [ ];
              type = types.listOf (types.strMatching "^[^:]+$");
              example = [
                "sleep"
              ];
              description = ''
                Run the rsync process with an inhibition lock taken;
                see {manpage}`systemd-inhibit(1)` for a list of possible operations.
              '';
            };
          };
        }
      );
    };
  };

  config = lib.mkIf cfg.enable {
    systemd = lib.mkMerge (
      lib.mapAttrsToList (
        jobName: job:
        let
          systemdName = "rsync-job-${jobName}";
          description = "Directory syncing via rsync job ${jobName}";
        in
        {
          timers.${systemdName} = {
            wantedBy = [
              "timers.target"
            ];
            inherit description;
            inherit (job) timerConfig;
          };

          services.${systemdName} = {
            inherit description;

            serviceConfig = {
              Type = "oneshot";

              ExecStart =
                let
                  settingsToCommandLine = lib.cli.toCommandLineGNU {
                    isLong = _: true;
                  };

                  inhibitArgs = [
                    (lib.getExe' config.systemd.package "systemd-inhibit")
                    "--mode"
                    "block"
                    "--who"
                    description
                    "--what"
                    (lib.concatStringsSep ":" job.inhibit)
                    "--why"
                    "Scheduled rsync job ${jobName}"
                    "--"
                  ];

                  args =
                    (lib.optionals (job.inhibit != [ ]) inhibitArgs)
                    ++ [ (lib.getExe cfg.package) ]
                    ++ (settingsToCommandLine job.settings)
                    ++ [ "--" ]
                    ++ job.sources
                    ++ [ job.destination ];
                in
                utils.escapeSystemdExecArgs args;

              User = job.user;
              Group = job.group;

              NoNewPrivileges = true;
              PrivateDevices = true;
              ProtectSystem = "full";
              ProtectKernelTunables = true;
              ProtectKernelModules = true;
              ProtectControlGroups = true;
              MemoryDenyWriteExecute = true;
              LockPersonality = true;
            };
          };
        }
      ) cfg.jobs
    );
  };

  meta.maintainers = [
    lib.maintainers.lukaswrz
  ];
}
