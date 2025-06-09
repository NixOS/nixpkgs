{ config, lib, pkgs, ... }:

let
  wifimanPkg = pkgs.wifiman;
in
{
  options.services.wifiman = {
    enable = lib.mkEnableOption "WiFiman Desktop service";
  };

  config = lib.mkIf config.services.wifiman.enable {
    systemd.services.wifiman-desktop = {
      description = "WiFiman Desktop";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${wifimanPkg}/bin/wifiman-desktopd";
        Restart = "always";
        RestartSec = 10;
        User = "root";
      };
      preStart = ''
        mkdir -m 777 -p /var/lib/wifiman/assets/devices/
      '';
    };
  };
}
