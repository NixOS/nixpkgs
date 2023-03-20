{ lib, pkgs, config, ...}:
with lib;

{
  options.hardware.video.hidpi.enable = mkEnableOption (lib.mdDoc "Font/DPI configuration optimized for HiDPI displays");

  config = mkIf config.hardware.video.hidpi.enable {
    console.font = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-v32n.psf.gz";

    # Needed when typing in passwords for full disk encryption
    console.earlySetup = mkDefault true;
    boot.loader.systemd-boot.consoleMode = mkDefault "1";


    # Disable font anti-aliasing, hinting, and sub-pixel rendering by default
    # See recommendations in fonts/fontconfig.nix
    fonts.fontconfig = {
      antialias = mkDefault false;
      hinting.enable = mkDefault false;
      subpixel.lcdfilter = mkDefault "none";
    };

    # TODO Find reasonable defaults X11 & wayland
  };
}
