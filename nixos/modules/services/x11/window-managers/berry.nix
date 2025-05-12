{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.xserver.windowManager.berry;
in
{
  ###### interface
  options.services.xserver.windowManager.berry = {
    enable = lib.mkEnableOption "berry";
    package = lib.mkPackageOption pkgs "berry" { };
  };

  ###### implementation
  config = lib.mkIf cfg.enable {
    services.xserver.windowManager.session = lib.singleton {
      name = "berry";
      start = ''
        ${cfg.package}/bin/berry &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ cfg.package ];
  };
}
