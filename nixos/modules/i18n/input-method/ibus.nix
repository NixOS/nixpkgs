{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.i18n.inputMethod.ibus;
  ibusPackage = pkgs.ibus-with-plugins.override { plugins = cfg.engines; };
  ibusEngine = types.package // {
    name  = "ibus-engine";
    check = x: (lib.types.package.check x) && (attrByPath ["meta" "isIbusEngine"] false x);
  };

  impanel =
    if cfg.panel != null
    then "--panel=${cfg.panel}"
    else "";

  ibusAutostart = pkgs.writeTextFile {
    name = "autostart-ibus-daemon";
    destination = "/etc/xdg/autostart/ibus-daemon.desktop";
    text = ''
      [Desktop Entry]
      Name=IBus
      Type=Application
      Exec=${ibusPackage}/bin/ibus-daemon --daemonize --xim ${impanel}
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
        description =
          let
            enginesDrv = filterAttrs (const isDerivation) pkgs.ibus-engines;
            engines = concatStringsSep ", "
              (map (name: "<literal>${name}</literal>") (attrNames enginesDrv));
          in
            "Enabled IBus engines. Available engines are: ${engines}.";
      };
      panel = mkOption {
        type = with types; nullOr path;
        default = null;
        example = literalExample "''${pkgs.plasma5.plasma-desktop}/lib/libexec/kimpanel-ibus-panel";
        description = "Replace the IBus panel with another panel.";
      };
    };
  };

  config = mkIf (config.i18n.inputMethod.enabled == "ibus") {
    i18n.inputMethod.package = ibusPackage;

    # Without dconf enabled it is impossible to use IBus
    environment.systemPackages = with pkgs; [
      ibus-qt gnome3.dconf ibusAutostart
    ];

    environment.variables = {
      GTK_IM_MODULE = "ibus";
      QT_IM_MODULE = "ibus";
      XMODIFIERS = "@im=ibus";
    };
  };
}
