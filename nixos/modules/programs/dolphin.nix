{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.programs.dolphin;

  # This is needed to select the Breeze theme
  dolphin-stylized = pkgs.writeShellScriptBin "dolphin" ''
    export QT_STYLE_OVERRIDE="${cfg.style}"
    exec ${pkgs.libsForQt5.dolphin}/bin/dolphin
  '';
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

    style = mkOption {
      type = types.str;
      default = "breeze";
      example = "breeze";
      description = mdDoc ''
        Set the style for Dolphin.

        This option should be used with `stylePackages` together.
      '';
    };

    stylePackages = mkOption {
      type = with types; listOf package;
      default = with pkgs.libsForQt5; [
          breeze-qt5
          breeze-icons
      ];
      defaultText = literalExpression ''
        with pkgs.libsForQt5; [
          breeze-qt5
          breeze-icons
        ];
      '';
      description = mdDoc ''
        Style packages for Dolphin.

        This option should be used with `style` together.
      '';
      example = literalExpression ''
        with pkgs.libsForQt5; [
          breeze-qt5
          breeze-icons
        ];
      '';
    };

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

      systemPackages = with pkgs; with libsForQt5; [
        dolphin-stylized
        konsole # for terminal panel
      ] ++ cfg.extraPackages
      ++ cfg.stylePackages;
    };

    services = {
      udisks2.enable = true; # for mounting hard drives
    };

  };
}
