{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.prometheus.xmpp-alerts;

  configFile = pkgs.writeText "prometheus-xmpp-alerts.yml" (builtins.toJSON cfg.configuration);

in

{
  options.services.prometheus.xmpp-alerts = {

    enable = mkEnableOption "XMPP Web hook service for Alertmanager";

    configuration = mkOption {
      type = types.attrs;
      description = "Configuration as attribute set which will be converted to YAML";
    };

  };

  config = mkIf cfg.enable {
    systemd.services.prometheus-xmpp-alerts = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.prometheus-xmpp-alerts}/bin/prometheus-xmpp-alerts --config ${configFile}";
        Restart = "on-failure";
        DynamicUser = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectHome = true;
        ProtectSystem = "strict";
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        NoNewPrivileges = true;
        SystemCallArchitectures = "native";
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
        SystemCallFilter = [ "@system-service" ];
      };
    };
  };
}
