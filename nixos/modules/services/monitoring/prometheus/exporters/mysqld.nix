{ config, lib, pkgs, options, ... }:
let
  cfg = config.services.prometheus.exporters.mysqld;
  inherit (lib) types mkOption mdDoc mkIf mkForce cli concatStringsSep optionalString escapeShellArgs;
in {
  port = 9104;
  extraOpts = {
    telemetryPath = mkOption {
      type = types.str;
      default = "/metrics";
      description = mdDoc ''
        Path under which to expose metrics.
      '';
    };

    runAsLocalSuperUser = mkOption {
      type = types.bool;
      default = false;
      description = mdDoc ''
        Whether to run the exporter as {option}`services.mysql.user`.
      '';
    };

    configFile = mkOption {
      type = types.path;
      example = "/var/lib/prometheus-mysqld-exporter.cnf";
      description = mdDoc ''
        Path to the services config file.

        See <https://github.com/prometheus/mysqld_exporter#running> for more information about
        the available options.

        ::: {.warn}
        Please do not store this file in the nix store if you choose to include any credentials here,
        as it would be world-readable.
        :::
      '';
    };
  };

  serviceOpts = {
    serviceConfig = {
      DynamicUser = !cfg.runAsLocalSuperUser;
      User = mkIf cfg.runAsLocalSuperUser (mkForce config.services.mysql.user);
      LoadCredential = mkIf (cfg.configFile != null) (mkForce ("config:" + cfg.configFile));
      ExecStart = concatStringsSep " " [
        "${pkgs.prometheus-mysqld-exporter}/bin/mysqld_exporter"
        "--web.listen-address=${cfg.listenAddress}:${toString cfg.port}"
        "--web.telemetry-path=${cfg.telemetryPath}"
        (optionalString (cfg.configFile != null) ''--config.my-cnf=''${CREDENTIALS_DIRECTORY}/config'')
        (escapeShellArgs cfg.extraFlags)
      ];
      RestrictAddressFamilies = [
        # The exporter can be configured to talk to a local mysql server via a unix socket.
        "AF_UNIX"
      ];
    };
  };
}

