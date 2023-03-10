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
      # GNOME will launch ibus using systemd
      NotShowIn=GNOME;
    '';
  };
in
{
  imports = [
    (mkRenamedOptionModule [ "programs" "ibus" "plugins" ] [ "i18n" "inputMethod" "ibus" "engines" ])
  ];

  options = {
    i18n.inputMethod.ibus = {
      engines = mkOption {
        type    = with types; listOf ibusEngine;
        default = [];
        example = literalExpression "with pkgs.ibus-engines; [ mozc hangul ]";
        description =
          let
            enginesDrv = filterAttrs (const isDerivation) pkgs.ibus-engines;
            engines = concatStringsSep ", "
              (map (name: "`${name}`") (attrNames enginesDrv));
          in
            lib.mdDoc "Enabled IBus engines. Available engines are: ${engines}.";
      };
      panel = mkOption {
        type = with types; nullOr path;
        default = null;
        example = literalExpression ''"''${pkgs.plasma5Packages.plasma-desktop}/lib/libexec/kimpanel-ibus-panel"'';
        description = lib.mdDoc "Replace the IBus panel with another panel.";
      };
    };
  };

  config = mkIf (config.i18n.inputMethod.enabled == "ibus") {
    i18n.inputMethod.package = ibusPackage;

    environment.systemPackages = [
      ibusAutostart
    ];

    # Without dconf enabled it is impossible to use IBus
    programs.dconf.enable = true;

    programs.dconf.packages = [ ibusPackage ];

    services.dbus.packages = [
      ibusPackage
    ];

    environment.variables = {
      GTK_IM_MODULE = "ibus";
      QT_IM_MODULE = "ibus";
      XMODIFIERS = "@im=ibus";
    };

    xdg.portal.extraPortals = mkIf config.xdg.portal.enable [
      ibusPackage
    ];
  };

  # uses attributes of the linked package
  meta.buildDocsInSandbox = false;
}
