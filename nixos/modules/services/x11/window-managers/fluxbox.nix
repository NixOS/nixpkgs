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
  options.services.xserver.windowManager.fluxbox = {
    enable = lib.mkEnableOption "fluxbox";
    package = lib.mkPackageOption pkgs "fluxbox" { };
  };

  ###### implementation
  config = lib.mkIf cfg.enable {
    services.xserver.windowManager.session = lib.singleton {
      name = "fluxbox";
      start = ''
        ${cfg.package}/bin/startfluxbox &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ cfg.package ];
  };
}
