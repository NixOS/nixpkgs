{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.networking.wireless.iwd;
  ini = pkgs.formats.ini { };
  configFile = ini.generate "main.conf" cfg.settings;
in {
  options.networking.wireless.iwd = {
    enable = mkEnableOption "iwd";

    settings = mkOption {
      type = ini.type;
      default = { };

      example = {
        Settings.AutoConnect = true;

        Network = {
          EnableIPv6 = true;
          RoutePriorityOffset = 300;
        };
      };

      description = ''
        Options passed to iwd.
        See <link xlink:href="https://iwd.wiki.kernel.org/networkconfigurationsettings">here</link> for supported options.
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions = [{
      assertion = !config.networking.wireless.enable;
      message = ''
        Only one wireless daemon is allowed at the time: networking.wireless.enable and networking.wireless.iwd.enable are mutually exclusive.
      '';
    }];

    environment.etc."iwd/main.conf".source = configFile;

    # for iwctl
    environment.systemPackages =  [ pkgs.iwd ];

    services.dbus.packages = [ pkgs.iwd ];

    systemd.packages = [ pkgs.iwd ];

    systemd.network.links."80-iwd" = {
      matchConfig.Type = "wlan";
      linkConfig.NamePolicy = "keep kernel";
    };

    systemd.services.iwd = {
      wantedBy = [ "multi-user.target" ];
      restartTriggers = [ configFile ];
    };
  };

  meta.maintainers = with lib.maintainers; [ mic92 dtzWill ];
}
