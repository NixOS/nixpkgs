{ config, lib, pkgs, ... }:

let
  cfg = config.hardware.decklink;
  kernelPackages = config.boot.kernelPackages;
in
{
  options.hardware.decklink.enable = lib.mkEnableOption "hardware support for the Blackmagic Design Decklink audio/video interfaces";

  config = lib.mkIf cfg.enable {
    boot.kernelModules = [ "blackmagic" "blackmagic-io" "snd_blackmagic-io" ];
    boot.extraModulePackages = [ kernelPackages.decklink ];
    systemd.packages = [ pkgs.blackmagic-desktop-video ];
    systemd.services.DesktopVideoHelper.wantedBy = [ "multi-user.target" ];
  };
}
