{ lib, pkgs, config, ...}:
with lib;

{
  options = {
    hardware.video.high-dpi.enable = mkEnableOption "Font/DPI configuration optimized for High-DPI displays";
  };
  config = mkIf config.hardware.video.high-dpi.enable {
    console.font = mkDefault
      "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";

    # Needed when typing in passwords for full disk encryption
    console.earlySetup = mkDefault true;
    boot.loader.systemd-boot.consoleMode = mkDefault "max";

    services.xserver.dpi = mkDefault 196;
    fonts.fontconfig.dpi = mkDefault 196;
    environment.variables = mkDefault {
      GDK_SCALE = "2";
      GDK_DPI_SCALE = "0.5";
      _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
    };
  };
}
