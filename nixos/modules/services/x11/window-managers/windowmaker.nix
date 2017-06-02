{ config, lib, pkgs, ... }:

with lib;

let
  wmcfg = config.services.xserver.windowManager;
in
{
  ###### interface
  options = {
    services.xserver.windowManager.select = mkOption {
      type = with types; listOf (enum [ "windowmaker" ]);
    };
  };

  ###### implementation
  config = mkIf (elem "windowmaker" wmcfg.select) {
    services.xserver.windowManager.session = singleton {
      name = "windowmaker";
      start = ''
        ${pkgs.windowmaker}/bin/wmaker &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ pkgs.windowmaker ];
  };
}
