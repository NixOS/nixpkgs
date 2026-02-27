{ config
, lib
, pkgs
, options
, ...
}:

let
  cfg = config.services.prometheus.exporters.adguard;
  inherit (lib)
    mkOption
    types
    mkRemovedOptionModule
    ;
in
{
  imports = [
    (mkRemovedOptionModule [ "interval" ] "This option has been removed.")
    {
      options.warnings = options.warnings;
      options.assertions = options.assertions;
    }
  ];

  port = 9618;
  extraOpts = {
    servers = mkOption {
      type = types.str;
      default = "http://127.0.0.1";
      example = "https://adguard.example.org";
      description = ''
        The servers you want the exporter to scrape. Must include the scheme http(s) and port if non-standard.
      '';
    };
    users = mkOption {
      type = types.str;
      default = "";
      example = "adguard";
      description = ''
        The username to connect to the adguard api with. Must be in the same order as servers if scraping multiple instances
      '';
    };
    passwordFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/path/to/password-file";
      description = ''
        File containing the password for connecting to adguard home. Make sure that this file is readable by the exporter user.
        The password to connect to the adguard api with. Must be in the same order as servers if scraping multiple instances.
      '';
    };
  };
  serviceOpts = {
    script = ''
      passwordfile="$CREDENTIALS_DIRECTORY/password-file"
      export ADGUARD_PASSWORDS="$(cat "$passwordfile")"
      exec ${pkgs.prometheus-adguard-exporter}/bin/adguard-exporter
    '';
    serviceConfig = {
      LoadCredential = [
        "password-file:${config.services.prometheus.exporters.adguard.passwordFile}"
      ];
      Environment = [
        "ADGUARD_SERVERS=${cfg.servers}"
        "ADGUARD_USERNAMES=${cfg.users}"
      ];
    };
  };
}
