{ config, lib, pkgs, options }:

with lib;

let
  cfg = config.services.prometheus.exporters.artifactory;
in
{
  port = 9531;
  extraOpts = {
    scrapeUri = mkOption {
      type = types.str;
      default = "http://localhost:8081/artifactory";
      description = lib.mdDoc ''
        URI on which to scrape JFrog Artifactory.
      '';
    };

    artiUsername = mkOption {
      type = types.str;
      description = lib.mdDoc ''
        Username for authentication against JFrog Artifactory API.
      '';
    };

    artiPassword = mkOption {
      type = types.str;
      default = "";
      description = lib.mdDoc ''
        Password for authentication against JFrog Artifactory API.
        One of the password or access token needs to be set.
      '';
    };

    artiAccessToken = mkOption {
      type = types.str;
      default = "";
      description = lib.mdDoc ''
        Access token for authentication against JFrog Artifactory API.
        One of the password or access token needs to be set.
      '';
    };
  };
  serviceOpts = {
    serviceConfig = {
      ExecStart = ''
        ${pkgs.prometheus-artifactory-exporter}/bin/artifactory_exporter \
          --web.listen-address ${cfg.listenAddress}:${toString cfg.port} \
          --artifactory.scrape-uri ${cfg.scrapeUri} \
          ${concatStringsSep " \\\n  " cfg.extraFlags}
      '';
      Environment = [
        "ARTI_USERNAME=${cfg.artiUsername}"
        "ARTI_PASSWORD=${cfg.artiPassword}"
        "ARTI_ACCESS_TOKEN=${cfg.artiAccessToken}"
      ];
    };
  };
}
