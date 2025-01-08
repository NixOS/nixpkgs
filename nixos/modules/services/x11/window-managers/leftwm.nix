{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.xserver.windowManager.leftwm;
in
{
  ###### interface
  options = {
    services.xserver.windowManager.leftwm.enable = lib.mkEnableOption "leftwm";
  };

  ###### implementation
  config = lib.mkIf cfg.enable {
    services.xserver.windowManager.session = lib.singleton {
      name = "leftwm";
      start = ''
        ${pkgs.leftwm}/bin/leftwm &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ pkgs.leftwm ];
  };
}
