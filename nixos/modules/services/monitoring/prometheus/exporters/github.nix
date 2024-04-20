{ config
, lib
, pkgs
, ...
}:
let
  cfg = config.services.prometheus.exporters.github;
in
{
  port = 9171;
  extraOpts = {
    users = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        If supplied, the exporter will enumerate all repositories
        for that users.
      '';
    };

    organizations = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        If supplied, the exporter will enumerate all repositories
        for that organization.
      '';
    };

    repositories = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        If supplied, The repos you wish to monitor, expected in the
        format "user/repo1". Can be across different Github users/orgs.
      '';
    };

    apiUrl = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "https://api.github.com";
      description = ''
        Github API URL, shouldn't need to change this.
      '';
    };

    tokenPath = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/run/secrets/github-api-token";
      description = ''
        If supplied, enables the user to supply a path to a file
        containing a github authentication token that allows the
        API to be queried more often. Optional, but recommended.

        See the [Managing your personal access tokens](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)
        for more information.

        ::: {.warning}
        Please do not store this file in the nix store if you choose to
        include any credentials here, as it would be world-readable.
        :::
      '';
    };

    telemetryPath = lib.mkOption {
      type = lib.types.str;
      default = "/metrics";
      description = ''
        Path under which to expose metrics.
      '';
    };

    logLevel = lib.mkOption {
      type = lib.types.enum [ "critical" "error" "warning" "info" "debug" ];
      default = "info";
      description = "The level of logging the exporter will run with.";
    };
  };

  serviceOpts = {
    serviceConfig = {
      Environment =
        [
          "LOG_LEVEL=${cfg.logLevel}"
          "LISTEN_PORT=${toString cfg.port}"
          "METRICS_PATH=${cfg.telemetryPath}"
        ]
        ++ lib.optionals (cfg.apiUrl != null) [ "API_URL=${cfg.apiUrl}" ]
        ++ lib.optionals (cfg.tokenPath != null) [ "GITHUB_TOKEN_FILE=${cfg.tokenPath}" ]
        ++ lib.optionals (cfg.users != [ ]) [ "USERS=${lib.concatStringsSep "," cfg.users}" ]
        ++ lib.optionals (cfg.repositories != [ ]) [ "REPOS=${lib.concatStringsSep "," cfg.repositories}" ]
        ++ lib.optionals (cfg.organizations != [ ]) [ "ORGS=${lib.concatStringsSep "," cfg.organizations}" ];
      ExecStart = lib.getExe pkgs.prometheus-github-exporter;
    };
  };
}
