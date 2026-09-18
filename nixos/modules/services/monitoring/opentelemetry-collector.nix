{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkIf
    mkOption
    types
    getExe
    isStorePath
    literalMD
    escapeShellArgs
    ;

  cfg = config.services.opentelemetry-collector;
  opentelemetry-collector = cfg.package;

  settingsFormat = pkgs.formats.yaml { };
  generatedConf =
    if cfg.configFile == null then
      settingsFormat.generate "config.yaml" cfg.settings
    else
      cfg.configFile;
  conf =
    if cfg.validateConfigFile then
      pkgs.runCommandLocal "config.yaml" { inherit generatedConf; } ''
        cp $generatedConf $out
        ${getExe opentelemetry-collector} validate --config=file:$out \
          ${escapeShellArgs (map (o: "--set=${o}") cfg.validateConfigOverrides)}
      ''
    else
      generatedConf;
in
{
  options.services.opentelemetry-collector = {
    enable = mkEnableOption "Opentelemetry Collector";

    package = mkPackageOption pkgs "opentelemetry-collector" { };

    settings = mkOption {
      type = settingsFormat.type;
      default = { };
      description = ''
        Specify the configuration for Opentelemetry Collector in Nix.

        See <https://opentelemetry.io/docs/collector/configuration/> for available options.
      '';
    };

    configFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Specify a path to a configuration file that Opentelemetry Collector should use.
      '';
    };

    validateConfigFile = lib.mkEnableOption "Validate configuration file" // {
      defaultText = literalMD "`true` unless `configFile` is a path outside the store";
      default = cfg.configFile == null || isStorePath cfg.configFile;
    };

    validateConfigOverrides = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "extensions::bearertokenauth::token=stub" ];
      description = ''
        Property overrides passed to `otelcol validate` as `--set` arguments,
        used only for validation and not for the configuration that is
        deployed. Use this configuration option if you are relying on confmap
        providers like `''${file:/path}` and `''${env:VAR}` in your setup.

        Note: `::` separates path elements, because component names may
        themselves contain `.` and `/`.
      '';
    };
  };

  options.system.build.opentelemetryCollectorConfig = mkOption {
    type = types.path;
    readOnly = true;
    internal = true;
    description = ''
      The configuration file the service is started with, after validation.
      Exposed primarily so that tests can assert on it.
    '';
  };

  config = mkIf cfg.enable {
    system.build.opentelemetryCollectorConfig = conf;

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

      serviceConfig = {
        ExecStart = "${getExe opentelemetry-collector} --config=file:${conf}";
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
