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
      default = with pkgs.libsForQt5; [];
      defaultText = literalExpression ''
        with pkgs.libsForQt5; [];
      '';
      description = lib.mdDoc ''
        Extra packages that enhance Dolphin's functionality.

        This option reduces the clutter in environment.systemPackages, and also
        serves as the documentation for possible optional packages.
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
