{
  config,
  pkgs,
  lib,
  generators,
  ...
}:
let
  imcfg = config.i18n.inputMethod;
in
{
  imports = [
    (lib.mkRemovedOptionModule [
      "i18n"
      "inputMethod"
      "kime"
      "config"
    ] "Use i18n.inputMethod.kime.* instead")
  ];

  options.i18n.inputMethod.kime = {
    daemonModules = lib.mkOption {
      type = lib.types.listOf (
        lib.types.enum [
          "Xim"
          "Wayland"
          "Indicator"
        ]
      );
      default = [
        "Xim"
        "Wayland"
        "Indicator"
      ];
      example = [
        "Xim"
        "Indicator"
      ];
      description = ''
        List of enabled daemon modules
      '';
    };
    iconColor = lib.mkOption {
      type = lib.types.enum [
        "Black"
        "White"
      ];
      default = "Black";
      example = "White";
      description = ''
        Color of the indicator icon
      '';
    };
    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = ''
        extra kime configuration. Refer to <https://github.com/Riey/kime/blob/v${pkgs.kime.version}/docs/CONFIGURATION.md> for details on supported values.
      '';
    };
  };

  config = lib.mkIf (imcfg.enable && imcfg.type == "kime") {
    i18n.inputMethod.package = pkgs.kime;

    environment.variables = {
      GTK_IM_MODULE = "kime";
      QT_IM_MODULE = "kime";
      XMODIFIERS = "@im=kime";
    };

    environment.etc."xdg/kime/config.yaml".text =
      ''
        daemon:
          modules: [${lib.concatStringsSep "," imcfg.kime.daemonModules}]
        indicator:
          icon_color: ${imcfg.kime.iconColor}
      ''
      + imcfg.kime.extraConfig;
  };

  # uses attributes of the linked package
  meta.buildDocsInSandbox = false;
}
