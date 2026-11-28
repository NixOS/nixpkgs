{ config, lib, pkgs, ... }:

let
  wifimanPkg = pkgs.wifiman;
  cfg = config.services.wifiman;
in
{
  options.services.wifiman = {
    enable = lib.mkEnableOption "WiFiman Desktop service";
    package = lib.mkPackageOption pkgs "wifiman-desktop" { };
    log_level = mkOption {
      type = types.enum [
        "debug"
        "info"
        "warning"
        "error"
        "critical"
      ];
      default = "info";
      description = ''
        Level of log messages to emit.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.wifiman-desktop = {
      description = "WiFiman Desktop";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${wifimanPkg}/bin/wifiman-desktopd";
        Restart = "always";
        RestartSec = 30;
        User = "root";
        Environment = {
          LOG_LEVEL = cfg.log_level;
        };
      };


      preStart = ''
        mkdir -m 777 -p /var/lib/wifiman/assets/devices/
      '';
    };
  };
}
