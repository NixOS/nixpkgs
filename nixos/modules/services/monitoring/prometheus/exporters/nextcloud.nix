{
  config,
  lib,
  pkgs,
  options,
  ...
}:

let
  cfg = config.services.prometheus.exporters.nextcloud;
  inherit (lib)
    mkOption
    types
    escapeShellArg
    concatStringsSep
    ;
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
        to `/ocs/v2.php/apps/serverinfo/api/v1/info`.
      '';
    };
    username = mkOption {
      type = types.str;
      default = "nextcloud-exporter";
      description = ''
        Username for connecting to Nextcloud.
        Note that this account needs to have admin privileges in Nextcloud.
        Unused when using token authentication.
      '';
    };
    passwordFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/path/to/password-file";
      description = ''
        File containing the password for connecting to Nextcloud.
        Make sure that this file is readable by the exporter user.
      '';
    };
    tokenFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/path/to/token-file";
      description = ''
        File containing the token for connecting to Nextcloud.
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
          --addr ${cfg.listenAddress}:${toString cfg.port} \
          --timeout ${cfg.timeout} \
          --server ${cfg.url} \
          ${
            if cfg.passwordFile != null then
              ''
                --username ${cfg.username} \
                --password ${escapeShellArg "@${cfg.passwordFile}"} \
              ''
            else
              ''
                --auth-token ${escapeShellArg "@${cfg.tokenFile}"} \
              ''
          } \
          ${concatStringsSep " \\\n  " cfg.extraFlags}'';
    };
  };
}
