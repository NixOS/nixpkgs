{ config, lib, pkgs, ... }:

with lib;

let
  wmcfg = config.services.xserver.windowManager;
in
{
  ###### interface
  options = {
    services.xserver.windowManager.select = mkOption {
      type = with types; listOf (enum [ "oroborus" ]);
    };
  };

  ###### implementation
  config = mkIf (elem "oroborus" wmcfg.select) {
    services.xserver.windowManager.session = singleton {
      name = "oroborus";
      start = ''
        ${pkgs.oroborus}/bin/oroborus &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ pkgs.oroborus ];
  };
}
