{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.services.xserver.windowManager.openbox;
in

{
  options = {
    services.xserver.windowManager.openbox.enable = lib.mkEnableOption "openbox";
  };

  config = lib.mkIf cfg.enable {
    services.xserver.windowManager = {
      session = [
        {
          name = "openbox";
          start = "
          ${pkgs.openbox}/bin/openbox-session
        ";
        }
      ];
    };
    environment.systemPackages = [ pkgs.openbox ];
  };
}
