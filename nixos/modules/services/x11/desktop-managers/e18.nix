{ config, pkgs, ... }:

with pkgs.lib;

let

  xcfg = config.services.xserver;
  cfg = xcfg.desktopManager.e18;

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
      pkgs.e18.efl pkgs.e18.evas pkgs.e18.emotion pkgs.e18.elementary pkgs.e18.enlightenment
      pkgs.e18.terminology pkgs.e18.econnman
    ];

    services.xserver.desktopManager.session = [
    { name = "E18";
      start = ''
        ${pkgs.e18.enlightenment}/bin/enlightenment_start
        waitPID=$!
      '';
    }];

  };

}
