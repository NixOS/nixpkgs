{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.windowManager.wtftw;
in

{
  options = {
    services.xserver.windowManager.wtftw.enable = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = "Enable the wtftw window manager";
    };
  };

  config = mkIf cfg.enable {
    services.xserver.windowManager.session = singleton {
      name = "wtftw";
      start = "
        ${pkgs.wtftw}/bin/wtftw
      ";
    };
    environment.systemPackages = [ pkgs.wtftw ];
  };
}