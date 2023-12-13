{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.windowManager.clfswm;
in

{
  options = {
    services.xserver.windowManager.clfswm = {
      enable = mkEnableOption (lib.mdDoc "clfswm");
      package = mkPackageOption pkgs [ "lispPackages" "clfswm" ] { };
    };
  };

  config = mkIf cfg.enable {
    services.xserver.windowManager.session = singleton {
      name = "clfswm";
      start = ''
        ${cfg.package}/bin/clfswm &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ cfg.package ];
  };
}
