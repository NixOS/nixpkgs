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
  options.services.xserver.windowManager.openbox = {
    enable = lib.mkEnableOption "openbox";
    package = lib.mkPackageOption pkgs "openbox" { };
  };

  config = lib.mkIf cfg.enable {
    services.xserver.windowManager = {
      session = [
        {
          name = "openbox";
          start = "${cfg.package}/bin/openbox-session";
        }
      ];
    };
    environment.systemPackages = [ cfg.package ];
  };
}
