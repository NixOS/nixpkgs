{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.opentelemetry-collector;
  opentelemetry-collector = cfg.package;

  settingsFormat = pkgs.formats.yaml { };
in
{
  options.services.opentelemetry-collector = {
    enable = lib.mkEnableOption "Opentelemetry Collector";

    package = lib.mkPackageOption pkgs "opentelemetry-collector" { };

    settings = lib.mkOption {
      type = settingsFormat.type;
      default = { };
      description = ''
        Specify the configuration for Opentelemetry Collector in Nix.

        See https://opentelemetry.io/docs/collector/configuration/ for available options.
      '';
    };

    configFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Specify a path to a configuration file that Opentelemetry Collector should use.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = ((cfg.settings == { }) != (cfg.configFile == null));
        message = ''
          Please specify a configuration for Opentelemetry Collector with either
          'services.opentelemetry-collector.settings' or
          'services.opentelemetry-collector.configFile'.
        '';
      }
    ];

    systemd.services.opentelemetry-collector = {
      description = "Opentelemetry Collector Service Daemon";
      wantedBy = [ "multi-user.target" ];

      serviceConfig =
        let
          conf =
            if cfg.configFile == null then
              settingsFormat.generate "config.yaml" cfg.settings
            else
              cfg.configFile;
        in
        {
          ExecStart = "${lib.getExe opentelemetry-collector} --config=file:${conf}";
          DynamicUser = true;
          Restart = "always";
          ProtectSystem = "full";
          DevicePolicy = "closed";
          NoNewPrivileges = true;
          WorkingDirectory = "%S/opentelemetry-collector";
          StateDirectory = "opentelemetry-collector";
          SupplementaryGroups = [
            # allow to read the systemd journal for opentelemetry-collector
            "systemd-journal"
          ];
        };
    };
  };
}
