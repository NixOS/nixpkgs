{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.xdg.portal.wlr;
  package = pkgs.xdg-desktop-portal-wlr;
  settingsFormat = pkgs.formats.ini { };
  configFile = settingsFormat.generate "xdg-desktop-portal-wlr.ini" cfg.settings;
in
{
  meta = {
    maintainers = with lib.maintainers; [ minijackson ];
  };

  options.xdg.portal.wlr = {
    enable = lib.mkEnableOption ''
      desktop portal for wlroots-based desktops.

      This will add the `xdg-desktop-portal-wlr` package into
      the {option}`xdg.portal.extraPortals` option, and provide the
      configuration file
    '';

    settings = lib.mkOption {
      description = ''
        Configuration for `xdg-desktop-portal-wlr`.

        See {manpage}`xdg-desktop-portal-wlr(5)` for supported
        values.
      '';

      type = lib.types.submodule {
        freeformType = settingsFormat.type;
      };

      default = { };

      # Example taken from the manpage
      example = lib.literalExpression ''
        {
          screencast = {
            output_name = "HDMI-A-1";
            max_fps = 30;
            exec_before = "disable_notifications.sh";
            exec_after = "enable_notifications.sh";
            chooser_type = "simple";
            chooser_cmd = "''${pkgs.slurp}/bin/slurp -f 'Monitor: %o' -or";
          };
        }
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    xdg.portal = {
      enable = true;
      extraPortals = [ package ];
    };

    systemd.user.services.xdg-desktop-portal-wlr.serviceConfig.ExecStart = [
      # Empty ExecStart value to override the field
      ""
      "${package}/libexec/xdg-desktop-portal-wlr --config=${configFile}"
    ];
  };
}
