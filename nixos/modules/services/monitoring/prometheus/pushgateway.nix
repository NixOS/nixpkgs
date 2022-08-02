{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.prometheus.pushgateway;

  cmdlineArgs =
       opt "web.listen-address" cfg.web.listen-address
    ++ opt "web.telemetry-path" cfg.web.telemetry-path
    ++ opt "web.external-url" cfg.web.external-url
    ++ opt "web.route-prefix" cfg.web.route-prefix
    ++ optional cfg.persistMetrics ''--persistence.file="/var/lib/${cfg.stateDir}/metrics"''
    ++ opt "persistence.interval" cfg.persistence.interval
    ++ opt "log.level" cfg.log.level
    ++ opt "log.format" cfg.log.format
    ++ cfg.extraFlags;

  opt = k : v : optional (v != null) ''--${k}="${v}"'';

in {
  options = {
    services.prometheus.pushgateway = {
      enable = mkEnableOption "Prometheus Pushgateway";

      package = mkOption {
        type = types.package;
        default = pkgs.prometheus-pushgateway;
        defaultText = literalExpression "pkgs.prometheus-pushgateway";
        description = lib.mdDoc ''
          Package that should be used for the prometheus pushgateway.
        '';
      };

      web.listen-address = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = lib.mdDoc ''
          Address to listen on for the web interface, API and telemetry.

          `null` will default to `:9091`.
        '';
      };

      web.telemetry-path = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = lib.mdDoc ''
          Path under which to expose metrics.

          `null` will default to `/metrics`.
        '';
      };

      web.external-url = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = lib.mdDoc ''
          The URL under which Pushgateway is externally reachable.
        '';
      };

      web.route-prefix = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = lib.mdDoc ''
          Prefix for the internal routes of web endpoints.

          Defaults to the path of
          {option}`services.prometheus.pushgateway.web.external-url`.
        '';
      };

      persistence.interval = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "10m";
        description = lib.mdDoc ''
          The minimum interval at which to write out the persistence file.

          `null` will default to `5m`.
        '';
      };

      log.level = mkOption {
        type = types.nullOr (types.enum ["debug" "info" "warn" "error" "fatal"]);
        default = null;
        description = lib.mdDoc ''
          Only log messages with the given severity or above.

          `null` will default to `info`.
        '';
      };

      log.format = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "logger:syslog?appname=bob&local=7";
        description = lib.mdDoc ''
          Set the log target and format.

          `null` will default to `logger:stderr`.
        '';
      };

      extraFlags = mkOption {
        type = types.listOf types.str;
        default = [];
        description = lib.mdDoc ''
          Extra commandline options when launching the Pushgateway.
        '';
      };

      persistMetrics = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to persist metrics to a file.

          When enabled metrics will be saved to a file called
          `metrics` in the directory
          `/var/lib/pushgateway`. The directory below
          `/var/lib` can be set using
          {option}`services.prometheus.pushgateway.stateDir`.
        '';
      };

      stateDir = mkOption {
        type = types.str;
        default = "pushgateway";
        description = lib.mdDoc ''
          Directory below `/var/lib` to store metrics.

          This directory will be created automatically using systemd's
          StateDirectory mechanism when
          {option}`services.prometheus.pushgateway.persistMetrics`
          is enabled.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = !hasPrefix "/" cfg.stateDir;
        message =
          "The option services.prometheus.pushgateway.stateDir" +
          " shouldn't be an absolute directory." +
          " It should be a directory relative to /var/lib.";
      }
    ];
    systemd.services.pushgateway = {
      wantedBy = [ "multi-user.target" ];
      after    = [ "network.target" ];
      serviceConfig = {
        Restart  = "always";
        DynamicUser = true;
        ExecStart = "${cfg.package}/bin/pushgateway" +
          optionalString (length cmdlineArgs != 0) (" \\\n  " +
            concatStringsSep " \\\n  " cmdlineArgs);
        StateDirectory = if cfg.persistMetrics then cfg.stateDir else null;
      };
    };
  };
}
