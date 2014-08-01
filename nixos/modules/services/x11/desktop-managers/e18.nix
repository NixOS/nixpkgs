{ config, pkgs, lib, ... }:

with lib;

let

  xcfg = config.services.xserver;
  cfg = xcfg.desktopManager.e18;
  e18_enlightenment = pkgs.e18.enlightenment.override { set_freqset_setuid = true; };

in

{
  options = {

    services.xserver.desktopManager.e18.enable = mkOption {
      default = false;
      example = true;
      description = "Enable the E18 desktop environment.";
    };

  };

  config = mkIf (xcfg.enable && cfg.enable) {

    environment.systemPackages = [
      pkgs.e18.efl pkgs.e18.evas pkgs.e18.emotion pkgs.e18.elementary e18_enlightenment
      pkgs.e18.terminology pkgs.e18.econnman
    ];

    services.xserver.desktopManager.session = [
    { name = "E18";
      start = ''
        ${e18_enlightenment}/bin/enlightenment_start
        waitPID=$!
      '';
    }];

    security.setuidPrograms = [ "e18_freqset" ];

  };

}
