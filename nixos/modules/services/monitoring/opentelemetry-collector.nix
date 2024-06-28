{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkPackageOption mkIf mkOption types getExe;

  cfg = config.services.opentelemetry-collector;
  opentelemetry-collector = cfg.package;

  settingsFormat = pkgs.formats.yaml {};

  # configFiles contains a list of all config files.
  # If this list is empty, we know no config files have been set by the user.
  configFiles =
    if cfg.configFile == null
    then cfg.configFiles
    else [cfg.configFile];

  # If the list above is empty, then generate a config.yaml from cfg.settings.
  paths =
    if builtins.length configFiles == 0
    then [(settingsFormat.generate "config.yaml" cfg.settings)]
    else configFiles;

  # Map all paths to `--config=file:` syntax.
  serviceArgs = builtins.concatMap (path: "--config=file:${path} ") paths;
in {
  options.services.opentelemetry-collector = {
    enable = mkEnableOption "Opentelemetry Collector";

    package = mkPackageOption pkgs "opentelemetry-collector" { };

    settings = mkOption {
      type = settingsFormat.type;
      default = {};
      description = ''
        Specify the configuration for Opentelemetry Collector in Nix.

        See https://opentelemetry.io/docs/collector/configuration/ for available options.
      '';
    };

    configFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Specify a single path to a configuration file that Opentelemetry Collector should use.
      '';
    };

    configFiles = mkOption {
      type = types.listOf types.path;
      default = [];
      description = ''
        Specify one or more paths to configuration files that Opentelemetry Collector should use.
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions = [{
      assertion = (
        (cfg.settings == {}) != (builtins.length configFiles == 0)
      );
      message = ''
        Please specify a configuration for Opentelemetry Collector with either
        services.opentelemetry-collector.settings or
        services.opentelemetry-collector.configFile(s).
      '';
    }];

    systemd.services.opentelemetry-collector = {
      description = "Opentelemetry Collector Service Daemon";
      wantedBy = [ "multi-user.target" ];

      serviceConfig =
      {
        ExecStart = "${getExe opentelemetry-collector} ${serviceArgs}";
        DynamicUser = true;
        Restart = "always";
        ProtectSystem = "full";
        DevicePolicy = "closed";
        NoNewPrivileges = true;
        WorkingDirectory = "/var/lib/opentelemetry-collector";
        StateDirectory = "opentelemetry-collector";
      };
    };
  };
}
