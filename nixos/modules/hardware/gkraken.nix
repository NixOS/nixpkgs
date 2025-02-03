{ config, lib, pkgs, ... }:
let
  cfg = config.hardware.gkraken;
in
{
  options.hardware.gkraken = {
    enable = lib.mkEnableOption "gkraken's udev rules for NZXT AIO liquid coolers";
  };

  config = lib.mkIf cfg.enable {
    services.udev.packages = with pkgs; [
      gkraken
    ];
  };
}
