{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.xserver.windowManager.yeahwm;
in
{
  ###### interface
  options.services.xserver.windowManager.yeahwm = {
    enable = lib.mkEnableOption "yeahwm";
    package = lib.mkPackageOption pkgs "yeahwm" { };
  };

  ###### implementation
  config = lib.mkIf cfg.enable {
    services.xserver.windowManager.session = lib.singleton {
      name = "yeahwm";
      start = ''
        ${cfg.package}/bin/yeahwm &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ cfg.package ];
  };
}
