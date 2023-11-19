{ config, lib, pkgs, options }:

let
  inherit (lib) mkOption types;
  cfg = config.services.prometheus.exporters.sabnzbd;
in
{
  port = 9387;

  extraOpts = {
    servers = mkOption {
      description = "List of sabnzbd servers to connect to.";
      type = types.listOf (types.submodule {
        options = {
          baseUrl = mkOption {
            type = types.str;
            description = "Base URL of the sabnzbd server.";
            example = "http://localhost:8080/sabnzbd";
          };
          apiKeyFile = mkOption {
            type = types.str;
            description = "File containing the API key.";
            example = "/run/secrets/sabnzbd_apikey";
          };
        };
      });
    };
  };

  serviceOpts =
    let
      servers = lib.zipAttrs cfg.servers;
      apiKeys = lib.concatStringsSep "," (builtins.map (file: "$(cat ${file})") servers.apiKeyFile);
    in
    {
      environment = {
        METRICS_PORT = toString cfg.port;
        METRICS_ADDR = cfg.listenAddress;
        SABNZBD_BASEURLS = lib.concatStringsSep "," servers.baseUrl;
      };

      script = ''
        export SABNZBD_APIKEYS="${apiKeys}"
        exec ${lib.getExe pkgs.prometheus-sabnzbd-exporter}
      '';
    };
}
