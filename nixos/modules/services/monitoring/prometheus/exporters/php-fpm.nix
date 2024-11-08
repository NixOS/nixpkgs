{ config
, lib
, pkgs
, options
, ...
}:

let
  logPrefix = "services.prometheus.exporter.php-fpm";
  cfg = config.services.prometheus.exporters.php-fpm;
in {
  port = 9253;
  extraOpts = {
    package = lib.mkPackageOption pkgs "prometheus-php-fpm-exporter" {};

    telemetryPath = lib.mkOption {
      type = lib.types.str;
      default = "/metrics";
      description = ''
        Path under which to expose metrics.
      '';
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/root/prometheus-php-fpm-exporter.env";
      description = ''
        Environment file as defined in {manpage}`systemd.exec(5)`.

        Secrets may be passed to the service without adding them to the
        world-readable Nix store, by specifying placeholder variables as
        the option value in Nix and setting these variables accordingly in the
        environment file.

        Environment variables from this file will be interpolated into the
        config file using envsubst with this syntax:
        `$ENVIRONMENT ''${VARIABLE}`

        For variables to use see [options and defaults](https://github.com/hipages/php-fpm_exporter#options-and-defaults).

        The main use is to set the PHP_FPM_SCRAPE_URI that indicate how to connect to PHP-FPM process.

        ```
          # Content of the environment file
          PHP_FPM_SCRAPE_URI="unix:///tmp/php.sock;/status"
        ```

        Note that this file needs to be available on the host on which
        this exporter is running.
      '';
    };
  };

  serviceOpts = {
    serviceConfig = {
      EnvironmentFile = lib.mkIf (cfg.environmentFile != null) [ cfg.environmentFile ];
      ExecStart = ''
        ${lib.getExe cfg.package} server \
          --web.listen-address ${cfg.listenAddress}:${toString cfg.port} \
          --web.telemetry-path ${cfg.telemetryPath} \
          ${lib.concatStringsSep " \\\n  " cfg.extraFlags}
      '';
    };
  };
}
