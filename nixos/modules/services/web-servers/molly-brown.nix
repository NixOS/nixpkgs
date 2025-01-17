{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.molly-brown;
  settingsFormat = pkgs.formats.toml { };
  configFile = settingsFormat.generate "molly-brown.toml" cfg.settings;
in
{

  options.services.molly-brown = {

    enable = mkEnableOption "Molly-Brown Gemini server";

    port = mkOption {
      default = 1965;
      type = types.port;
      description = ''
        TCP port for molly-brown to bind to.
      '';
    };

    hostName = mkOption {
      type = types.str;
      default = config.networking.hostName;
      defaultText = literalExpression "config.networking.hostName";
      description = ''
        The hostname to respond to requests for. Requests for URLs with
        other hosts will result in a status 53 (PROXY REQUEST REFUSED)
        response.
      '';
    };

    certPath = mkOption {
      type = types.path;
      example = "/var/lib/acme/example.com/cert.pem";
      description = ''
        Path to TLS certificate. An ACME certificate and key may be
        shared with an HTTP server, but only if molly-brown has
        permissions allowing it to read such keys.

        As an example:
        ```
        systemd.services.molly-brown.serviceConfig.SupplementaryGroups =
          [ config.security.acme.certs."example.com".group ];
        ```
      '';
    };

    keyPath = mkOption {
      type = types.path;
      example = "/var/lib/acme/example.com/key.pem";
      description = "Path to TLS key. See {option}`CertPath`.";
    };

    docBase = mkOption {
      type = types.path;
      example = "/var/lib/molly-brown";
      description = "Base directory for Gemini content.";
    };

    settings = mkOption {
      inherit (settingsFormat) type;
      default = { };
      description = ''
        molly-brown configuration. Refer to
        <https://tildegit.org/solderpunk/molly-brown/src/branch/master/example.conf>
        for details on supported values.
      '';
    };

  };

  config = mkIf cfg.enable {

    services.molly-brown.settings =
      let
        logDir = "/var/log/molly-brown";
      in
      {
        Port = cfg.port;
        Hostname = cfg.hostName;
        CertPath = cfg.certPath;
        KeyPath = cfg.keyPath;
        DocBase = cfg.docBase;
        AccessLog = "${logDir}/access.log";
        ErrorLog = "${logDir}/error.log";
      };

    systemd.services.molly-brown = {
      description = "Molly Brown gemini server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        DynamicUser = true;
        LogsDirectory = "molly-brown";
        ExecStart = "${pkgs.molly-brown}/bin/molly-brown -c ${configFile}";
        Restart = "always";
      };
    };

  };

}
