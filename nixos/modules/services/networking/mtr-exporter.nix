{ config, lib, pkgs, ... }:

let
  inherit (lib)
    maintainers types literalExpression
    escapeShellArg escapeShellArgs
    mkEnableOption mkOption mkRemovedOptionModule mkIf mdDoc
    optionalString concatMapStrings concatStringsSep;

  cfg = config.services.mtr-exporter;

  jobsConfig = pkgs.writeText "mtr-exporter.conf" (concatMapStrings (job: ''
    ${job.name} -- ${job.schedule} -- ${concatStringsSep " " job.flags} ${job.address}
  '') cfg.jobs);
in {
  imports = [
    (mkRemovedOptionModule [ "services" "mtr-exporter" "target" ] "Use services.mtr-exporter.jobs instead.")
    (mkRemovedOptionModule [ "services" "mtr-exporter" "mtrFlags" ] "Use services.mtr-exporter.jobs.<job>.flags instead.")
  ];

  options = {
    services = {
      mtr-exporter = {
        enable = mkEnableOption (mdDoc "a Prometheus exporter for MTR");

        address = mkOption {
          type = types.str;
          default = "127.0.0.1";
          description = lib.mdDoc "Listen address for MTR exporter.";
        };

        port = mkOption {
          type = types.port;
          default = 8080;
          description = mdDoc "Listen port for MTR exporter.";
        };

        extraFlags = mkOption {
          type = types.listOf types.str;
          default = [];
          example = ["-flag.deprecatedMetrics"];
          description = mdDoc ''
            Extra command line options to pass to MTR exporter.
          '';
        };

        package = mkOption {
          type = types.package;
          default = pkgs.mtr-exporter;
          defaultText = literalExpression "pkgs.mtr-exporter";
          description = mdDoc "The MTR exporter package to use.";
        };

        mtrPackage = mkOption {
          type = types.package;
          default = pkgs.mtr;
          defaultText = literalExpression "pkgs.mtr";
          description = mdDoc "The MTR package to use.";
        };

        jobs = mkOption {
          description = mdDoc "List of MTR jobs. Will be added to /etc/mtr-exporter.conf";
          type = types.nonEmptyListOf (types.submodule {
            options = {
              name = mkOption {
                type = types.str;
                description = mdDoc "Name of ICMP pinging job.";
              };

              address = mkOption {
                type = types.str;
                example = "host.example.org:1234";
                description = mdDoc "Target address for MTR client.";
              };

              schedule = mkOption {
                type = types.str;
                default = "@every 60s";
                example = "@hourly";
                description = mdDoc "Schedule of MTR checks. Also accepts Cron format.";
              };

              flags = mkOption {
                type = with types; listOf str;
                default = [];
                example = ["-G1"];
                description = mdDoc "Additional flags to pass to MTR.";
              };
            };
          });
        };
      };
    };
  };

  config = mkIf cfg.enable {
    environment.etc."mtr-exporter.conf" = {
      source = jobsConfig;
    };

    systemd.services.mtr-exporter = {
      wantedBy = [ "multi-user.target" ];
      requires = [ "network.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = ''
          ${cfg.package}/bin/mtr-exporter \
            -mtr '${cfg.mtrPackage}/bin/mtr' \
            -bind ${escapeShellArg "${cfg.address}:${toString cfg.port}"} \
            -jobs '${jobsConfig}' \
            ${escapeShellArgs cfg.extraFlags}
        '';
        Restart = "on-failure";
        # Hardening
        CapabilityBoundingSet = [ "" ];
        DynamicUser = true;
        LockPersonality = true;
        ProcSubset = "pid";
        PrivateDevices = true;
        PrivateUsers = true;
        PrivateTmp = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RestrictNamespaces = true;
        RestrictRealtime = true;
      };
    };
  };

  meta.maintainers = with maintainers; [ jakubgs ];
}
