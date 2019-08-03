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
        defaultText = "pkgs.prometheus-pushgateway";
        description = ''
          Package that should be used for the prometheus pushgateway.
        '';
      };

      web.listen-address = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Address to listen on for the web interface, API and telemetry.

          <literal>null</literal> will default to <literal>:9091</literal>.
        '';
      };

      web.telemetry-path = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Path under which to expose metrics.

          <literal>null</literal> will default to <literal>/metrics</literal>.
        '';
      };

      web.external-url = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          The URL under which Pushgateway is externally reachable.
        '';
      };

      web.route-prefix = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Prefix for the internal routes of web endpoints.

          Defaults to the path of
          <option>services.prometheus.pushgateway.web.external-url</option>.
        '';
      };

      persistence.interval = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "10m";
        description = ''
          The minimum interval at which to write out the persistence file.

          <literal>null</literal> will default to <literal>5m</literal>.
        '';
      };

      log.level = mkOption {
        type = types.nullOr (types.enum ["debug" "info" "warn" "error" "fatal"]);
        default = null;
        description = ''
          Only log messages with the given severity or above.

          <literal>null</literal> will default to <literal>info</literal>.
        '';
      };

      log.format = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "logger:syslog?appname=bob&local=7";
        description = ''
          Set the log target and format.

          <literal>null</literal> will default to <literal>logger:stderr</literal>.
        '';
      };

      extraFlags = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          Extra commandline options when launching the Pushgateway.
        '';
      };

      persistMetrics = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to persist metrics to a file.

          When enabled metrics will be saved to a file called
          <literal>metrics</literal> in the directory
          <literal>/var/lib/pushgateway</literal>. The directory below
          <literal>/var/lib</literal> can be set using
          <option>services.prometheus.pushgateway.stateDir</option>.
        '';
      };

      stateDir = mkOption {
        type = types.str;
        default = "pushgateway";
        description = ''
          Directory below <literal>/var/lib</literal> to store metrics.

          This directory will be created automatically using systemd's
          StateDirectory mechanism when
          <option>services.prometheus.pushgateway.persistMetrics</option>
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
