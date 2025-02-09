{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.hardware.gkraken;
in
{
  options.hardware.gkraken = {
    enable = mkEnableOption (lib.mdDoc "gkraken's udev rules for NZXT AIO liquid coolers");
  };

  config = mkIf cfg.enable {
    services.udev.packages = with pkgs; [
      gkraken
    ];
  };
}
