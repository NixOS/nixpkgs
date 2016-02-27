{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.i18n.inputMethod.ibus;
  ibusPackage = pkgs.ibus-with-plugins.override { plugins = cfg.engines; };
  ibusEngine = types.package // {
    name  = "ibus-engine";
    check = x: (lib.types.package.check x) && (attrByPath ["meta" "isIbusEngine"] false x);
  };

  ibusAutostart = pkgs.writeTextFile {
    name = "autostart-ibus-daemon";
    destination = "/etc/xdg/autostart/ibus-daemon.desktop";
    text = ''
      [Desktop Entry]
      Name=IBus
      Type=Application
      Exec=${ibusPackage}/bin/ibus-daemon -dx
    '';
  };
in
{
  options = {
    i18n.inputMethod.ibus = {
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

  config = mkIf (config.i18n.inputMethod.enabled == "ibus") {
    # Without dconf enabled it is impossible to use IBus
    environment.systemPackages = with pkgs; [
      ibusPackage ibus-qt gnome3.dconf ibusAutostart
    ];

    environment.variables = {
      GTK_IM_MODULE = "ibus";
      QT_IM_MODULE = "ibus";
      XMODIFIERS = "@im=ibus";
    };
  };
}
