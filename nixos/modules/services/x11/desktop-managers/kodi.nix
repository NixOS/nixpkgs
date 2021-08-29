{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.desktopManager.kodi;
in

{
  options = {
    services.xserver.desktopManager.kodi = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable the kodi multimedia center.";
      };

      package = mkOption {
        type = types.package;
        default = pkgs.kodi;
        defaultText = "pkgs.kodi";
        example = "pkgs.kodi.withPackages (p: with p; [ jellyfin pvr-iptvsimple vfs-sftp ])";
        description = ''
          Package that should be used for Kodi.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    services.xserver.desktopManager.session = [{
      name = "kodi";
      start = ''
        LIRC_SOCKET_PATH=/run/lirc/lircd ${cfg.package}/bin/kodi --standalone &
        waitPID=$!
      '';
    }];

    environment.systemPackages = [ cfg.package ];
  };
}
