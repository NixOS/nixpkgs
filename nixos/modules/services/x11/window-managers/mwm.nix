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
  options = {
    services.xserver.windowManager.mwm.enable = lib.mkEnableOption "mwm";
  };

  ###### implementation
  config = lib.mkIf cfg.enable {
    services.xserver.windowManager.session = lib.singleton {
      name = "mwm";
      start = ''
        ${pkgs.motif}/bin/mwm &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ pkgs.motif ];
  };
}
