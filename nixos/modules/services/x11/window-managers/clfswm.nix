{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.xserver.windowManager.clfswm;
in

{
  options = {
    services.xserver.windowManager.clfswm = {
      enable = lib.mkEnableOption "clfswm";
      package = lib.mkPackageOption pkgs [ "sbclPackages" "clfswm" ] { };
    };
  };

  config = lib.mkIf cfg.enable {
    services.xserver.windowManager.session = lib.singleton {
      name = "clfswm";
      start = ''
        ${cfg.package}/bin/clfswm &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ cfg.package ];
  };
}
