{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.xserver.windowManager.evilwm;
in
{
  ###### interface
  options.services.xserver.windowManager.evilwm = {
    enable = lib.mkEnableOption "evilwm";
    package = lib.mkPackageOption pkgs "evilwm" { };
  };

  ###### implementation
  config = lib.mkIf cfg.enable {
    services.xserver.windowManager.session = lib.singleton {
      name = "evilwm";
      start = ''
        ${cfg.package}/bin/evilwm &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ cfg.package ];
  };
}
