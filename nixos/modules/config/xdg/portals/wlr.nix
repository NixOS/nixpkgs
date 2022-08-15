{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.xdg.portal.wlr;
  package = pkgs.xdg-desktop-portal-wlr;
  settingsFormat = pkgs.formats.ini { };
  configFile = settingsFormat.generate "xdg-desktop-portal-wlr.ini" cfg.settings;
in
{
  meta = {
    maintainers = with maintainers; [ minijackson ];
  };

  options.xdg.portal.wlr = {
    enable = mkEnableOption ''
      desktop portal for wlroots-based desktops

      This will add the <literal>xdg-desktop-portal-wlr</literal> package into
      the <option>xdg.portal.extraPortals</option> option, and provide the
      configuration file
    '';

    settings = mkOption {
      description = lib.mdDoc ''
        Configuration for `xdg-desktop-portal-wlr`.

        See `xdg-desktop-portal-wlr(5)` for supported
        values.
      '';

      type = types.submodule {
        freeformType = settingsFormat.type;
      };

      default = { };

      # Example taken from the manpage
      example = literalExpression ''
        {
          screencast = {
            output_name = "HDMI-A-1";
            max_fps = 30;
            exec_before = "disable_notifications.sh";
            exec_after = "enable_notifications.sh";
            chooser_type = "simple";
            chooser_cmd = "''${pkgs.slurp}/bin/slurp -f %o -or";
          };
        }
      '';
    };
  };

  config = mkIf cfg.enable {
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
