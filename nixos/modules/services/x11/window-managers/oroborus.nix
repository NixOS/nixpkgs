{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.windowManager.oroborus;
in
{
  ###### interface
  options = {
    services.xserver.windowManager.oroborus.enable = mkEnableOption (lib.mdDoc "oroborus");
  };

  ###### implementation
  config = mkIf cfg.enable {
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
