{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.hardware.decklink;
  kernelPackages = config.boot.kernelPackages;
in
{
  options.hardware.decklink.enable = lib.mkEnableOption "hardware support for the Blackmagic Design Decklink audio/video interfaces";

  config = lib.mkIf cfg.enable {
    # snd_blackmagic-io can cause issues with pipewire,
    # so we do not enable it by default
    boot.kernelModules = [
      "blackmagic"
      "blackmagic-io"
    ];
    boot.extraModulePackages = [ kernelPackages.decklink ];
    systemd.packages = [ pkgs.blackmagic-desktop-video ];
    systemd.services.DesktopVideoHelper.wantedBy = [ "multi-user.target" ];
  };
}
