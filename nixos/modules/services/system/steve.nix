{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.steve;
in
{
  options.services.steve = {
    enable = lib.mkEnableOption "steve, a system-wide GNU Make-compatible jobserver";

    enableAutomaticSandboxPathSetup = lib.mkEnableOption ''
      automatic installation of {option}`service.steve.device` to
      {option}`nix.settings.sandbox-paths` so that sandboxed builds
      automatically can reach the jobserver pool.
    '';

    enableAutomaticJobserverAdvertisement = lib.mkEnableOption ''
      automatic advertisement of jobserver availability by exporting
      `MAKEFLAGS=--jobserver-auth=fifo:<device>` for the Nix daemon and for
      interactive shells.

      This lead builds to automatically use the system-wide pool.
    '';

    package = lib.mkPackageOption pkgs "steve" { };

    device = lib.mkOption {
      type = lib.types.str;
      default = "/dev/steve";
      description = ''
        Device to create and serve the jobserver on. It is bind-mounted into
        build sandboxes.
      '';
    };

    jobs = lib.mkOption {
      type = lib.types.ints.unsigned;
      default = 0;
      description = ''
        Size of the global token pool. `0` uses the number of online CPUs.

        Note that concurrent clients each hold one *implicit* token, so the
        number of simultaneously running jobs is approximately
        `jobs + number-of-clients`.
      '';
    };

    minJobs = lib.mkOption {
      type = lib.types.ints.unsigned;
      default = 1;
      description = ''
        Number of jobs that keep running even when the resource limits are attained.
        This is useful to ensure that throttled build still makes progress.

        Must not exceed {option}`services.steve.jobs`.
      '';
    };

    maxLoadAverage = lib.mkOption {
      type = lib.types.nullOr lib.types.numbers.positive;
      default = null;
      example = 16;
      description = ''
        Refuse tokens while the number of runnable threads is at or above this
        value. `null` disables load-based throttling.

        WARNING: this is NOT compared against the kernel 1/5/15 minute load averages.
        steve reads the `nr_running` field of `/proc/loadavg`, minus one for itself.
      '';
    };

    perProcessLimit = lib.mkOption {
      type = lib.types.nullOr lib.types.ints.positive;
      default = null;
      description = ''
        Maximum number of tokens a single client may hold.
        Use this to impose some fairness and avoid a client to hold all the tokens.

        `null` means unlimited.
      '';
    };

    minMemoryAvailable = lib.mkOption {
      type = lib.types.nullOr lib.types.ints.unsigned;
      default = null;
      example = 2048;
      description = ''
        Refuse tokens while less than this many MiB of memory are available.
        `null` disables memory-based throttling.

        Enabling this makes steve read `/proc/meminfo` while serving tokens.

        For overhead reasons, prefer {option}`services.steve.maxLoadAverage`
        unless memory pressure is the actual problem.
      '';
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        assertions = [
          {
            assertion = cfg.minJobs <= cfg.jobs || cfg.jobs == 0;
            message = ''
              services.steve.minJobs (${toString cfg.minJobs}) must not exceed
              services.steve.jobs (${toString cfg.jobs}).
            '';
          }
        ];

        services.udev.extraRules = ''
          ACTION=="add", ENV{DEVNAME}=="${cfg.device}", GROUP="nixbld", MODE="0660"
        '';

        systemd.services.steve = {
          description = "System-wide GNU Make jobserver";
          wantedBy = [ "multi-user.target" ];

          # This is important for ongoing builds, treat it like the Nix daemon.
          restartIfChanged = false;
          unitConfig.StartLimitIntervalSec = 60;
          serviceConfig = {
            ExecStart = lib.escapeShellArgs (
              [
                (lib.getExe cfg.package)
                "--jobs=${toString cfg.jobs}"
                "--min-jobs=${toString cfg.minJobs}"
                "--dev-name=${baseNameOf cfg.device}"
              ]
              ++ lib.optional (cfg.maxLoadAverage != null) "--load-average=${toString cfg.maxLoadAverage}"
              ++ lib.optional (cfg.perProcessLimit != null) "--per-process-limit=${toString cfg.perProcessLimit}"
              ++ lib.optional (
                cfg.minMemoryAvailable != null
              ) "--min-memory-avail=${toString cfg.minMemoryAvailable}"
            );
            Restart = "on-failure";
            RestartSec = "1s";

            # open("/dev/cuse") has to happen as root then privilege dropping
            # will take place.
            Type = "exec";

            # Clients must be able to return their tokens so it must NOT be
            # KillMode=mixed.
            KillMode = "control-group";
            TimeoutStopSec = "5s";

            PrivateTmp = true;
            ProtectSystem = "strict";
            ProtectHome = true;
            ProtectKernelTunables = true;
            ProtectKernelModules = true;
            ProtectControlGroups = true;
            RestrictAddressFamilies = [ "AF_UNIX" ];
            RestrictNamespaces = true;
            LockPersonality = true;
            # TODO: test this.
            # MemoryDenyWriteExecute = true;
            SystemCallFilter = [ "@system-service" ];
          };
        };
      }

      (lib.mkIf cfg.enableAutomaticSandboxPathSetup {
        nix.settings.sandbox-paths = [ cfg.device ];
      })

      (lib.mkIf cfg.enableAutomaticJobserverAdvertisement {
        # As soon as this gets passed, `stdenv/setup.sh` and co. will stop passing -j, see `inJobserver` function.
        nix.envVars.MAKEFLAGS = lib.mkDefault "--jobserver-auth=fifo:${cfg.device}";
        environment.sessionVariables.MAKEFLAGS = lib.mkDefault "--jobserver-auth=fifo:${cfg.device}";
      })
    ]
  );
}
