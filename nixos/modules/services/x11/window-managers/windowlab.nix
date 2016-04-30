{lib, pkgs, config, ...}:

with lib;

let
  wmcfg = config.services.xserver.windowManager;
  cfg = wmcfg.windowlab;
in

{
  config = mkIf (elem "windowlab" wmcfg.enable) {
    services.xserver.windowManager = {
      session =
        [{ name  = "windowlab";
           start = "${pkgs.windowlab}/bin/windowlab";
        }];
    };
    environment.systemPackages = [ pkgs.windowlab ];
  };
}
