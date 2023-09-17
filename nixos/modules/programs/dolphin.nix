{ config, pkgs, lib, ... }:

with lib;

{
  meta.maintainers = with maintainers; [ MakiseKurisu ];

  # interface
  options.programs.dolphin = {
    enable = mkEnableOption (mdDoc ''
      Dolphin, the KDE file manager.

      This option will install additional depencencies to mimic the experience
      of Dolphin in a normal KDE Plasma setup
    '');
  };

  # implementation
  config = mkIf config.programs.dolphin.enable {

    environment = {

      # This is needed to have Konsole colorscheme files available in Dolphin
      pathsToLink = [
        "/share/konsole"
      ];

      # This is needed to select the Breeze theme
      variables = {
        QT_STYLE_OVERRIDE = "breeze";
      };

      systemPackages = with pkgs.libsForQt5; [
        dolphin
        konsole # for terminal panel
        breeze-qt5 # for theme
        breeze-icons # for icons
      ];
    };

    services = {
      udisks2.enable = true; # for mounting hard drives
    };

  };
}
