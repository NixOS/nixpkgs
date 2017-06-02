{ config, lib, pkgs, ... }:

with lib;

let
  wmcfg = config.services.xserver.windowManager;
in

{
  options = {
    services.xserver.windowManager.select = mkOption {
      type = with types; listOf (enum [ "clfswm" ]);
    };
  };

  config = mkIf (elem "clfswm" wmcfg.select) {
    services.xserver.windowManager.session = singleton {
      name = "clfswm";
      start = ''
        ${pkgs.clfswm}/bin/clfswm &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ pkgs.clfswm ];
  };
}
