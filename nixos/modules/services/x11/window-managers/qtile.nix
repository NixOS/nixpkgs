{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.services.xserver.windowManager.qtile;
in

{
  imports = [
    (mkRemovedOptionModule [
      "services"
      "xserver"
      "windowManager"
      "qtile"
      "backend"
    ] "The qtile package now provides separate display sessions for both X11 and Wayland.")
  ];

  options.services.xserver.windowManager.qtile = {
    enable = mkEnableOption "qtile";

    package = mkPackageOption pkgs [ "python3" "pkgs" "qtile" ] { };

    configFile = mkOption {
      type = with types; nullOr path;
      default = null;
      example = literalExpression "./your_config.py";
      description = ''
        Path to the qtile configuration file.
        If null, $XDG_CONFIG_HOME/qtile/config.py will be used.
      '';
    };

    extraPackages = mkOption {
      type = types.functionTo (types.listOf types.package);
      default = _: [ ];
      defaultText = literalExpression ''
        python3Packages: with python3Packages; [];
      '';
      description = ''
        Extra Python packages available to Qtile.
        An example would be to include `python3Packages.qtile-extras`
        for additional unofficial widgets.
      '';
      example = literalExpression ''
        python3Packages: with python3Packages; [
          qtile-extras
        ];
      '';
    };

    finalPackage = mkOption {
      type = types.package;
      visible = false;
      readOnly = true;
      description = "The resulting Qtile package, bundled with extra packages";
    };
  };

  config = mkIf cfg.enable {
    services = {
      xserver.windowManager.qtile.finalPackage = cfg.package.override {
        extraPackages = cfg.extraPackages cfg.package.pythonModule.pkgs;
      };

      displayManager.sessionPackages = [ cfg.finalPackage ];

      # Recommended by upstream for libqtile/widget/imapwidget.py
      gnome.gnome-keyring.enable = lib.mkDefault true;
    };

    environment = {
      etc."xdg/qtile/config.py" = mkIf (cfg.configFile != null) { source = cfg.configFile; };
      systemPackages = [ cfg.finalPackage ];
    };
  };
}
