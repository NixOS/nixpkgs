{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.prometheus.alertmanager;
  mkConfigFile = pkgs.writeText "alertmanager.yml" (builtins.toJSON cfg.configuration);
  alertmanagerYml =
    if cfg.configText != null then
      pkgs.writeText "alertmanager.yml" cfg.configText
    else mkConfigFile;
in {
  options = {
    services.prometheus.alertmanager = {
      enable = mkEnableOption "Prometheus Alertmanager";

      user = mkOption {
        type = types.str;
        default = "nobody";
        description = ''
          User name under which Alertmanager shall be run.
        '';
      };

      group = mkOption {
        type = types.str;
        default = "nogroup";
        description = ''
          Group under which Alertmanager shall be run.
        '';
      };

      clusterAdvertiseAddress = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          If Alertmanager cannot find any private IP address on the host
          machine, will fail to start unless an explicit advertise address is
          provided.  In that case, you can use the machine's public IP address
          here.
        '';
      };

      configuration = mkOption {
        type = types.attrs;
        default = {};
        description = ''
          Alertmanager configuration as nix attribute set.
        '';
      };

      configText = mkOption {
        type = types.nullOr types.lines;
        default = null;
        description = ''
          Alertmanager configuration as YAML text. If non-null, this option
          defines the text that is written to alertmanager.yml. If null, the
          contents of alertmanager.yml is generated from the structured config
          options.
        '';
      };

      logFormat = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          If set use a syslog logger or JSON logging.
        '';
      };

      logLevel = mkOption {
        type = types.enum ["debug" "info" "warn" "error" "fatal"];
        default = "warn";
        description = ''
          Only log messages with the given severity or above.
        '';
      };

      webExternalUrl = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          The URL under which Alertmanager is externally reachable (for example, if Alertmanager is served via a reverse proxy).
          Used for generating relative and absolute links back to Alertmanager itself.
          If the URL has a path portion, it will be used to prefix all HTTP endoints served by Alertmanager.
          If omitted, relevant URL components will be derived automatically.
        '';
      };

      listenAddress = mkOption {
        type = types.str;
        default = "";
        description = ''
          Address to listen on for the web interface and API.
        '';
      };

      port = mkOption {
        type = types.int;
        default = 9093;
        description = ''
          Port to listen on for the web interface and API.
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

    systemd.services.alertmanager = {
      wantedBy = [ "multi-user.target" ];
      after    = [ "network.target" ];
      script = ''
        ${pkgs.prometheus-alertmanager.bin}/bin/alertmanager \
        --config.file ${alertmanagerYml} \
        --web.listen-address ${cfg.listenAddress}:${toString cfg.port} \
        --log.level ${cfg.logLevel} \
        ${optionalString (cfg.webExternalUrl != null) ''--web.external-url ${cfg.webExternalUrl} \''}
        ${optionalString (cfg.clusterAdvertiseAddress != null) ''--cluster.advertise-address ${cfg.clusterAdvertiseAddress} \''}
        ${optionalString (cfg.logFormat != null) "--log.format ${cfg.logFormat}"}
      '';

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        Restart  = "always";
        PrivateTmp = true;
        WorkingDirectory = "/tmp";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
      };
    };
  };
}
