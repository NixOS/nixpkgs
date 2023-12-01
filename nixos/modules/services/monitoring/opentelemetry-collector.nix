{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkPackageOption mkIf mkOption types getExe;

  cfg = config.services.opentelemetry-collector;
  opentelemetry-collector = cfg.package;

  settingsFormat = pkgs.formats.yaml {};
in {
  options.services.opentelemetry-collector = {
    enable = mkEnableOption (lib.mdDoc "Opentelemetry Collector");

    package = mkPackageOption pkgs "opentelemetry-collector" { };

    settings = mkOption {
      type = settingsFormat.type;
      default = {};
      description = lib.mdDoc ''
        Specify the configuration for Opentelemetry Collector in Nix.

        See https://opentelemetry.io/docs/collector/configuration/ for available options.
      '';
    };

    configFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = lib.mdDoc ''
        Specify a path to a configuration file that Opentelemetry Collector should use.
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions = [{
      assertion = (
        (cfg.settings == {}) != (cfg.configFile == null)
      );
      message  = ''
        Please specify a configuration for Opentelemetry Collector with either
        'services.opentelemetry-collector.settings' or
        'services.opentelemetry-collector.configFile'.
      '';
    }];

    systemd.services.opentelemetry-collector = {
      description = "Opentelemetry Collector Service Daemon";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = let
        conf = if cfg.configFile == null
               then settingsFormat.generate "config.yaml" cfg.settings
               else cfg.configFile;
      in
      {
        ExecStart = "${getExe opentelemetry-collector} --config=file:${conf}";
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
