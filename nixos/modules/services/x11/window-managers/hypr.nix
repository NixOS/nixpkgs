{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.xserver.windowManager.hypr;
in
{
  ###### interface
  options.services.xserver.windowManager.hypr = {
    enable = lib.mkEnableOption "hypr";
    package = lib.mkPackageOption pkgs "hypr" { };
  };

  ###### implementation
  config = lib.mkIf cfg.enable {
    services.xserver.windowManager.session = lib.singleton {
      name = "hypr";
      start = ''
        ${cfg.package}/bin/Hypr &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ cfg.package ];
  };
}
