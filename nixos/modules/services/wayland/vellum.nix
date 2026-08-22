{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.vellum;

  inherit (lib)
    getExe
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    ;

  toml = pkgs.formats.toml { };
in
{
  options.services.vellum = {
    enable = mkEnableOption "vellum, a live screen annotation overlay for Wayland";

    package = mkPackageOption pkgs "vellum" { };

    settings = mkOption {
      inherit (toml) type;
      default = { };
      description = ''
        Configuration options for vellum.
        See available options at <https://github.com/greyxp1/vellum/blob/master/docs/configuration.md>.
      '';
      example = {
        default_tool = "arrow";
        remember_last_tool = false;
        default_fill_shapes = true;
        feedback_duration_ms = 250;
        tools.pen.opacity = 0.75;
        palette = [
          "#FF6B6B"
          "#FFD93D"
          "#6BCB77"
          "#4D96FF"
          "#845EC2"
        ];
      };
    };
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = [ cfg.package ];

      etc."xdg/vellum/config.toml" = mkIf (cfg.settings != { }) {
        source = toml.generate "vellum-config.toml" cfg.settings;
      };
    };

    systemd.user.services.vellum = {
      description = "Vellum screen annotation overlay";
      after = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];
      restartTriggers = [ "/etc/xdg/vellum/config.toml" ];
      serviceConfig = {
        ExecStart = getExe cfg.package;
        Restart = "on-failure";
      };
    };
  };

  meta = {
    maintainers = with lib.maintainers; [ poz ];
  };
}
