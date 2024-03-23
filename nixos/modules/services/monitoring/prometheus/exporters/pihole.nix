{ config, lib, pkgs, options, ... }:

with lib;

let
  cfg = config.services.prometheus.exporters.pihole;
in
{
  imports = [
    (mkRemovedOptionModule [ "interval"] "This option has been removed.")
    ({ options.warnings = options.warnings; options.assertions = options.assertions; })
  ];

  port = 9617;
  extraOpts = {
    apiToken = mkOption {
      type = types.str;
      default = "";
      example = "580a770cb40511eb85290242ac130003580a770cb40511eb85290242ac130003";
      description = lib.mdDoc ''
        Pi-Hole API token which can be used instead of a password
      '';
    };
    password = mkOption {
      type = types.str;
      default = "";
      example = "password";
      description = lib.mdDoc ''
        The password to login into Pi-Hole. An api token can be used instead.
      '';
    };
    piholeHostname = mkOption {
      type = types.str;
      default = "pihole";
      example = "127.0.0.1";
      description = lib.mdDoc ''
        Hostname or address where to find the Pi-Hole webinterface
      '';
    };
    piholePort = mkOption {
      type = types.port;
      default = 80;
      example = 443;
      description = lib.mdDoc ''
        The port Pi-Hole webinterface is reachable on
      '';
    };
    protocol = mkOption {
      type = types.enum [ "http" "https" ];
      default = "http";
      example = "https";
      description = lib.mdDoc ''
        The protocol which is used to connect to Pi-Hole
      '';
    };
    timeout = mkOption {
      type = types.str;
      default = "5s";
      description = lib.mdDoc ''
        Controls the timeout to connect to a Pi-Hole instance
      '';
    };
  };
  serviceOpts = {
    serviceConfig = {
      ExecStart = ''
        ${pkgs.prometheus-pihole-exporter}/bin/pihole-exporter \
          ${optionalString (cfg.apiToken != "") "-pihole_api_token ${cfg.apiToken}"} \
          -pihole_hostname ${cfg.piholeHostname} \
          ${optionalString (cfg.password != "") "-pihole_password ${cfg.password}"} \
          -pihole_port ${toString cfg.piholePort} \
          -pihole_protocol ${cfg.protocol} \
          -port ${toString cfg.port} \
          -timeout ${cfg.timeout}
      '';
    };
  };
}
