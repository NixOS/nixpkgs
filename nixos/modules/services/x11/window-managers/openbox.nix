{lib, pkgs, config, ...}:

with lib;
let
  cfg = config.services.xserver.windowManager.openbox;
in

{
  options = {
    services.xserver.windowManager.openbox.enable = mkEnableOption "openbox";
  };

  config = mkIf cfg.enable {
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
