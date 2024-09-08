{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.reposilite;

  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkOption
    mkIf
    getExe
    types
    optionals
    ;

  # Reposilite actually uses https://github.com/dzikoysk/cdn, but its format is similar enough to YAMLs to use pkgs.formats.yaml.
  settingsFormat = pkgs.formats.yaml { };
in
{
  options.services.reposilite = {
    enable = mkEnableOption "reposilite";
    package = mkPackageOption pkgs "reposilite" { };

    settings = mkOption {
      type = types.submodule {
        freeformType = settingsFormat.type;
        options = {
          hostname = mkOption {
            description = ''
              Hostname
              The hostname can be used to limit which connections are accepted.
              Use 0.0.0.0 to accept connections from anywhere.
              127.0.0.1 will only allow connections from localhost.
            '';
            default = "0.0.0.0";
            example = "127.0.0.1";
            type = types.str;
          };

          port = mkOption {
            description = "Port to bind";
            default = 8080;
            example = 5678;
            type = types.port;
          };

          database = mkOption {
            description = ''
              Database configuration. Supported storage providers:
              - mysql localhost:3306 database user password
              - sqlite reposilite.db
              - sqlite --temporary
              Experimental providers (not covered with tests):
              - postgresql localhost:5432 database user password
              - h2 reposilite
            '';
            default = "sqlite reposilite.db";
            example = "mysql localhost:3306 database user password";
            type = types.str;
          };

          sslEnabled = mkOption {
            description = "Support encrypted connections";
            default = false;
            type = types.bool;
          };

          sslPort = mkOption {
            description = "SSL port to bind";
            default = 443;
            example = 5678;
            type = types.port;
          };

          keyPath = mkOption {
            description = ''
              Key file to use.
              You can specify absolute path to the given file or use ''${WORKING_DIRECTORY} variable.
              If you want to use .pem certificate you need to specify its path next to the key path.
              Example .pem paths setup:
              keyPath = "''${WORKING_DIRECTORY}/cert.pem ''${WORKING_DIRECTORY}/key.pem"
              Example .jks path setup:
              keyPath = "''${WORKING_DIRECTORY}/keystore.jks"
            '';
            default = "\${WORKING_DIRECTORY}/cert.pem \${WORKING_DIRECTORY}/key.pem";
            example = "\${WORKING_DIRECTORY}/keystore.jks";
          };

          keyPassword = mkOption {
            description = "Key password to use";
            default = "";
            type = types.str;
          };

          enforeSsl = mkOption {
            description = "Redirect HTTP traffic to HTTPS";
            default = false;
            type = types.bool;
          };

          webThreadPool = mkOption {
            description = ''
              Max amount of threads used by core thread pool (min: 5)
              The web thread pool handles first few steps of incoming http connections, as soon as possible all tasks are redirected to IO thread pool.
            '';
            default = 16;
            example = 32;
            type = types.int;
          };

          ioThreadPool = mkOption {
            description = ''
              IO thread pool handles all tasks that may benefit from non-blocking IO (min: 2)
              Because most of tasks are redirected to IO thread pool, it might be a good idea to keep it at least equal to web thread pool.
            '';
            default = 8;
            example = 12;
            type = types.int;
          };

          databaseThreadPool = mkOption {
            description = ''
              Database thread pool manages open connections to database (min: 1)
              Embedded databases such as SQLite or H2 don't support truly concurrent connections, so the value will be always 1 for them if selected.
            '';
            default = 1;
            example = 3;
            type = types.int;
          };

          compressionStrategy = mkOption {
            description = ''
              Select compression strategy used by this instance.
              Using 'none' reduces usage of CPU & memory, but ends up with higher transfer usage.
              GZIP is better option if you're not limiting resources that much to increase overall request times.
              Available strategies: none, gzip
            '';
            default = "none";
            example = "gzip";
            type = types.enum [
              "none"
              "gzip"
            ];
          };

          idleTimeout = mkOption {
            description = "Default idle timeout used by Jetty";
            default = 30000;
            example = 120000;
            type = types.int;
          };

          bypassExternalCache = mkOption {
            description = ''
              Adds cache bypass headers to each request from /api/* scope served by this instance.
              Helps to avoid various random issues caused by proxy provides (e.g. Cloudflare) and browsers.
            '';
            default = true;
            type = types.bool;
          };

          cachedLogSize = mkOption {
            description = "Amount of messages stored in cached logger.";
            default = 32;
            example = 64;
            type = types.ints.unsigned;
          };

          defaultFrontend = mkOption {
            description = "Enable default frontend with dashboard.";
            default = true;
            type = types.bool;
          };

          basePath = mkOption {
            description = ''
              Set custom base path for Reposilite instance.
              It's not recommended to mount Reposilite under custom base path and you should always prioritize subdomain over this option.
            '';
            default = "/";
            example = "/maven";
            type = types.str;
          };

          debugEnabled = mkOption {
            description = "Debug mode";
            default = false;
            type = types.bool;
          };

        };
      };
      description = "Configuration written to the config file for Reposilite.";
      default = { };
    };

    openFirewall = mkOption {
      description = ''
        Whether to open the firewall for Reposilite.
        This adds `services.reposilite.settings.port` and `services.reposilite.settings.sslPort` (if SSL is enabled)  to `networking.firewall.allowedTCPPorts`.
      '';
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    # This is done so that the reposilite command is available in PATH so users can setup their first token (see reposilite.md).
    environment.systemPackages = [ cfg.package ];

    systemd.services.reposilite = {
      description = "Reposilite server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        ExecStart =
          let
            config-cdn = settingsFormat.generate "reposilite.cdn" cfg.settings;
          in
          "${getExe cfg.package} --local-configuration ${config-cdn} --local-configuration-mode none --working-directory /var/lib/reposilite";
        WorkingDirectory = "/var/lib/reposilite";
        StateDirectory = "reposilite";
        PrivateTmp = true;
        DynamicUser = true;
      };
    };

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall (
      [ cfg.settings.server.port ]
      ++ optionals cfg.settings.sslEnabled [ cfg.settings.server.sslPort ] [ ]
    );
  };

  meta.doc = ./reposilite.md;
  meta.maintainers = [ lib.maintainers.jamalam ];
}
