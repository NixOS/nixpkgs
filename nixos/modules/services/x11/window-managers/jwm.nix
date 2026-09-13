{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.xserver.windowManager.jwm;
in
{
  ###### interface
  options.services.xserver.windowManager.jwm = {
    enable = lib.mkEnableOption "jwm";
    package = lib.mkPackageOption pkgs "jwm" { };
  };

  ###### implementation
  config = lib.mkIf cfg.enable {
    services.xserver.windowManager.session = lib.singleton {
      name = "jwm";
      start = ''
        ${cfg.package}/bin/jwm &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ cfg.package ];
  };
}
