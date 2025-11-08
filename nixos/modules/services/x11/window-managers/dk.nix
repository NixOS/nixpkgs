{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.xserver.windowManager.dk;
in

{
  options = {
    services.xserver.windowManager.dk = {
      enable = lib.mkEnableOption "dk";

      package = lib.mkPackageOption pkgs "dk" { };
    };
  };

  config = lib.mkIf cfg.enable {
    services.xserver.windowManager.session = lib.singleton {
      name = "dk";
      start = ''
        export _JAVA_AWT_WM_NONREPARENTING=1
        ${cfg.package}/bin/dk &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ cfg.package ];
  };
}
