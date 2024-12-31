{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.xserver.windowManager.afterstep;
in
{
  ###### interface
  options = {
    services.xserver.windowManager.afterstep.enable = lib.mkEnableOption "afterstep";
  };

  ###### implementation
  config = lib.mkIf cfg.enable {
    services.xserver.windowManager.session = lib.singleton {
      name = "afterstep";
      start = ''
        ${pkgs.afterstep}/bin/afterstep &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ pkgs.afterstep ];
  };
}
