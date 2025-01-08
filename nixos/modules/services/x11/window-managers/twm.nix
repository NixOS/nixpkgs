{
  config,
  lib,
  pkgs,
  ...
}:

let

  cfg = config.services.xserver.windowManager.twm;

in

{

  ###### interface

  options = {
    services.xserver.windowManager.twm.enable = lib.mkEnableOption "twm";
  };

  ###### implementation

  config = lib.mkIf cfg.enable {

    services.xserver.windowManager.session = lib.singleton {
      name = "twm";
      start = ''
        ${pkgs.xorg.twm}/bin/twm &
        waitPID=$!
      '';
    };

    environment.systemPackages = [ pkgs.xorg.twm ];

  };

}
