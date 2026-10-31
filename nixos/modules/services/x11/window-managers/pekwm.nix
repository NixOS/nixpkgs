{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.xserver.windowManager.pekwm;
in
{
  ###### interface
  options.services.xserver.windowManager.pekwm = {
    enable = lib.mkEnableOption "pekwm";
    package = lib.mkPackageOption pkgs "pekwm" { };
  };

  ###### implementation
  config = lib.mkIf cfg.enable {
    services.xserver.windowManager.session = lib.singleton {
      name = "pekwm";
      start = ''
        ${cfg.package}/bin/pekwm &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ cfg.package ];
  };
}
