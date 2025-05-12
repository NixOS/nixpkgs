{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.xserver.windowManager.metacity;
in

{
  options.services.xserver.windowManager.metacity = {
    enable = lib.mkEnableOption "metacity";
    package = lib.mkPackageOption pkgs "metacity" { };
  };

  config = lib.mkIf cfg.enable {

    services.xserver.windowManager.session = lib.singleton {
      name = "metacity";
      start = ''
        ${cfg.package}/bin/metacity &
        waitPID=$!
      '';
    };

    environment.systemPackages = [ cfg.package ];

  };

}
