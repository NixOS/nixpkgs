{ config
, pkgs
, lib
, ...
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
    enable = lib.mkEnableOption ''
      Termfilechooser desktop portal

      This will add the `xdg-desktop-portal-termfilechooser` package into
      the {option}`xdg.portal.extraPortals` option, and provide the
      configuration file
    '';

    package = lib.mkPackageOption pkgs "xdg-desktop-portal-termfilechooser" {
      extraDescription = ''
        If you would like to use a fork of the portal, add it here.
      '';
    };

    logLevel = lib.mkOption {
      description = ''
        Which log level to use
      '';
      type = lib.types.enum [ "QUIET" "ERROR" "WARN" "INFO" "DEBUG" "TRACE" ];
      default = "ERROR";
    };

    settings = lib.mkOption {
      description = ''
        Configuration for `xdg-desktop-portal-termfilechooser`.

        See `xdg-desktop-portal-termfilechooser(5)` for supported values.
      '';
      type = lib.types.submodule {
        freeformType = settingsFormat.type;
      };
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

    systemd.user.services.xdg-desktop-portal-termfilechooser = {
      overrideStrategy = "asDropinIfExists";

      serviceConfig.ExecStart = [
        ""
        "${cfg.package}/libexec/xdg-desktop-portal-termfilechooser --config=${configFile} --loglevel=${cfg.logLevel}"
      ];
    };
  };
}
