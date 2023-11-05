{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.programs.dolphin;

  dolphin-stylized = pkgs.libsForQt5.dolphin.overrideAttrs (finalAttrs: previousAttrs: {
    buildInputs = (previousAttrs.buildInputs or []) ++ [
      pkgs.libsForQt5.konsole # for terminal panel
    ] ++ cfg.extraPackages
    ++ cfg.stylePackages;

    nativeBuildInputs = (previousAttrs.nativeBuildInputs or []) ++ [
      pkgs.makeBinaryWrapper
    ];

    # This is needed to select the custom theme
    postInstall = ''
      wrapProgram $out/bin/dolphin --set-default QT_STYLE_OVERRIDE "${cfg.style}"
    '';
  });
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
      description = mdDoc ''
        Set the style for Dolphin.

        This option should be used together with {option}`stylePackages`.
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

        This option should be used together with {option}`style`.
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
    };
  };

  config = mkIf cfg.enable {

    environment.systemPackages = [
      dolphin-stylized
    ];

    # for mounting hard drives
    services.udisks2.enable = lib.mkDefault true;
  };
}
