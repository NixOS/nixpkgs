{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.prometheus.collectdExporter;

  collectSettingsArgs = if (cfg.collectdBinary.enable) then ''
    -collectd.listen-address ${optionalString (cfg.collectdBinary.listenAddress != null) cfg.collectdBinary.listenAddress}:${toString cfg.collectdBinary.port} \
    -collectd.security-level ${cfg.collectdBinary.securityLevel} \
  '' else "";

in {
  options = {
    services.prometheus.collectdExporter = {
      enable = mkEnableOption "prometheus collectd exporter";

      port = mkOption {
        type = types.int;
        default = 9103;
        description = ''
          Port to listen on.
          This is used for scraping as well as the to receive collectd data via the write_http plugin.
        '';
      };

      listenAddress = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "0.0.0.0";
        description = ''
          Address to listen on for web interface, telemetry and collectd JSON data.
        '';
      };

      collectdBinary = {
        enable = mkEnableOption "collectd binary protocol receiver";

        authFile = mkOption {
          default = null;
          type = types.nullOr types.path;
          description = "File mapping user names to pre-shared keys (passwords).";
        };

        port = mkOption {
          type = types.int;
          default = 25826;
          description = ''Network address on which to accept collectd binary network packets.'';
        };

        listenAddress = mkOption {
          type = types.nullOr types.str;
          default = null;
          example = "0.0.0.0";
          description = ''
            Address to listen on for binary network packets.
            '';
        };

        securityLevel = mkOption {
          type = types.enum ["None" "Sign" "Encrypt"];
          default = "None";
          description = ''
            Minimum required security level for accepted packets.
            '';
        };
      };

      extraFlags = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          Extra commandline options when launching the collectd exporter.
        '';
      };

      logFormat = mkOption {
        type = types.str;
        default = "logger:stderr";
        example = "logger:syslog?appname=bob&local=7 or logger:stdout?json=true";
        description = ''
          Set the log target and format.
        '';
      };

      logLevel = mkOption {
        type = types.enum ["debug" "info" "warn" "error" "fatal"];
        default = "info";
        description = ''
          Only log messages with the given severity or above.
        '';
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Open port in firewall for incoming connections.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = (optional cfg.openFirewall cfg.port) ++
      (optional (cfg.openFirewall && cfg.collectdBinary.enable) cfg.collectdBinary.port);

    systemd.services.prometheus-collectd-exporter = {
      description = "Prometheus exporter for Collectd metrics";
      unitConfig.Documentation = "https://github.com/prometheus/collectd_exporter";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        DynamicUser = true;
        Restart = "always";
        PrivateTmp = true;
        WorkingDirectory = /tmp;
        ExecStart = ''
          ${pkgs.prometheus-collectd-exporter}/bin/collectd_exporter \
            -log.format ${cfg.logFormat} \
            -log.level ${cfg.logLevel} \
            -web.listen-address ${optionalString (cfg.listenAddress != null) cfg.listenAddress}:${toString cfg.port} \
            ${collectSettingsArgs} \
            ${concatStringsSep " " cfg.extraFlags}
        '';
      };
    };
  };
}
