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
        default = "alertmanager";
        description = ''
          User name under which Alertmanager shall be run.
        '';
      };

      group = mkOption {
        type = types.str;
        default = "alertmanager";
        description = ''
          Group under which Alertmanager shall be run.
        '';
      };

      stateDir = mkOption {
        type = types.str;
        default = "/var/lib/alertmanager";
        description = ''
          Directory where alertmanager saves its state, i.e. silences.
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

      meshPeers = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          Initial peers for HA mesh cluster.
        '';
      };
    };
  };


  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = optional cfg.openFirewall cfg.port;

    users.extraUsers."${cfg.user}".group = cfg.group;
    users.extraGroups."${cfg.group}" = { };

    systemd.tmpfiles.rules = [
      "d ${cfg.stateDir} 0770 ${cfg.user} ${cfg.group} -"
    ];

    systemd.services.alertmanager = {
      wantedBy = [ "multi-user.target" ];
      after    = [ "network.target" ];
      script = ''
        ${pkgs.prometheus-alertmanager.bin}/bin/alertmanager \
          --config.file ${alertmanagerYml} \
          --web.listen-address ${cfg.listenAddress}:${toString cfg.port} \
          --log.level ${cfg.logLevel} \
          --storage.path ${cfg.stateDir} \
          ${optionalString (cfg.webExternalUrl != null) ''--web.external-url ${cfg.webExternalUrl}''} \
          ${optionalString (cfg.logFormat != null) "--log.format ${cfg.logFormat}"} \
          ${toString (map (peer: "--mesh.peer ${peer}:6783") cfg.meshPeers)}
      '';

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        Restart  = "always";
        PrivateTmp = true;
        WorkingDirectory = cfg.stateDir;
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
      };
    };
  };
}
