{ config, pkgs, lib, generators, ... }:
with lib;
let
  cfg = config.i18n.inputMethod.kime;
in
{
  options = {
    i18n.inputMethod.kime = {
      daemonModules = mkOption {
        type = types.listOf types.enum [ "Xim" "Wayland" "Indicator" ];
        default = [ "Xim" "Wayland" "Indicator" ];
        example = literalExpression ''[ "Xim" "Indicator" ]'';
        description = lib.mdDoc ''
          List of daemon modules
        '';
      };
      iconColor = mkOption {
        type = types.enum [ "Black" "White" ];
        default = "Black";
        example = "White";
        description = lib.mdDoc ''
          Set icon color for indicator
        '';
      };
      extraConfig = mkOption {
        type = types.string;
        description = lib.mdDoc ''
          extra kime configuration. Refer to <https://github.com/Riey/kime/blob/v${pkgs.kime.version}/docs/CONFIGURATION.md> for details on supported values.
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

    environment.etc."xdg/kime/config.yaml".text = ''
      daemon:
        modules: [${lib.concatStringSeq "," cfg.daemonModules}]
      indicator:
        icon_color: ${cfg.iconColor}
    '' ++ cfg.extraConfig;
  };

  # uses attributes of the linked package
  meta.buildDocsInSandbox = false;
}
