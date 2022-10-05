{ lib, pkgs, config, ...}:
with lib;

{
  options.hardware.video.hidpi.enable = mkEnableOption (lib.mdDoc "Font/DPI configuration optimized for HiDPI displays");

  config = mkIf config.hardware.video.hidpi.enable {
    console.font = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-v32n.psf.gz";

    # Needed when typing in passwords for full disk encryption
    console.earlySetup = mkDefault true;
    boot.loader.systemd-boot.consoleMode = mkDefault "1";


    # Disable font anti-aliasing & sub-pixel rendering by default
    fonts.fontconfig.antialias = mkDefault false;
    fonts.fontconfig.subpixel = {
      rgba = mkDefault "none";
      lcdfilter = mkDefault "none";
    };

    # TODO Find reasonable defaults X11 & wayland
  };
}
