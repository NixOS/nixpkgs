{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.create_ap;
  configFile = pkgs.writeText "create_ap.conf" (generators.toKeyValue { } cfg.settings);
in {
  options = {
    services.create_ap = {
      enable = mkEnableOption "setup wifi hotspots using create_ap";
      settings = mkOption {
        type = with types; attrsOf (oneOf [ int bool str ]);
        default = {};
        description = ''
          Configuration for <package>create_ap</package>.
          See <link xlink:href="https://raw.githubusercontent.com/lakinduakash/linux-wifi-hotspot/master/src/scripts/create_ap.conf">upstream example configuration</link>
          for supported values.
        '';
        example = {
          INTERNET_IFACE = "eth0";
          WIFI_IFACE = "wlan0";
          SSID = "My Wifi Hotspot";
          PASSPHRASE = "12345678";
        };
      };
    };
  };

  config = mkIf cfg.enable {

    systemd = {
      services.create_ap = {
        wantedBy = [ "multi-user.target" ];
        description = "Create AP Service";
        after = [ "network.target" ];
        restartTriggers = [ configFile ];
        serviceConfig = {
          ExecStart = "${pkgs.linux-wifi-hotspot}/bin/create_ap --config ${configFile}";
          KillSignal = "SIGINT";
          Restart = "on-failure";
        };
      };
    };

  };

  meta.maintainers = with lib.maintainers; [ onny ];

}
