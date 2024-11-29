{ config, pkgs, lib, ... }:

let
  inherit (lib) mkOption types;
  cfg = config.services.nar-serve;
in
{
  meta = {
    maintainers = with lib.maintainers; [ rizary zimbatm ];
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
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.nar-serve = {
      description = "NAR server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment.PORT = toString cfg.port;
      environment.NAR_CACHE_URL = cfg.cacheURL;

      serviceConfig = {
        Restart = "always";
        RestartSec = "5s";
        ExecStart = lib.getExe cfg.package;
        DynamicUser = true;
      };
    };
  };
}
