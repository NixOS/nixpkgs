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
  options.services.xserver.windowManager.hackedbox = {
    enable = lib.mkEnableOption "hackedbox";
    package = lib.mkPackageOption pkgs "hackedbox" { };
  };

  ###### implementation
  config = lib.mkIf cfg.enable {
    services.xserver.windowManager.session = lib.singleton {
      name = "hackedbox";
      start = ''
        ${cfg.package}/bin/hackedbox &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ cfg.package ];
  };
}
