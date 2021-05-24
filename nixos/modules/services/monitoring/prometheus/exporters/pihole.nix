{ config, lib, pkgs, options }:

with lib;

let
  cfg = config.services.prometheus.exporters.pihole;
in
{
  port = 9617;
  extraOpts = {
    apiToken = mkOption {
      type = types.str;
      default = "";
      example = "580a770cb40511eb85290242ac130003580a770cb40511eb85290242ac130003";
      description = ''
        pi-hole API token which can be used instead of a password
      '';
    };
    interval = mkOption {
      type = types.str;
      default = "10s";
      example = "30s";
      description = ''
        How often to scrape new data
      '';
    };
    password = mkOption {
      type = types.str;
      default = "";
      example = "password";
      description = ''
        The password to login into pihole. An api token can be used instead.
      '';
    };
    piholeHostname = mkOption {
      type = types.str;
      default = "pihole";
      example = "127.0.0.1";
      description = ''
        Hostname or address where to find the pihole webinterface
      '';
    };
    piholePort = mkOption {
      type = types.port;
      default = "80";
      example = "443";
      description = ''
        The port pihole webinterface is reachable on
      '';
    };
    protocol = mkOption {
      type = types.enum [ "http" "https" ];
      default = "http";
      example = "https";
      description = ''
        The protocol which is used to connect to pihole
      '';
    };
  };
  serviceOpts = {
    serviceConfig = {
      ExecStart = ''
        ${pkgs.bash}/bin/bash -c "${pkgs.prometheus-pihole-exporter}/bin/pihole-exporter \
          -interval ${cfg.interval} \
          ${optionalString (cfg.apiToken != "") "-pihole_api_token ${cfg.apiToken}"} \
          -pihole_hostname ${cfg.piholeHostname} \
          ${optionalString (cfg.password != "") "-pihole_password ${cfg.password}"} \
          -pihole_port ${toString cfg.piholePort} \
          -pihole_protocol ${cfg.protocol} \
          -port ${toString cfg.port}"
      '';
    };
  };
}
