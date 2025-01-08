{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.xserver.windowManager.hackedbox;
in
{
  ###### interface
  options = {
    services.xserver.windowManager.hackedbox.enable = lib.mkEnableOption "hackedbox";
  };

  ###### implementation
  config = lib.mkIf cfg.enable {
    services.xserver.windowManager.session = lib.singleton {
      name = "hackedbox";
      start = ''
        ${pkgs.hackedbox}/bin/hackedbox &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ pkgs.hackedbox ];
  };
}
