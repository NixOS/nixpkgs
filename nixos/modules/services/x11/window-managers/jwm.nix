{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.xserver.windowManager.jwm;
in
{
  ###### interface
  options = {
    services.xserver.windowManager.jwm.enable = mkEnableOption "jwm";
  };

  ###### implementation
  config = mkIf cfg.enable {
    services.xserver.windowManager.session = singleton {
      name = "jwm";
      start = ''
        ${pkgs.jwm}/bin/jwm &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ pkgs.jwm ];
  };
}
