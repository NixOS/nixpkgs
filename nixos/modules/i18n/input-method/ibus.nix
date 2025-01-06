{ config, pkgs, lib, ... }:
let
  imcfg = config.i18n.inputMethod;
  cfg = imcfg.ibus;
  ibusPackage = pkgs.ibus-with-plugins.override { plugins = cfg.engines; };
  ibusEngine = lib.types.mkOptionType {
    name  = "ibus-engine";
    inherit (lib.types.package) descriptionClass merge;
    check = x: (lib.types.package.check x) && (lib.attrByPath ["meta" "isIbusEngine"] false x);
  };

  impanel = lib.optionalString (cfg.panel != null) "--panel=${cfg.panel}";

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
    (lib.mkRenamedOptionModule [ "programs" "ibus" "plugins" ] [ "i18n" "inputMethod" "ibus" "engines" ])
  ];

  options = {
    i18n.inputMethod.ibus = {
      engines = lib.mkOption {
        type    = with lib.types; listOf ibusEngine;
        default = [];
        example = lib.literalExpression "with pkgs.ibus-engines; [ mozc hangul ]";
        description =
          let
            enginesDrv = lib.filterAttrs (lib.const lib.isDerivation) pkgs.ibus-engines;
            engines = lib.concatStringsSep ", "
              (map (name: "`${name}`") (lib.attrNames enginesDrv));
          in "Enabled IBus engines. Available engines are: ${engines}.";
      };
      panel = lib.mkOption {
        type = with lib.types; nullOr path;
        default = null;
        example = lib.literalExpression ''"''${pkgs.plasma5Packages.plasma-desktop}/libexec/kimpanel-ibus-panel"'';
        description = "Replace the IBus panel with another panel.";
      };
    };
  };

  config = lib.mkIf (imcfg.enable && imcfg.type == "ibus") {
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

    xdg.portal.extraPortals = lib.mkIf config.xdg.portal.enable [
      ibusPackage
    ];
  };

  # uses attributes of the linked package
  meta.buildDocsInSandbox = false;
}
