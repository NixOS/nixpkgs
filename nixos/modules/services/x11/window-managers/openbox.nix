{lib, pkgs, config, ...}:

with lib;
let
  wmcfg = config.services.xserver.windowManager;
  cfg = wmcfg.openbox;
in

{
  config = mkIf (elem "openbox" wmcfg.enable) {
    services.xserver.windowManager = {
      session = [{
        name = "openbox";
        start = "
          ${pkgs.openbox}/bin/openbox-session
        ";
      }];
    };
    environment.systemPackages = [ pkgs.openbox ];
  };
}
