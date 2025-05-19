{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let

  cfg = config.services.xserver.windowManager.sxwm;

in

{

  ###### interface

  options = {
    services.xserver.windowManager.sxwm.enable = mkEnableOption "sxwm";
  };

  ###### implementation

  config = mkIf cfg.enable {

    services.xserver.windowManager.session = singleton {
      name = "sxwm";
      start = ''
        ${pkgs.sxwm}/bin/sxwm &
        waitPID=$!
      '';
    };

    environment.systemPackages = [ pkgs.sxwm ];

  };

}
