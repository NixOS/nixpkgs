{
  config,
  lib,
  pkgs,
  options,
  ...
}:

let
  cfg = config.services.prometheus.exporters.artifactory;
in
{
  port = 9531;
  extraOpts = {
    scrapeUri = lib.mkOption {
      type = lib.types.str;
      default = "http://localhost:8081/artifactory";
      description = ''
        URI on which to scrape JFrog Artifactory.
      '';
    };

    artiUsername = lib.mkOption {
      type = lib.types.str;
      description = ''
        Username for authentication against JFrog Artifactory API.
      '';
    };

    artiPassword = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = ''
        Password for authentication against JFrog Artifactory API.
        One of the password or access token needs to be set.
      '';
    };

    artiAccessToken = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = ''
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
          ${lib.concatStringsSep " \\\n  " cfg.extraFlags}
      '';
      Environment = [
        "ARTI_USERNAME=${cfg.artiUsername}"
        "ARTI_PASSWORD=${cfg.artiPassword}"
        "ARTI_ACCESS_TOKEN=${cfg.artiAccessToken}"
      ];
    };
  };
}
