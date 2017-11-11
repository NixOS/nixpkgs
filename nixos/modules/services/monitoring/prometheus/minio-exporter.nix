{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.prometheus.minioExporter;
in {
  options = {
    services.prometheus.minioExporter = {
      enable = mkEnableOption "prometheus minio exporter";

      port = mkOption {
        type = types.int;
        default = 9290;
        description = ''
          Port to listen on.
        '';
      };

      listenAddress = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "0.0.0.0";
        description = ''
          Address to listen on for web interface and telemetry.
        '';
      };

      minioAddress = mkOption {
        type = types.str;
        example = "https://10.0.0.1:9000";
        default = if config.services.minio.enable then "http://localhost:9000" else null;
        description = ''
          The URL of the minio server.
          Use HTTPS if Minio accepts secure connections only.
          By default this connects to the local minio server if enabled.
        '';
      };

      minioAccessKey = mkOption ({
        type = types.str;
        example = "BKIKJAA5BMMU2RHO6IBB";
        description = ''
          The value of the Minio access key.
          It is required in order to connect to the server.
          By default this uses the one from the local minio server if enabled
          and <literal>config.services.minio.accessKey</literal>.
        '';
      } // optionalAttrs (config.services.minio.enable && config.services.minio.accessKey != "") {
        default = config.services.minio.accessKey;
      });

      minioAccessSecret = mkOption ({
        type = types.str;
        description = ''
          The calue of the Minio access secret.
          It is required in order to connect to the server.
          By default this uses the one from the local minio server if enabled
          and <literal>config.services.minio.secretKey</literal>.
        '';
      } // optionalAttrs (config.services.minio.enable && config.services.minio.secretKey != "") {
        default = config.services.minio.secretKey;
      });

      minioBucketStats = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Collect statistics about the buckets and files in buckets.
          It requires more computation, use it carefully in case of large buckets..
        '';
      };

      extraFlags = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          Extra commandline options when launching the minio exporter.
        '';
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Open port in firewall for incoming connections.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = optional cfg.openFirewall cfg.port;

    systemd.services.prometheus-minio-exporter = {
      description = "Prometheus exporter for Minio server metrics";
      unitConfig.Documentation = "https://github.com/joe-pll/minio-exporter";
      wantedBy = [ "multi-user.target" ];
      after = optional config.services.minio.enable "minio.service";
      serviceConfig = {
        DynamicUser = true;
        Restart = "always";
        PrivateTmp = true;
        WorkingDirectory = /tmp;
        ExecStart = ''
          ${pkgs.prometheus-minio-exporter}/bin/minio-exporter \
            -web.listen-address ${optionalString (cfg.listenAddress != null) cfg.listenAddress}:${toString cfg.port} \
            -minio.server ${cfg.minioAddress} \
            -minio.access-key ${cfg.minioAccessKey} \
            -minio.access-secret ${cfg.minioAccessSecret} \
            ${optionalString cfg.minioBucketStats "-minio.bucket-stats"} \
            ${concatStringsSep " \\\n  " cfg.extraFlags}
        '';
      };
    };
  };
}
