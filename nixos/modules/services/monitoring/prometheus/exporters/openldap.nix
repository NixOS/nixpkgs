{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.prometheus.exporters.openldap;
in {
  port = 9330;
  extraOpts = {
    ldapCredentialFile = mkOption {
      type = types.path;
      example = "/run/keys/ldap_pass";
      description = lib.mdDoc ''
        Environment file to contain the credentials to authenticate against
        `openldap`.

        The file should look like this:
        ```
        ---
        ldapUser: "cn=monitoring,cn=Monitor"
        ldapPass: "secret"
        ```
      '';
    };
    protocol = mkOption {
      default = "tcp";
      example = "udp";
      type = types.str;
      description = lib.mdDoc ''
        Which protocol to use to connect against `openldap`.
      '';
    };
    ldapAddr = mkOption {
      default = "localhost:389";
      type = types.str;
      description = lib.mdDoc ''
        Address of the `openldap`-instance.
      '';
    };
    metricsPath = mkOption {
      default = "/metrics";
      type = types.str;
      description = lib.mdDoc ''
        URL path where metrics should be exposed.
      '';
    };
    interval = mkOption {
      default = "30s";
      type = types.str;
      example = "1m";
      description = lib.mdDoc ''
        Scrape interval of the exporter.
      '';
    };
  };
  serviceOpts.serviceConfig = {
    ExecStart = ''
      ${pkgs.prometheus-openldap-exporter}/bin/openldap_exporter \
        --promAddr ${cfg.listenAddress}:${toString cfg.port} \
        --metrPath ${cfg.metricsPath} \
        --ldapNet ${cfg.protocol} \
        --interval ${cfg.interval} \
        --config ${cfg.ldapCredentialFile} \
        ${concatStringsSep " \\\n  " cfg.extraFlags}
    '';
  };
}
