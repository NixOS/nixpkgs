{ lib, pkgs, config, ...}:
with lib;

{
  options.hardware.video.hidpi.enable = mkEnableOption "Font/DPI configuration optimized for HiDPI displays";

  config = mkIf config.hardware.video.hidpi.enable {
    console.font = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-v32n.psf.gz";

    # Needed when typing in passwords for full disk encryption
    console.earlySetup = mkDefault true;
    boot.loader.systemd-boot.consoleMode = mkDefault "1";


    # Grayscale anti-aliasing for fonts
    fonts.fontconfig.antialias = mkDefault true;
    fonts.fontconfig.subpixel = {
      rgba = mkDefault "none";
      lcdfilter = mkDefault "none";
    };

    # TODO Find reasonable defaults X11 & wayland
  };
}
