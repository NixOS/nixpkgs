{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.xserver.windowManager.dusk;
in
{
  ###### interface
  options = {
    services.xserver.windowManager.dusk = {
      enable = mkEnableOption "dusk";

      package = mkPackageOption pkgs "dusk" { };
    };
  };

  ###### implementation
  config = mkIf cfg.enable {
    services.xserver.windowManager.session = singleton {
      name = "dusk";
      start = ''
        export _JAVA_AWT_WM_NONREPARENTING=1
        ${cfg.package}/bin/dusk &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ cfg.package ];
  };
}
