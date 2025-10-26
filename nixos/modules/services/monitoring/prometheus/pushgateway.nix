{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.prometheus.pushgateway;

  cmdlineArgs =
    opt "web.listen-address" cfg.web.listen-address
    ++ opt "web.telemetry-path" cfg.web.telemetry-path
    ++ opt "web.external-url" cfg.web.external-url
    ++ opt "web.route-prefix" cfg.web.route-prefix
    ++ lib.optional cfg.persistMetrics ''--persistence.file="/var/lib/${cfg.stateDir}/metrics"''
    ++ opt "persistence.interval" cfg.persistence.interval
    ++ opt "log.level" cfg.log.level
    ++ opt "log.format" cfg.log.format
    ++ cfg.extraFlags;

  opt = k: v: lib.optional (v != null) ''--${k}="${v}"'';

in
{
  options = {
    services.prometheus.pushgateway = {
      enable = lib.mkEnableOption "Prometheus Pushgateway";

      package = lib.mkPackageOption pkgs "prometheus-pushgateway" { };

      web.listen-address = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          Address to listen on for the web interface, API and telemetry.

          `null` will default to `:9091`.
        '';
      };

      web.telemetry-path = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          Path under which to expose metrics.

          `null` will default to `/metrics`.
        '';
      };

      web.external-url = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          The URL under which Pushgateway is externally reachable.
        '';
      };

      web.route-prefix = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          Prefix for the internal routes of web endpoints.

          Defaults to the path of
          {option}`services.prometheus.pushgateway.web.external-url`.
        '';
      };

      persistence.interval = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "10m";
        description = ''
          The minimum interval at which to write out the persistence file.

          `null` will default to `5m`.
        '';
      };

      log.level = lib.mkOption {
        type = lib.types.nullOr (
          lib.types.enum [
            "debug"
            "info"
            "warn"
            "error"
            "fatal"
          ]
        );
        default = null;
        description = ''
          Only log messages with the given severity or above.

          `null` will default to `info`.
        '';
      };

      log.format = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "logger:syslog?appname=bob&local=7";
        description = ''
          Set the log target and format.

          `null` will default to `logger:stderr`.
        '';
      };

      extraFlags = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = ''
          Extra commandline options when launching the Pushgateway.
        '';
      };

      persistMetrics = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to persist metrics to a file.

          When enabled metrics will be saved to a file called
          `metrics` in the directory
          `/var/lib/pushgateway`. The directory below
          `/var/lib` can be set using
          {option}`services.prometheus.pushgateway.stateDir`.
        '';
      };

      stateDir = lib.mkOption {
        type = lib.types.str;
        default = "pushgateway";
        description = ''
          Directory below `/var/lib` to store metrics.

          This directory will be created automatically using systemd's
          StateDirectory mechanism when
          {option}`services.prometheus.pushgateway.persistMetrics`
          is enabled.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !lib.hasPrefix "/" cfg.stateDir;
        message =
          "The option services.prometheus.pushgateway.stateDir"
          + " shouldn't be an absolute directory."
          + " It should be a directory relative to /var/lib.";
      }
    ];
    systemd.services.pushgateway = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart =
          "${cfg.package}/bin/pushgateway"
          + lib.optionalString (cmdlineArgs != [ ]) (" \\\n  " + lib.concatStringsSep " \\\n  " cmdlineArgs);

        CapabilityBoundingSet = [ "" ];
        DeviceAllow = [ "" ];
        DynamicUser = true;
        NoNewPrivileges = true;

        MemoryDenyWriteExecute = true;

        LockPersonality = true;

        ProtectProc = "invisible";
        ProtectSystem = "strict";
        ProtectHome = "tmpfs";

        PrivateTmp = true;
        PrivateDevices = true;
        PrivateIPC = true;

        ProcSubset = "pid";

        ProtectHostname = true;
        ProtectClock = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;

        Restart = "always";

        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;

        StateDirectory = if cfg.persistMetrics then cfg.stateDir else null;
        SystemCallFilter = [
          "@system-service"
          "~@cpu-emulation"
          "~@privileged"
          "~@reboot"
          "~@setuid"
          "~@swap"
        ];
      };
    };
  };
}
