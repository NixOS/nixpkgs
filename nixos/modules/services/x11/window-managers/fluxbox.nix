{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.xserver.windowManager.fluxbox;
in
{
  ###### interface
  options = {
    services.xserver.windowManager.fluxbox.enable = lib.mkEnableOption "fluxbox";
  };

  ###### implementation
  config = lib.mkIf cfg.enable {
    services.xserver.windowManager.session = lib.singleton {
      name = "fluxbox";
      start = ''
        ${pkgs.fluxbox}/bin/startfluxbox &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ pkgs.fluxbox ];
  };
}
