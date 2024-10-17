{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.xdg.portal.termfilechooser;
  settingsFormat = pkgs.formats.ini { };
  configFile = settingsFormat.generate "xdg-desktop-portal-termfilechooser.ini" cfg.settings;
in
{
  meta = {
    maintainers = [ lib.maintainers.soispha ];
  };

  options.xdg.portal.termfilechooser = {
    enable = (lib.mkEnableOption "") // {
      description = ''
        Whether to enable the Termfilechooser desktop portal.

        ::: {.warning}
        Beware that this option only generates the systemd service and the config file.
        It does not enable the module for your wm/de of choice, as this is not possible.
        Refer to the code below, to enable this portal, replacing `my-wm` with
        your wm/de name.
        :::

        ```nix
        xdg.portal.config = {
          my-wm = {
            "org.freedesktop.impl.portal.FileChooser" = ["xdg-desktop-portal-termfilechooser"];
          };
        };
        ```
      '';
    };

    package = lib.mkPackageOption pkgs "xdg-desktop-portal-termfilechooser" {
      extraDescription = ''
        If you would like to use a fork of the portal, add it here.
      '';
    };

    logLevel = lib.mkOption {
      description = ''
        Which log level to use
      '';
      type = lib.types.enum [
        "QUIET"
        "ERROR"
        "WARN"
        "INFO"
        "DEBUG"
        "TRACE"
      ];
      default = "ERROR";
    };

    settings = lib.mkOption {
      description = ''
        Configuration for `xdg-desktop-portal-termfilechooser`.

        See `xdg-desktop-portal-termfilechooser(5)` for supported values.
      '';
      type = lib.types.submodule { freeformType = settingsFormat.type; };
      default = { };
      # Example taken from the manpage
      example = lib.literalExpression ''
        {
          filechooser = {
            # Beware that the script will be executed from a systemd service, thus, none
            # of your enviroment variables will be set including PATH
            cmd = ./your/command/ranger-wrapper.sh;
            default_dir = "/tmp";
          };
        }
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    xdg.portal = {
      enable = true;
      extraPortals = [ cfg.package ];
    };

    environment.etc."xdg/xdg-desktop-portal-termfilechooser/config".source = configFile;

    systemd.user.services.xdg-desktop-portal-termfilechooser = {
      serviceConfig.ExecStart = [
        ""
        "${cfg.package}/libexec/xdg-desktop-portal-termfilechooser --loglevel=${cfg.logLevel}"
      ];
    };
  };
}
