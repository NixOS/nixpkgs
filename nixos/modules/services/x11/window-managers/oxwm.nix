{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.xserver.windowManager.oxwm;
in
{
  options.services.xserver.windowManager.oxwm = {
    enable = lib.mkEnableOption "oxwm";
    package = lib.mkPackageOption pkgs "oxwm" { };
  };

  config = lib.mkIf cfg.enable {
    services.displayManager.sessionPackages = [ cfg.package ];
    environment.systemPackages = [ cfg.package ];
    environment.pathsToLink = [
      "/share/oxwm"
      "/share/xsessions"
    ];
  };
}
