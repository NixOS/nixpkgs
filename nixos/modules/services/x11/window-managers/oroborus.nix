{ config, lib, pkgs, ... }:

with lib;

let
  wmcfg = config.services.xserver.windowManager;
  cfg = wmcfg.oroborus;
in
{
  ###### implementation
  config = mkIf (elem "oroborus" wmcfg.enable) {
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
