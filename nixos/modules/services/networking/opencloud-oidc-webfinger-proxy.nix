{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.services.opencloudOidcWebfingerProxy;
in
{
  options.services.opencloudOidcWebfingerProxy = {
    enable = lib.mkEnableOption "opencloud-oidc-webfinger-proxy service";

    package = lib.mkOption {
      type = lib.types.package;
      defaultText = "pkgs.opencloud-oidc-webfinger-proxy";
      default = pkgs.callPackage /path/to/opencloud-oidc-webfinger-proxy.nix { };
      description = "The package to use for the WebFinger proxy.";
    };

    listenPort = lib.mkOption {
      type = lib.types.int;
      default = 9210;
      description = "Port on which the proxy listens.";
    };

    upstreamUrl = lib.mkOption {
      type = lib.types.str;
      example = "https://cloud.domain.com";
      description = "Base URL of the real WebFinger endpoint (including schema)";
    };

    hrefPattern = lib.mkOption {
      type = lib.types.str;
      default = "";
      example = "https://auth.domain.com/application/o/";
      description = "The part of the href URL to be matched and replaced";
    };

    hrefReplacement = lib.mkOption {
      type = lib.types.str;
      default = "";
      example = "https://auth.domain.com/application/o/";
      description = "The base part to replace the matched pattern with";
    };

    defaultSuffix = lib.mkOption {
      type = lib.types.str;
      default = "opencloud";
      example = "opencloud";
      description = "Default issuer suffix when none is provided via header";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.opencloudOidcWebfingerProxy = {
      description = "OpenCloud OIDC WebFinger Proxy";
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Environment = [
          "PORT=${toString cfg.listenPort}"
          "UPSTREAM_URL=${cfg.upstreamUrl}"
          "HREF_PATTERN=${cfg.hrefPattern}"
          "HREF_REPLACEMENT=${cfg.hrefReplacement}"
          "DEFAULT_SUFFIX=${cfg.defaultSuffix}"
        ];
        ExecStart = "${cfg.package}/bin/opencloud-oidc-webfinger-proxy";
        Restart = "on-failure";
      };
    };
  };
  meta.maintainers = with lib.maintainers; [ hajoha ];
}
