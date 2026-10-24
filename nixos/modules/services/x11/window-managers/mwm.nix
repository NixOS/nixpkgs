{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.xserver.windowManager.mwm;
in
{
  ###### interface
  options.services.xserver.windowManager.mwm = {
    enable = lib.mkEnableOption "mwm";
    package = lib.mkPackageOption pkgs "motif" { };
  };

  ###### implementation
  config = lib.mkIf cfg.enable {
    services.xserver.windowManager.session = lib.singleton {
      name = "mwm";
      start = ''
        ${cfg.package}/bin/mwm &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ cfg.package ];
  };
}
