{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.xserver.windowManager.e16;
in
{
  ###### interface
  options.services.xserver.windowManager.e16 = {
    enable = lib.mkEnableOption "e16";
    package = lib.mkPackageOption pkgs "e16" { };
  };

  ###### implementation
  config = lib.mkIf cfg.enable {
    services.xserver.windowManager.session = lib.singleton {
      name = "E16";
      start = ''
        ${cfg.package}/bin/e16 &
        waitPID=$!
      '';
    };

    environment.systemPackages = [ cfg.package ];
  };
}
