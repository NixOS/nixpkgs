{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.protonmail-bridge;
in
{
  options.services.protonmail-bridge = {
    enable = lib.mkEnableOption "protonmail bridge";

    package = lib.mkPackageOption pkgs "protonmail-bridge" { };

    path = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
      example = lib.literalExpression "with pkgs; [ pass gnome-keyring ]";
      description = "List of derivations to put in protonmail-bridge's path.";
    };

    logLevel = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "panic"
          "fatal"
          "error"
          "warn"
          "info"
          "debug"
        ]
      );
      default = null;
      description = "Log level of the Proton Mail Bridge service. If set to null then the service uses it's default log level.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.protonmail-bridge = {
      description = "protonmail bridge";
      wantedBy = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];

      serviceConfig =
        let
          logLevel = lib.optionalString (cfg.logLevel != null) "--log-level ${cfg.logLevel}";
        in
        {
          ExecStart = "${lib.getExe cfg.package} --noninteractive ${logLevel}";
          Restart = "always";
        };

      path = cfg.path;
    };
    environment.systemPackages = [ cfg.package ];
  };
  meta.maintainers = with lib.maintainers; [ mzacho ];
}
