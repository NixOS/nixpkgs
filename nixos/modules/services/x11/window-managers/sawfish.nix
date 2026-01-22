{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.xserver.windowManager.sawfish;
in
{
  ###### interface
  options.services.xserver.windowManager.sawfish = {
    enable = lib.mkEnableOption "sawfish";
    package = lib.mkPackageOption pkgs "sawfish" { };
  };

  ###### implementation
  config = lib.mkIf cfg.enable {
    services.xserver.windowManager.session = lib.singleton {
      name = "sawfish";
      start = ''
        ${cfg.package}/bin/sawfish &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ cfg.package ];
  };
}
