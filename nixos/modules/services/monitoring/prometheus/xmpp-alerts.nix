{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.prometheus.xmpp-alerts;
  settingsFormat = pkgs.formats.yaml { };
  configFile = settingsFormat.generate "prometheus-xmpp-alerts.yml" cfg.settings;
in
{
  imports = [
    (mkRenamedOptionModule
      [
        "services"
        "prometheus"
        "xmpp-alerts"
        "configuration"
      ]
      [
        "services"
        "prometheus"
        "xmpp-alerts"
        "settings"
      ]
    )
  ];

  options.services.prometheus.xmpp-alerts = {
    enable = mkEnableOption "XMPP Web hook service for Alertmanager";

    settings = mkOption {
      type = settingsFormat.type;
      default = { };

      description = ''
        Configuration for prometheus xmpp-alerts, see
        <https://github.com/jelmer/prometheus-xmpp-alerts/blob/master/xmpp-alerts.yml.example>
        for supported values.
      '';
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
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        SystemCallFilter = [ "@system-service" ];
      };
    };
  };
}
