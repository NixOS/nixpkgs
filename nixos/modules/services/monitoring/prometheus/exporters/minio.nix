{ config, lib, pkgs, options }:

with lib;

let
  cfg = config.services.prometheus.exporters.minio;
in
{
  port = 9290;
  extraOpts = {
    minioAddress = mkOption {
      type = types.str;
      example = "https://10.0.0.1:9000";
      description = ''
        The URL of the minio server.
        Use HTTPS if Minio accepts secure connections only.
        By default this connects to the local minio server if enabled.
      '';
    };

    minioAccessKey = mkOption {
      type = types.str;
      example = "yourMinioAccessKey";
      description = ''
        The value of the Minio access key.
        It is required in order to connect to the server.
        By default this uses the one from the local minio server if enabled
        and <literal>config.services.minio.accessKey</literal>.
      '';
    };

    minioAccessSecret = mkOption {
      type = types.str;
      description = ''
        The value of the Minio access secret.
        It is required in order to connect to the server.
        By default this uses the one from the local minio server if enabled
        and <literal>config.services.minio.secretKey</literal>.
      '';
    };

    minioBucketStats = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Collect statistics about the buckets and files in buckets.
        It requires more computation, use it carefully in case of large buckets..
      '';
    };
  };
  serviceOpts = {
    serviceConfig = {
      ExecStart = ''
        ${pkgs.prometheus-minio-exporter}/bin/minio-exporter \
          -web.listen-address ${cfg.listenAddress}:${toString cfg.port} \
          -minio.server ${cfg.minioAddress} \
          -minio.access-key ${cfg.minioAccessKey} \
          -minio.access-secret ${cfg.minioAccessSecret} \
          ${optionalString cfg.minioBucketStats "-minio.bucket-stats"} \
          ${concatStringsSep " \\\n  " cfg.extraFlags}
      '';
    };
  };
}
