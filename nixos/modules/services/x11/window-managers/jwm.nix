{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.xserver.windowManager.jwm;
in
{
  ###### interface
  options = {
    services.xserver.windowManager.jwm.enable = lib.mkEnableOption "jwm";
  };

  ###### implementation
  config = lib.mkIf cfg.enable {
    services.xserver.windowManager.session = lib.singleton {
      name = "jwm";
      start = ''
        ${pkgs.jwm}/bin/jwm &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ pkgs.jwm ];
  };
}
