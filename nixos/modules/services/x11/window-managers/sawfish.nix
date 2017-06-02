{ config, lib, pkgs, ... }:

with lib;

let
  wmcfg = config.services.xserver.windowManager;
in
{
  ###### interface
  options = {
    services.xserver.windowManager.select = mkOption {
      type = with types; listOf (enum [ "sawfish" ]);
    };
  };

  ###### implementation
  config = mkIf (elem "sawfish" wmcfg.select) {
    services.xserver.windowManager.session = singleton {
      name = "sawfish";
      start = ''
        ${pkgs.sawfish}/bin/sawfish &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ pkgs.sawfish ];
  };
}
