{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.programs.dolphin;
in
{
  meta.maintainers = with maintainers; [ MakiseKurisu ];

  # interface
  options.programs.dolphin = {
    enable = mkEnableOption (mdDoc ''
      Dolphin, the KDE file manager.

      This option will install additional depencencies to mimic the experience
      of Dolphin in a normal KDE Plasma setup
    '');

    extraPackages = mkOption {
      type = with types; listOf package;
      default = with pkgs.libsForQt5; [
        dolphin-plugins
        kio-extras
        kdegraphics-thumbnailers
      ];
      defaultText = literalExpression ''
        with pkgs.libsForQt5; [
          dolphin-plugins
          kio-extras
          kdegraphics-thumbnailers
        ];
      '';
      description = mdDoc ''
        Extra packages that enhance Dolphin's functionality.

        These packages are not strictly required to have dolphin basically work,
        but add useful features such as thumbnails, network/device filesystem
        access, and similar.
      '';
      example = literalExpression ''
        with pkgs.libsForQt5; [
          dolphin-plugins
          kio-extras
          kdegraphics-thumbnailers
        ];
      '';
    };
  };

  # implementation
  config = mkIf cfg.enable {

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
      ] ++ cfg.extraPackages;
    };

    services = {
      udisks2.enable = true; # for mounting hard drives
    };

  };
}
