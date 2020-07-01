{ config, lib, pkgs, options }:

with lib;

let
  cfg = config.services.prometheus.exporters.nextcloud;
in
{
  port = 9205;
  extraOpts = {
    url = mkOption {
      type = types.str;
      example = "https://domain.tld";
      description = ''
        URL to the Nextcloud serverinfo page.
        Adding the path to the serverinfo API is optional, it defaults
        to <literal>/ocs/v2.php/apps/serverinfo/api/v1/info</literal>.
      '';
    };
    username = mkOption {
      type = types.str;
      default = "nextcloud-exporter";
      description = ''
        Username for connecting to Nextcloud.
        Note that this account needs to have admin privileges in Nextcloud.
      '';
    };
    passwordFile = mkOption {
      type = types.path;
      example = "/path/to/password-file";
      description = ''
        File containing the password for connecting to Nextcloud.
        Make sure that this file is readable by the exporter user.
      '';
    };
    timeout = mkOption {
      type = types.str;
      default = "5s";
      description = ''
        Timeout for getting server info document.
      '';
    };
  };
  serviceOpts = {
    serviceConfig = {
      DynamicUser = false;
      ExecStart = ''
        ${pkgs.prometheus-nextcloud-exporter}/bin/nextcloud-exporter \
          -a ${cfg.listenAddress}:${toString cfg.port} \
          -u ${cfg.username} \
          -t ${cfg.timeout} \
          -l ${cfg.url} \
          -p ${escapeShellArg "@${cfg.passwordFile}"} \
          ${concatStringsSep " \\\n  " cfg.extraFlags}
      '';
    };
  };
}
