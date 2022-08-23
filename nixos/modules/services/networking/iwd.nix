{ config, lib, pkgs, ... }:

let
  inherit (lib)
    mkEnableOption mkIf mkOption types
    recursiveUpdate;

  cfg = config.networking.wireless.iwd;
  ini = pkgs.formats.ini { };
  defaults = {
    # without UseDefaultInterface, sometimes wlan0 simply goes AWOL with NetworkManager
    # https://iwd.wiki.kernel.org/interface_lifecycle#interface_management_in_iwd
    General.UseDefaultInterface = with config.networking.networkmanager; (enable && (wifi.backend == "iwd"));
  };
  configFile = ini.generate "main.conf" (recursiveUpdate defaults cfg.settings);

in
{
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

      description = lib.mdDoc ''
        Options passed to iwd.
        See [here](https://iwd.wiki.kernel.org/networkconfigurationsettings) for supported options.
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

    environment.etc."iwd/${configFile.name}".source = configFile;

    # for iwctl
    environment.systemPackages = [ pkgs.iwd ];

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
