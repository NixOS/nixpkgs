{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    maintainers
    types
    literalExpression
    escapeShellArg
    escapeShellArgs
    mkEnableOption
    lib.mkOption
    mkRemovedOptionModule
    mkIf
    mkPackageOption
    lib.optionalString
    concatMapStrings
    concatStringsSep
    ;

  cfg = config.services.mtr-exporter;

  jobsConfig = pkgs.writeText "mtr-exporter.conf" (
    concatMapStrings (job: ''
      ${job.name} -- ${job.schedule} -- ${lib.concatStringsSep " " job.flags} ${job.address}
    '') cfg.jobs
  );
in
{
  imports = [
    (lib.mkRemovedOptionModule [
      "services"
      "mtr-exporter"
      "target"
    ] "Use services.mtr-exporter.jobs instead.")
    (lib.mkRemovedOptionModule [
      "services"
      "mtr-exporter"
      "mtrFlags"
    ] "Use services.mtr-exporter.jobs.<job>.flags instead.")
  ];

  options = {
    services = {
      mtr-exporter = {
        enable = lib.mkEnableOption "a Prometheus exporter for MTR";

        address = lib.mkOption {
          type = lib.types.str;
          default = "127.0.0.1";
          description = "Listen address for MTR exporter.";
        };

        port = lib.mkOption {
          type = lib.types.port;
          default = 8080;
          description = "Listen port for MTR exporter.";
        };

        extraFlags = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          example = [ "-flag.deprecatedMetrics" ];
          description = ''
            Extra command line options to pass to MTR exporter.
          '';
        };

        package = lib.mkPackageOption pkgs "mtr-exporter" { };

        mtrPackage = mkPackageOption pkgs "mtr" { };

        jobs = lib.mkOption {
          description = "List of MTR jobs. Will be added to /etc/mtr-exporter.conf";
          type = lib.types.nonEmptyListOf (
            types.submodule {
              options = {
                name = lib.mkOption {
                  type = lib.types.str;
                  description = "Name of ICMP pinging job.";
                };

                address = lib.mkOption {
                  type = lib.types.str;
                  example = "host.example.org:1234";
                  description = "Target address for MTR client.";
                };

                schedule = lib.mkOption {
                  type = lib.types.str;
                  default = "@every 60s";
                  example = "@hourly";
                  description = "Schedule of MTR checks. Also accepts Cron format.";
                };

                flags = lib.mkOption {
                  type = with lib.types; listOf str;
                  default = [ ];
                  example = [ "-G1" ];
                  description = "Additional flags to pass to MTR.";
                };
              };
            }
          );
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
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
            -bind ${lib.escapeShellArg "${cfg.address}:${toString cfg.port}"} \
            -jobs '${jobsConfig}' \
            ${lib.escapeShellArgs cfg.extraFlags}
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

  meta.maintainers = with lib.maintainers; [ jakubgs ];
}
