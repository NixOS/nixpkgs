{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.xserver.desktopManager.kodi;
in

{
  options = {
    services.xserver.desktopManager.kodi = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable the kodi multimedia center.";
      };

      package = lib.mkPackageOption pkgs "kodi" {
        example = "kodi.withPackages (p: with p; [ jellyfin pvr-iptvsimple vfs-sftp ])";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.xserver.desktopManager.session = [
      {
        name = "kodi";
        start = ''
          LIRC_SOCKET_PATH=/run/lirc/lircd ${cfg.package}/bin/kodi --standalone &
          waitPID=$!
        '';
      }
    ];

    environment.systemPackages = [ cfg.package ];
  };
}
