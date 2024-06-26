{ config, lib, pkgs, ... }:

with lib;

let cfg = config.hardware.spacenavd;

in {

  options = {
    hardware.spacenavd = {
      enable = mkEnableOption "spacenavd to support 3DConnexion devices";
    };
  };

  config = mkIf cfg.enable {
    systemd.packages = [pkgs.spacenavd];
    systemd.services.spacenavd.enable = true;
  };
}
