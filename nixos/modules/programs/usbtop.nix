{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.programs.usbtop;
in {
  options = {
    programs.usbtop.enable = mkEnableOption (lib.mdDoc "usbtop and required kernel module");
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      usbtop
    ];

    boot.kernelModules = [
      "usbmon"
    ];
  };
}
