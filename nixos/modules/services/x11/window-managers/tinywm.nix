{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.xserver.windowManager.tinywm;
in
{
  ###### interface
  options = {
    services.xserver.windowManager.tinywm.enable = lib.mkEnableOption "tinywm";
  };

  ###### implementation
  config = lib.mkIf cfg.enable {
    services.xserver.windowManager.session = lib.singleton {
      name = "tinywm";
      start = ''
        ${pkgs.tinywm}/bin/tinywm &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ pkgs.tinywm ];
  };
}
