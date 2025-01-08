{
  config,
  lib,
  pkgs,
  options,
  ...
}:

let
  cfg = config.services.prometheus.exporters.pihole;
  inherit (lib)
    lib.mkOption
    types
    mkRemovedOptionModule
    lib.optionalString
    ;
in
{
  imports = [
    (lib.mkRemovedOptionModule [ "interval" ] "This option has been removed.")
    ({
      options.warnings = options.warnings;
      options.assertions = options.assertions;
    })
  ];

  port = 9617;
  extraOpts = {
    apiToken = lib.mkOption {
      type = lib.types.str;
      default = "";
      example = "580a770cb40511eb85290242ac130003580a770cb40511eb85290242ac130003";
      description = ''
        Pi-Hole API token which can be used instead of a password
      '';
    };
    password = lib.mkOption {
      type = lib.types.str;
      default = "";
      example = "password";
      description = ''
        The password to login into Pi-Hole. An api token can be used instead.
      '';
    };
    piholeHostname = lib.mkOption {
      type = lib.types.str;
      default = "pihole";
      example = "127.0.0.1";
      description = ''
        Hostname or address where to find the Pi-Hole webinterface
      '';
    };
    piholePort = lib.mkOption {
      type = lib.types.port;
      default = 80;
      example = 443;
      description = ''
        The port Pi-Hole webinterface is reachable on
      '';
    };
    protocol = lib.mkOption {
      type = lib.types.enum [
        "http"
        "https"
      ];
      default = "http";
      example = "https";
      description = ''
        The protocol which is used to connect to Pi-Hole
      '';
    };
    timeout = lib.mkOption {
      type = lib.types.str;
      default = "5s";
      description = ''
        Controls the timeout to connect to a Pi-Hole instance
      '';
    };
  };
  serviceOpts = {
    serviceConfig = {
      ExecStart = ''
        ${pkgs.prometheus-pihole-exporter}/bin/pihole-exporter \
          ${lib.optionalString (cfg.apiToken != "") "-pihole_api_token ${cfg.apiToken}"} \
          -pihole_hostname ${cfg.piholeHostname} \
          ${lib.optionalString (cfg.password != "") "-pihole_password ${cfg.password}"} \
          -pihole_port ${toString cfg.piholePort} \
          -pihole_protocol ${cfg.protocol} \
          -port ${toString cfg.port} \
          -timeout ${cfg.timeout}
      '';
    };
  };
}
