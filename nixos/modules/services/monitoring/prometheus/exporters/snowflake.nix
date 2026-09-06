{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.prometheus.exporters.snowflake;
  inherit (lib)
    mkIf
    mkOption
    types
    optional
    escapeShellArg
    concatStringsSep
    getExe
    ;

  # The private key is passed to systemd via LoadCredential, which exposes it in
  # the per-service credentials directory (`%d`) readable by the service even
  # under DynamicUser.
  args = [
    "--web.listen-address ${cfg.listenAddress}:${toString cfg.port}"
    "--account ${escapeShellArg cfg.account}"
    "--username ${escapeShellArg cfg.username}"
    "--warehouse ${escapeShellArg cfg.warehouse}"
    "--role ${escapeShellArg cfg.role}"
  ]
  ++ optional (cfg.privateKeyFile != null) "--private-key-path=%d/snowflake-private-key"
  ++ cfg.extraFlags;
in
{
  port = 9975;
  extraOpts = {
    account = mkOption {
      type = types.str;
      example = "xy12345.us-east-1";
      description = "Snowflake account to collect metrics for (`--account`).";
    };
    username = mkOption {
      type = types.str;
      description = "Username used when querying metrics (`--username`).";
    };
    warehouse = mkOption {
      type = types.str;
      description = "Warehouse used when querying metrics (`--warehouse`).";
    };
    role = mkOption {
      type = types.str;
      default = "ACCOUNTADMIN";
      description = "Role used when querying metrics (`--role`).";
    };
    privateKeyFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/run/secrets/snowflake-exporter.p8";
      description = ''
        Path to the user's RSA private key for key-pair authentication. The file
        is passed to the service via {manpage}`systemd.exec(5)` credentials, so
        it is read only by the exporter and never copied into the world-readable
        Nix store. If the key is encrypted, supply its password via
        {option}`environmentFile` (`SNOWFLAKE_EXPORTER_PRIVATE_KEY_PASSWORD`).

        Mutually exclusive with password authentication; when set, do not also
        provide `SNOWFLAKE_EXPORTER_PASSWORD`.
      '';
    };
    environmentFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/run/secrets/snowflake-exporter.env";
      description = ''
        Path to an environment file, as defined in {manpage}`systemd.exec(5)`,
        used to pass secrets without exposing them in the world-readable Nix
        store or the process's command line. For password authentication set
        `SNOWFLAKE_EXPORTER_PASSWORD`; for an encrypted key (see
        {option}`privateKeyFile`) set `SNOWFLAKE_EXPORTER_PRIVATE_KEY_PASSWORD`.
      '';
    };
  };
  serviceOpts = {
    serviceConfig = {
      EnvironmentFile = mkIf (cfg.environmentFile != null) [ cfg.environmentFile ];
      LoadCredential = mkIf (cfg.privateKeyFile != null) [
        "snowflake-private-key:${cfg.privateKeyFile}"
      ];
      ExecStart = "${getExe pkgs.prometheus-snowflake-exporter} ${concatStringsSep " " args}";
    };
  };
}
