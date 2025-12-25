{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.prometheus.exporters.qbittorrent;
  inherit (lib)
    mkOption
    mkPackageOption
    optionalAttrs
    ;
  inherit (lib.types)
    str
    path
    attrsOf
    nullOr
    ;
in
{
  port = 8090;

  extraOpts = {
    package = mkPackageOption pkgs "prometheus-qbittorrent-exporter" { };

    url = mkOption {
      type = nullOr str;
      default = "http://localhost:8080";
      description = ''
        Url where qBittorrent is running.
      '';
    };

    username = mkOption {
      type = nullOr str;
      default = "admin";
      description = ''
        qBittorrent username.
      '';
    };

    environment = mkOption {
      type = attrsOf str;
      default = { };
      description = ''
        All available environment variables can be found in the
        [`README.md`](https://github.com/martabal/qbittorrent-exporter?tab=readme-ov-file#environment-variables).

        Some variables can also be set through the module options:

        - `EXPORTER_PORT` via `port`
        - `QBITTORRENT_BASE_URL` via `url`
        - `QBITTORRENT_USERNAME` via `username`
        - `QBITTORRENT_PASSWORD_FILE` via `passwordFile`
      '';
      example = {
        EXPORTER_PATH = "/metrics2";
        QBITTORRENT_TIMEOUT = "10";
        ENABLE_TRACKER = "true";
        ENABLE_INCREASED_CARDINALITY = "true";
      };
    };

    passwordFile = mkOption {
      type = nullOr path;
      description = ''
        Path to a file containing the qBittorrent password. Systemd's
        LoadCredential functionality will make it accessible to the service.
      '';
    };
  };

  serviceOpts = {
    serviceConfig = {
      ExecStart = "${cfg.package}/bin/qbit-exp";
      LoadCredential = lib.mkIf (cfg.passwordFile != null) "qbitPass:${cfg.passwordFile}";
    };
    environment = {
      EXPORTER_PORT = toString cfg.port;
    }
    // optionalAttrs (cfg.url != null) {
      QBITTORRENT_BASE_URL = cfg.url;
    }
    // optionalAttrs (cfg.username != null) {
      QBITTORRENT_USERNAME = cfg.username;
    }
    // optionalAttrs (cfg.passwordFile != null) {
      QBITTORRENT_PASSWORD_FILE = "%d/qbitPass";
    }
    // cfg.environment;
  }
  // optionalAttrs config.services.qbittorrent.enable {
    after = [ "qbittorrent.service" ];
    requires = [ "qbittorrent.service" ];
  };
}
