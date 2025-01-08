{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.xserver.windowManager.windowmaker;
in
{
  ###### interface
  options = {
    services.xserver.windowManager.windowmaker.enable = lib.mkEnableOption "windowmaker";
  };

  ###### implementation
  config = lib.mkIf cfg.enable {
    services.xserver.windowManager.session = lib.singleton {
      name = "windowmaker";
      start = ''
        ${pkgs.windowmaker}/bin/wmaker &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ pkgs.windowmaker ];
  };
}
