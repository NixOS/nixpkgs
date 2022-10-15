{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.windowManager.leftwm;
in
{
  ###### interface
  options = {
    services.xserver.windowManager.leftwm.enable = mkEnableOption (lib.mdDoc "leftwm");
  };

  ###### implementation
  config = mkIf cfg.enable {
    services.xserver.windowManager.session = singleton {
      name = "leftwm";
      start = ''
        ${pkgs.leftwm}/bin/leftwm &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ pkgs.leftwm ];
  };
}
