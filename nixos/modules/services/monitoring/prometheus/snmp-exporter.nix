{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.prometheus.snmpExporter;
  mkConfigFile = pkgs.writeText "snmp.yml" (if cfg.configurationPath == null then builtins.toJSON cfg.configuration else builtins.readFile cfg.configurationPath);
in {
  options = {
    services.prometheus.snmpExporter = {
      enable = mkEnableOption "Prometheus snmp exporter";

      user = mkOption {
        type = types.str;
        default = "nobody";
        description = ''
          User name under which snmp exporter shall be run.
        '';
      };

      group = mkOption {
        type = types.str;
        default = "nogroup";
        description = ''
          Group under which snmp exporter shall be run.
        '';
      };

      port = mkOption {
        type = types.int;
        default = 9116;
        description = ''
          Port to listen on.
        '';
      };

      listenAddress = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Address to listen on for web interface and telemetry.
        '';
      };

      configurationPath = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = ''
          Path to a snmp exporter configuration file. Mutually exclusive with 'configuration' option.
        '';
        example = "./snmp.yml";
      };

      configuration = mkOption {
        type = types.nullOr types.attrs;
        default = {};
        description = ''
          Snmp exporter configuration as nix attribute set. Mutually exclusive with 'configurationPath' option.
        '';
        example = ''
          {
            "default" = {
              "version" = 2;
              "auth" = {
                "community" = "public";
              };
            };
          };
        '';
      };

      logFormat = mkOption {
        type = types.str;
        default = "logger:stderr";
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
    networking.firewall.allowedTCPPorts = optional cfg.openFirewall cfg.port;

    assertions = singleton
      {
        assertion = (cfg.configurationPath == null) != (cfg.configuration == null);
        message = "Please ensure you have either 'configuration' or 'configurationPath' set!";
      };

    systemd.services.prometheus-snmp-exporter = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      script = ''
        ${pkgs.prometheus-snmp-exporter.bin}/bin/snmp_exporter \
          -config.file ${mkConfigFile} \
          -log.format ${cfg.logFormat} \
          -log.level ${cfg.logLevel} \
          -web.listen-address ${optionalString (cfg.listenAddress != null) cfg.listenAddress}:${toString cfg.port}
      '';

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        Restart  = "always";
        PrivateTmp = true;
        WorkingDirectory = "/tmp";
      };
    };
  };
}
