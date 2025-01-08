{
  config,
  lib,
  pkgs,
  options,
  ...
}:

let
  cfg = config.services.prometheus.exporters.sabnzbd;
in
{
  port = 9387;

  extraOpts = {
    servers = lib.mkOption {
      description = "List of sabnzbd servers to connect to.";
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            baseUrl = lib.mkOption {
              type = lib.types.str;
              description = "Base URL of the sabnzbd server.";
              example = "http://localhost:8080/sabnzbd";
            };
            apiKeyFile = lib.mkOption {
              type = lib.types.str;
              description = ''
                The path to a file containing the API key.
                The file is securely passed to the service by leveraging systemd credentials.
                No special permissions need to be set on this file.
              '';
              example = "/run/secrets/sabnzbd_apikey";
            };
          };
        }
      );
    };
  };

  serviceOpts =
    let
      servers = lib.zipAttrs cfg.servers;
      credentials = lib.imap0 (i: v: {
        name = "apikey-${toString i}";
        path = v;
      }) servers.apiKeyFile;
    in
    {
      serviceConfig.LoadCredential = builtins.map ({ name, path }: "${name}:${path}") credentials;

      environment = {
        METRICS_PORT = toString cfg.port;
        METRICS_ADDR = cfg.listenAddress;
        SABNZBD_BASEURLS = lib.concatStringsSep "," servers.baseUrl;
      };

      script =
        let
          apiKeys = lib.concatStringsSep "," (
            builtins.map (cred: "$(< $CREDENTIALS_DIRECTORY/${cred.name})") credentials
          );
        in
        ''
          export SABNZBD_APIKEYS="${apiKeys}"
          exec ${lib.getExe pkgs.prometheus-sabnzbd-exporter}
        '';
    };
}
