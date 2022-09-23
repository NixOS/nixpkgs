{ config, pkgs, lib, generators, ... }:
with lib;
let
  cfg = config.i18n.inputMethod.kime;
  yamlFormat = pkgs.formats.yaml { };
in
{
  options = {
    i18n.inputMethod.kime = {
      config = mkOption {
        type = yamlFormat.type;
        default = { };
        example = literalExpression ''
          {
            daemon = {
              modules = ["Xim" "Indicator"];
            };

            indicator = {
              icon_color = "White";
            };

            engine = {
              hangul = {
                layout = "dubeolsik";
              };
            };
          }
          '';
        description = lib.mdDoc ''
          kime configuration. Refer to <https://github.com/Riey/kime/blob/v${pkgs.kime.version}/docs/CONFIGURATION.md> for details on supported values.
        '';
      };
    };
  };

  config = mkIf (config.i18n.inputMethod.enabled == "kime") {
    i18n.inputMethod.package = pkgs.kime;

    environment.variables = {
      GTK_IM_MODULE = "kime";
      QT_IM_MODULE  = "kime";
      XMODIFIERS    = "@im=kime";
    };

    environment.etc."xdg/kime/config.yaml".text = replaceStrings [ "\\\\" ] [ "\\" ] (builtins.toJSON cfg.config);
  };

  # uses attributes of the linked package
  meta.buildDocsInSandbox = false;
}
