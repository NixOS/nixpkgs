{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.vector;
in
{
  options.services.vector = {
    enable = lib.mkEnableOption "Vector, a high-performance observability data pipeline";

    package = lib.mkPackageOption pkgs "vector" { };

    journaldAccess = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Enable Vector to access journald.
      '';
    };

    gracefulShutdownLimitSecs = lib.mkOption {
      type = lib.types.ints.positive;
      default = 60;
      description = ''
        Set the duration in seconds to wait for graceful shutdown after SIGINT or SIGTERM are received.
        After the duration has passed, Vector will force shutdown.
      '';
    };

    validateConfig = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Enable the checking of the vector config during build time. This should be disabled when interpolating environment variables.
      '';
    };

    settings = lib.mkOption {
      type = (pkgs.formats.json { }).type;
      default = { };
      description = ''
        Specify the configuration for Vector in Nix.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    # for cli usage
    environment.systemPackages = [ cfg.package ];

    systemd.services.vector = {
      description = "Vector event and log aggregator";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      requires = [ "network-online.target" ];
      serviceConfig =
        let
          format = pkgs.formats.toml { };
          conf = format.generate "vector.toml" cfg.settings;
          validatedConfig =
            file:
            pkgs.runCommand "validate-vector-conf"
              {
                nativeBuildInputs = [ cfg.package ];
              }
              ''
                vector validate --no-environment "${file}"
                ln -s "${file}" "$out"
              '';
        in
        {
          ExecStart = "${lib.getExe cfg.package} --config ${
            if cfg.validateConfig then (validatedConfig conf) else conf
          }  --graceful-shutdown-limit-secs ${builtins.toString cfg.gracefulShutdownLimitSecs}";
          DynamicUser = true;
          Restart = "always";
          StateDirectory = "vector";
          ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
          AmbientCapabilities = "CAP_NET_BIND_SERVICE";
          # This group is required for accessing journald.
          SupplementaryGroups = lib.mkIf cfg.journaldAccess "systemd-journal";
        };
      unitConfig = {
        StartLimitIntervalSec = 10;
        StartLimitBurst = 5;
      };
    };
  };
}
