{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.openobserve;

  # Typed options win over any raw ZO_* keys in `settings`.
  environment = cfg.settings // {
    ZO_DATA_DIR = "/var/lib/openobserve";
    ZO_HTTP_ADDR = cfg.listenAddress;
    ZO_HTTP_PORT = cfg.port;
  };
in

{
  meta.maintainers = [ lib.maintainers.kashw2 ];

  options.services.openobserve = {
    enable = lib.mkEnableOption "OpenObserve, a cloud-native observability platform";

    package = lib.mkPackageOption pkgs "openobserve" { };

    listenAddress = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      example = "0.0.0.0";
      description = "Address on which the HTTP server listens (sets `ZO_HTTP_ADDR`).";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 5080;
      description = "Port on which the HTTP server listens (sets `ZO_HTTP_PORT`).";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to open the firewall for {option}`services.openobserve.port`.";
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/run/secrets/openobserve.env";
      description = ''
        Environment file (see {manpage}`systemd.exec(5)`) passed to the service.
        Use this to provide secrets such as `ZO_ROOT_USER_EMAIL` and
        `ZO_ROOT_USER_PASSWORD` without putting them into the world-readable Nix
        store.
      '';
    };

    settings = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.oneOf [
          lib.types.str
          lib.types.int
          lib.types.bool
        ]
      );
      default = { };
      example = lib.literalExpression ''
        {
          ZO_TELEMETRY = false;
          ZO_COMPACT_DATA_RETENTION_DAYS = 30;
        }
      '';
      description = ''
        Configuration for OpenObserve, expressed as `ZO_*` environment
        variables. See <https://openobserve.ai/docs/environment-variables/>
        for the full list of options.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion =
          cfg.environmentFile != null
          || (cfg.settings ? ZO_ROOT_USER_EMAIL && cfg.settings ? ZO_ROOT_USER_PASSWORD);
        message = ''
          services.openobserve requires a root user to be configured on first
          boot. Set `ZO_ROOT_USER_EMAIL` and `ZO_ROOT_USER_PASSWORD` via
          `services.openobserve.environmentFile`  or `services.openobserve.settings`.
        '';
      }
    ];

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };

    systemd.services.openobserve = {
      description = "OpenObserve observability platform";
      wantedBy = [ "multi-user.target" ];

      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];

      # Ensures booleans are rendered as literals instead of stringified if specified as strings
      environment = lib.mapAttrs (
        _name: value: if lib.isBool value then lib.boolToString value else toString value
      ) environment;

      serviceConfig = {
        ExecStart = lib.getExe cfg.package;
        EnvironmentFile = lib.mkIf (cfg.environmentFile != null) [ cfg.environmentFile ];
        DynamicUser = true;
        StateDirectory = "openobserve";
        Restart = "on-failure";
        RestartSec = 5;
      };
    };
  };
}
