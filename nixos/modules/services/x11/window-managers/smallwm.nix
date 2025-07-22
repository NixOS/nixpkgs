{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.xserver.windowManager.smallwm;
in
{
  ###### interface
  options.services.xserver.windowManager.smallwm = {
    enable = lib.mkEnableOption "smallwm";
    package = lib.mkPackageOption pkgs "smallwm" { };
  };

  ###### implementation
  config = lib.mkIf cfg.enable {
    services.xserver.windowManager.session = lib.singleton {
      name = "smallwm";
      start = ''
        ${cfg.package}/bin/smallwm &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ cfg.package ];
  };
}
