{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.services.xserver.windowManager."2bwm";

in

{

  ###### interface

  options = {
    services.xserver.windowManager."2bwm".enable = lib.mkEnableOption "2bwm";
  };

  ###### implementation

  config = lib.mkIf cfg.enable {

    services.xserver.windowManager.session = lib.singleton {
      name = "2bwm";
      start = ''
        ${pkgs._2bwm}/bin/2bwm &
        waitPID=$!
      '';
    };

    environment.systemPackages = [ pkgs._2bwm ];

  };

}
