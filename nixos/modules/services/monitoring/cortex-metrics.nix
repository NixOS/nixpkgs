{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    escapeShellArgs
    mkEnableOption
    mkPackageOption
    mkIf
    mkOption
    types
    ;

  cfg = config.services.cortex-metrics;

  settingsFormat = pkgs.formats.yaml { };
in
{
  options.services.cortex-metrics = {
    enable = mkEnableOption "cortex-metrics";

    configuration = mkOption {
      type = (pkgs.formats.json { }).type;
      default = { };
      description = ''
        Specify the configuration for cortex-metrics in Nix.
      '';
    };

    configFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Specify a configuration file that cortex-metrics should use.
      '';
    };

    package = mkPackageOption pkgs "cortex-metrics" { };

    extraFlags = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "--config.expand-env=true" ];
      description = ''
        Specify a list of additional command line flags,
        which get escaped and are then passed to cortex-metrics.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    assertions = [
      {
        assertion = (
          (cfg.configuration == { } -> cfg.configFile != null)
          && (cfg.configFile != null -> cfg.configuration == { })
        );
        message = ''
          Please specify either
          'services.cortex-metrics.configuration' or
          'services.cortex-metrics.configFile'.
        '';
      }
    ];

    systemd.services.cortex-metrics = {
      description = "cortex-metrics Service Daemon";
      wantedBy = [ "multi-user.target" ];

      serviceConfig =
        let
          conf =
            if cfg.configFile == null then
              settingsFormat.generate "config.yaml" cfg.configuration
            else
              cfg.configFile;
        in
        {
          ExecStart = "${cfg.package}/bin/cortex-metrics --config.file=${conf} ${escapeShellArgs cfg.extraFlags}";
          DynamicUser = true;
          Restart = "always";
          ProtectSystem = "full";
          DevicePolicy = "closed";
          NoNewPrivileges = true;
          WorkingDirectory = "/var/lib/cortex-metrics";
          StateDirectory = "cortex-metrics";
        };
    };
  };
}
