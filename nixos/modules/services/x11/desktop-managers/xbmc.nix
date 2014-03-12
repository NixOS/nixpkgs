{ pkgs, config, ... }:

with pkgs.lib;

let
  cfg = config.services.xserver.desktopManager.xbmc;
in

{
  options = {
    services.xserver.desktopManager.xbmc = {
      enable = mkOption {
        default = false;
        example = true;
        description = "Enable the xbmc multimedia center.";
      };
    };
  };

  config = mkIf cfg.enable {
    services.xserver.desktopManager.session = [{
      name = "xbmc";
      start = ''
        ${pkgs.xbmc}/bin/xbmc --lircdev /var/run/lirc/lircd --standalone &
        waitPID=$!
      '';
    }];
    
    environment.systemPackages = [ pkgs.xbmc ];
  };
}