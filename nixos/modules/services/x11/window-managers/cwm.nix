{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.xserver.windowManager.cwm;
in
{
  options = {
    services.xserver.windowManager.cwm.enable = lib.mkEnableOption "cwm";
  };
  config = lib.mkIf cfg.enable {
    services.xserver.windowManager.session = lib.singleton {
      name = "cwm";
      start = ''
        cwm &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ pkgs.cwm ];
  };
}
