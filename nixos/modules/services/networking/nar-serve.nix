{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.services.nar-serve;
in
{
  meta = {
    maintainers = [ maintainers.rizary maintainers.zimbatm ];
  };
  options = {
    services.nar-serve = {
      enable = mkEnableOption "serving NAR file contents via HTTP";

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
    };
  };

  config = mkIf cfg.enable {
    systemd.services.nar-serve = {
      description = "NAR server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment.PORT = toString cfg.port;
      environment.NAR_CACHE_URL = cfg.cacheURL;

      serviceConfig = {
        Restart = "always";
        RestartSec = "5s";
        ExecStart = "${pkgs.nar-serve}/bin/nar-serve";
        DynamicUser = true;
      };
    };
  };
}
