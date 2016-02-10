{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.i18n.inputMethod.fcitx;
  fcitxPackage = pkgs.fcitx-with-plugins.override { plugins = cfg.engines; };
  fcitxEngine = types.package // {
    name  = "fcitx-engine";
    check = x: (lib.types.package.check x) && (attrByPath ["meta" "isFcitxEngine"] false x);
  };
in
{
  options = {

    i18n.inputMethod.fcitx = {
      enable = mkOption {
        type    = types.bool;
        default = false;
        example = true;
        description = ''
          Enable Fcitx input method.
          Fcitx can be used to input of Chinese, Korean, Japanese and other special characters.
        '';
      };
      engines = mkOption {
        type    = with types; listOf fcitxEngine;
        default = [];
        example = literalExample "with pkgs.fcitx-engines; [ mozc hangul ]";
        description = ''
          Enabled Fcitx engines.
          Available engines can be found by running `nix-env "&lt;nixpkgs&gt;" . -qaP -A fcitx-engines`.
        '';
      };
    };

  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ fcitxPackage ];
    gtkPlugins = [ fcitxPackage ];
    qtPlugins  = [ fcitxPackage ];

    environment.variables = {
      GTK_IM_MODULE = "fcitx";
      QT_IM_MODULE  = "fcitx";
      XMODIFIERS    = "@im=fcitx";
    };
    services.xserver.displayManager.sessionCommands = "${fcitxPackage}/bin/fcitx";
  };
}
