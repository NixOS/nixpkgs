{ config, lib, pkgs, ... }:

with lib;

let
  wmcfg = config.services.xserver.windowManager;
in
{
  ###### interface
  options = {
    services.xserver.windowManager.select = mkOption {
      type = with types; listOf (enum [ "jwm" ]);
    };
  };

  ###### implementation
  config = mkIf (elem "jwm" wmcfg.select) {
    services.xserver.windowManager.session = singleton {
      name = "jwm";
      start = ''
        ${pkgs.jwm}/bin/jwm &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ pkgs.jwm ];
  };
}
