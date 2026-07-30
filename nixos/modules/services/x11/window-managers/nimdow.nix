{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.xserver.windowManager.nimdow;
in
{
  options = {
    services.xserver.windowManager.nimdow.enable = mkEnableOption "nimdow";
    services.xserver.windowManager.nimdow.package = mkPackageOption pkgs "nimdow" { };
  };

  config = mkIf cfg.enable {
    services.xserver.windowManager.session = singleton {
      name = "nimdow";
      start = ''
        ${cfg.package}/bin/nimdow &
        waitPID=$!
      '';
    };
    environment.systemPackages = [
      cfg.package
      pkgs.st
    ];
  };
}
