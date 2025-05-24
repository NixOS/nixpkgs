{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.xserver.windowManager.afterstep;
in
{
  ###### interface
  options.services.xserver.windowManager.afterstep = {
    enable = lib.mkEnableOption "afterstep";
    package = lib.mkPackageOption pkgs "afterstep" { };
  };

  ###### implementation
  config = lib.mkIf cfg.enable {
    services.xserver.windowManager.session = lib.singleton {
      name = "afterstep";
      start = ''
        ${cfg.package}/bin/afterstep &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ cfg.package ];
  };
}
