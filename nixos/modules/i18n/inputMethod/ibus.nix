{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.i18n.inputMethod.ibus;
  ibusPackage = pkgs.ibus-with-plugins.override { plugins = cfg.engines; };
  ibusEngine = types.package // {
    name  = "ibus-engine";
    check = x: (lib.types.package.check x) && (attrByPath ["meta" "isIbusEngine"] false x);
  };
in
{
  options = {
    i18n.inputMethod.ibus = {
      enable = mkOption {
        type    = types.bool;
        default = false;
        example = true;
        description = ''
          Enable IBus input method.
          IBus can be used input of Chinese, Korean, Japanese and other special characters.
        '';
      };
      engines = mkOption {
        type    = with types; listOf ibusEngine;
        default = [];
        example = literalExample "with pkgs.ibus-engines; [ mozc hangul ]";
        description = ''
          Enabled IBus engines.
          Available engines can be found by running `nix-env "&lt;nixpkgs&gt;" . -qaP -A ibus-engines`.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    # Without dconf enabled it is impossible to use IBus
    environment.systemPackages = [ ibusPackage pkgs.gnome3.dconf ];

    gtkPlugins = [ pkgs.ibus ];
    qtPlugins  = [ pkgs.ibus-qt ];

    environment.variables = {
      GTK_IM_MODULE = "ibus";
      QT_IM_MODULE = "ibus";
      XMODIFIERS = "@im=ibus";
    };

    services.xserver.displayManager.sessionCommands = "${ibusPackage}/bin/ibus-daemon --daemonize --xim --cache=none";
  };
}
