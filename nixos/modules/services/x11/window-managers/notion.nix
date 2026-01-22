{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.xserver.windowManager.notion;
in

{
  options.services.xserver.windowManager.notion = {
    enable = lib.mkEnableOption "notion";
    package = lib.mkPackageOption pkgs "notion" { };
  };

  config = lib.mkIf cfg.enable {
    services.xserver.windowManager = {
      session = [
        {
          name = "notion";
          start = ''
            ${cfg.package}/bin/notion &
            waitPID=$!
          '';
        }
      ];
    };
    environment.systemPackages = [ cfg.package ];
  };
}
