{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.xserver.windowManager.berry;
in
{
  ###### interface
  options = {
    services.xserver.windowManager.berry.enable = lib.mkEnableOption "berry";
  };

  ###### implementation
  config = lib.mkIf cfg.enable {
    services.xserver.windowManager.session = lib.singleton {
      name = "berry";
      start = ''
        ${pkgs.berry}/bin/berry &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ pkgs.berry ];
  };
}
