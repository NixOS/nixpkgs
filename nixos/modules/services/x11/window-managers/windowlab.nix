{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.services.xserver.windowManager.windowlab;
in

{
  options.services.xserver.windowManager.windowlab = {
    enable = lib.mkEnableOption "windowlab";
    package = lib.mkPackageOption pkgs "windowlab" { };
  };

  config = lib.mkIf cfg.enable {
    services.xserver.windowManager = {
      session = [
        {
          name = "windowlab";
          start = "${cfg.package}/bin/windowlab";
        }
      ];
    };
    environment.systemPackages = [ cfg.package ];
  };
}
