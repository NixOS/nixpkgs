{
  config,
  lib,
  pkgs,
  ...
}:

let

  cfg = config.services.xserver.windowManager.sxwm;

in

{

  ###### interface

  options = {
    services.xserver.windowManager.sxwm.enable = lib.mkEnableOption "sxwm";
  };

  ###### implementation

  config = lib.mkIf cfg.enable {

    services.xserver.windowManager.session = lib.singleton {
      name = "sxwm";
      start = ''
        ${pkgs.sxwm}/bin/sxwm &
        waitPID=$!
      '';
    };

    environment.systemPackages = [ pkgs.sxwm ];

  };

}
