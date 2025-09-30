{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    types
    ;

  cfg = config.services.pgscv;

  settingsFormat = pkgs.formats.yaml { };
  configFile = settingsFormat.generate "config.yaml" cfg.settings;
in
{
  options.services.pgscv = {
    enable = mkEnableOption "pgSCV, a PostgreSQL ecosystem metrics collector";

    package = mkPackageOption pkgs "pgscv" { };

    logLevel = mkOption {
      type = types.enum [
        "debug"
        "info"
        "warn"
        "error"
      ];
      default = "info";
      description = "Log level for pgSCV.";
    };

    settings = mkOption {
      type = settingsFormat.type;
      default = { };
      description = ''
        Configuration for pgSCV, in YAML format.

        See [configuration reference](https://github.com/cherts/pgscv/wiki/Configuration-settings-reference).
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.pgscv = {
      description = "pgSCV - PostgreSQL ecosystem metrics collector";
      wantedBy = [ "multi-user.target" ];
      requires = [ "network-online.target" ];
      after = [ "network-online.target" ];
      path = [ pkgs.glibc ]; # shells out to getconf

      serviceConfig = {
        User = "postgres";
        Group = "postgres";
        ExecStart = utils.escapeSystemdExecArgs [
          (lib.getExe cfg.package)
          "--log-level=${cfg.logLevel}"
          "--config-file=${configFile}"
        ];
        KillMode = "control-group";
        TimeoutSec = 5;
        Restart = "on-failure";
        RestartSec = 10;
        OOMScoreAdjust = 1000;
      };
    };
  };
}
