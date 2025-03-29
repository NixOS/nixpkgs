{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.create_ap;
  configFile = pkgs.writeText "create_ap.conf" (lib.generators.toKeyValue { } cfg.settings);
in
{
  options = {
    services.create_ap = {
      enable = lib.mkEnableOption "setting up wifi hotspots using create_ap";
      settings = lib.mkOption {
        type =
          with lib.types;
          attrsOf (oneOf [
            int
            bool
            str
          ]);
        default = { };
        description = ''
          Configuration for `create_ap`.
          See [upstream example configuration](https://raw.githubusercontent.com/lakinduakash/linux-wifi-hotspot/master/src/scripts/create_ap.conf)
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

  config = lib.mkIf cfg.enable {

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
