{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.windowManager.hackedbox;
in
{
  ###### interface
  options = {
    services.xserver.windowManager.hackedbox.enable = mkEnableOption "hackedbox";
  };

  ###### implementation
  config = mkIf cfg.enable {
    services.xserver.windowManager.session = singleton {
      name = "hackedbox";
      start = ''
        ${pkgs.hackedbox}/bin/hackedbox &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ pkgs.hackedbox ];
  };
}
