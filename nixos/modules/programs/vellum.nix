{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.vellum;

  inherit (lib)
    getExe
    literalExpression
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    ;
  inherit (lib.types) separatedString;

  toml = pkgs.formats.toml { };
in
{
  options.programs.vellum = {
    enable = mkEnableOption "vellum, a live screen annotation overlay for Wayland";

    package = mkPackageOption pkgs "vellum" { };

    settings = mkOption {
      inherit (toml) type;
      default = { };
      description = ''
        Configuration options for vellum.
        See available options at <https://github.com/greyxp1/vellum/blob/master/docs/configuration.md>.
      '';
      example = literalExpression ''
        {
          default_tool = "arrow";
          remember_last_tool = false;
          feedback_duration_ms = 250;
        }
      '';
    };

    extraOptions = mkOption {
      type = separatedString " ";
      default = "";
      description = ''
        Extra command-line options to pass to
        the {command}`vellum` daemon.
      '';
      example = "--force-backend vulkan";
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
      restartTriggers = [ config.environment.etc."xdg/vellum/config.toml".source ];
      serviceConfig = {
        ExecStart = "${getExe cfg.package} ${cfg.extraOptions}";
        Restart = "on-failure";
      };
    };
  };

  meta = {
    maintainers = with lib.maintainers; [ poz ];
  };
}
