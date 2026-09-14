{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

let
  cfg = config.services.otelite;
in
{
  meta.maintainers = [ lib.maintainers.zatevakhin ];

  options.services.otelite = {
    enable = lib.mkEnableOption "Otelite OpenTelemetry receiver and dashboard";

    package = lib.mkPackageOption pkgs "otelite" { };

    address = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      example = "0.0.0.0";
      description = "Address on which the dashboard, API, and OTLP receivers listen.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 3000;
      description = "Port on which the dashboard and API listen.";
    };

    otlpGrpcPort = lib.mkOption {
      type = lib.types.port;
      default = 4317;
      description = "Port on which the OTLP gRPC receiver listens.";
    };

    otlpHttpPort = lib.mkOption {
      type = lib.types.port;
      default = 4318;
      description = "Port on which the OTLP HTTP receiver listens.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Open the dashboard and OTLP receiver ports in the firewall.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion =
          cfg.port != cfg.otlpGrpcPort
          && cfg.port != cfg.otlpHttpPort
          && cfg.otlpGrpcPort != cfg.otlpHttpPort;
        message = "services.otelite ports must be distinct";
      }
    ];

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [
      cfg.port
      cfg.otlpGrpcPort
      cfg.otlpHttpPort
    ];

    systemd.services.otelite = {
      description = "Otelite OpenTelemetry receiver and dashboard";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      environment = {
        HOME = "/var/lib/otelite";
        OTELITE_OTLP_GRPC_PORT = toString cfg.otlpGrpcPort;
        OTELITE_OTLP_HTTP_PORT = toString cfg.otlpHttpPort;
      };

      serviceConfig = {
        ExecStart = utils.escapeSystemdExecArgs [
          (lib.getExe cfg.package)
          "serve"
          "--addr"
          "${cfg.address}:${toString cfg.port}"
          "--storage-path"
          "/var/lib/otelite"
        ];
        DynamicUser = true;
        StateDirectory = "otelite";
        StateDirectoryMode = "0750";
        WorkingDirectory = "/var/lib/otelite";
        UMask = "0027";
        Restart = "on-failure";
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectHome = true;
        ProtectSystem = "strict";
      };
    };
  };
}
