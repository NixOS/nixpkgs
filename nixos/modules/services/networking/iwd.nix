{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.networking.wireless.iwd;
  ini = pkgs.formats.ini { };
  configFile = ini.generate "main.conf" cfg.settings;
in {
  options.networking.wireless.iwd = {
    enable = mkEnableOption "iwd";

    # https://github.com/NixOS/nixpkgs/issues/110898
    enableLinkPolicy = mkOption {
      default = true;
      description = "Whether to enable iwd's link policy to disable predictable interface naming scheme";
      example = true;
      type = types.bool;
    };

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

  config = mkIf cfg.enable ({
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

    systemd.services.iwd = {
      wantedBy = [ "multi-user.target" ];
      restartTriggers = [ configFile ];
    };
  } // optionalAttrs cfg.enableLinkPolicy {
    systemd.network.links."80-iwd" = {
      matchConfig.Type = "wlan";
      linkConfig.NamePolicy = "keep kernel";
    };
  });

  meta.maintainers = with lib.maintainers; [ mic92 dtzWill ];
}
