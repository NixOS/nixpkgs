{pkgs, config, ...}:

let
  inherit (pkgs.lib) mkOption mkIf;
  cfg = config.services.xserver.windowManager.xbmc;
in

{
  options = {
    services.xserver.windowManager.xbmc = {
      enable = mkOption {
        default = false;
        example = true;
        description = "Enable the xbmc multimedia center.";
      };
    };
  };

  config = mkIf cfg.enable {
    services.xserver.windowManager = {
      session = [{
        name = "xbmc";
        start = "
          ${pkgs.xbmc}/bin/xbmc --lircdev /var/run/lirc/lircd --standalone &
          waitPID=$!
        ";
      }];
    };
    environment.systemPackages = [ pkgs.xbmc ];
  };
}
