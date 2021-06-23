{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.hardware.decklink;
  kernelPackages = config.boot.kernelPackages;
in
{
  options.hardware.decklink.enable = mkEnableOption "hardware support for the Blackmagic Design Decklink audio/video interfaces";

  config = mkIf cfg.enable {
    boot.kernelModules = [ "blackmagic" "blackmagic-io" "snd_blackmagic-io" ];
    boot.extraModulePackages = [ kernelPackages.decklink ];
    systemd.services.DecklinkVideoHelper = {
      after = [ "syslog.target" "local-fs.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig.ExecStart = "${pkgs.blackmagicDesktopVideo}/bin/DesktopVideoHelper -n";
    };
  };
}
