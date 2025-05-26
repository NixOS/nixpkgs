{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.xserver.windowManager.icewm;
in
{
  ###### interface
  options = {
    services.xserver.windowManager.icewm.enable = mkEnableOption "icewm";
  };

  ###### implementation
  config = mkIf cfg.enable {
    services.xserver.windowManager.session = singleton {
      name = "icewm";
      start = ''
        ${pkgs.icewm}/bin/icewm-session &
        waitPID=$!
      '';
    };

    environment.systemPackages = [ pkgs.icewm ];
  };
}
