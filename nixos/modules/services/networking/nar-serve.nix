{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkOption types;
  cfg = config.services.nar-serve;
in
{
  meta = {
    maintainers = with lib.maintainers; [
      rizary
      zimbatm
    ];
  };
  options = {
    services.nar-serve = {
      enable = lib.mkEnableOption "serving NAR file contents via HTTP";

      package = lib.mkPackageOption pkgs "nar-serve" { };

      port = mkOption {
        type = types.port;
        default = 8383;
        description = ''
          Port number where nar-serve will listen on.
        '';
      };

      cacheURL = mkOption {
        type = types.str;
        default = "https://cache.nixos.org/";
        description = ''
          Binary cache URL to connect to.

          The URL format is compatible with the nix remote url style, such as:
          - http://, https:// for binary caches via HTTP or HTTPS
          - s3:// for binary caches stored in Amazon S3
          - gs:// for binary caches stored in Google Cloud Storage
        '';
      };

      domain = mkOption {
        type = types.str;
        default = "";
        description = ''
          When set, enables the feature of serving <nar-hash>.<domain>
          on top of <domain>/nix/store/<nar-hash>-<pname>.

          Useful to preview static websites where paths are absolute.
        '';
      };

      maxConcurrency = mkOption {
        type = types.ints.unsigned;
        default = 0;
        description = ''
          How many requests can walk an archive at the same time.

          Decompressing a NAR up to the wanted file is the whole cost of a
          request, thus this is what bounds the CPU use of the service.
          Requests over the limit wait for a free slot, they are not refused.

          Zero does not limit anything.
        '';
      };

      metricsAddress = mkOption {
        type = types.str;
        default = "";
        example = "127.0.0.1:9464";
        description = ''
          Address to serve Prometheus metrics from, as `host:port`.

          The metrics get their own listener, thus they can stay on an address
          that is not the one the service answers the world from.

          An empty string does not serve metrics.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.nar-serve = {
      description = "NAR server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment.PORT = toString cfg.port;
      environment.NAR_CACHE_URL = cfg.cacheURL;
      environment.DOMAIN = cfg.domain;
      environment.MAX_CONCURRENCY = toString cfg.maxConcurrency;
      environment.METRICS_ADDR = cfg.metricsAddress;

      serviceConfig = {
        Restart = "always";
        RestartSec = "5s";
        ExecStart = lib.getExe cfg.package;
        DynamicUser = true;
      };
    };
  };
}
