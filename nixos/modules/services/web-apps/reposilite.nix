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
    mkDefault
    getExe
    types
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
        This adds `services.reposilite.settings.port` to `networking.firewall.allowedTCPPorts`.
      '';
      default = false;
      type = types.bool;
    };

    nginx = mkOption {
      type = types.submodule {
        options = {
          enable = mkEnableOption "the nginx reverse proxy virtual host";

          hostname = mkOption {
            description = ''
              The hostname for the nginx virtual host.
            '';
            example = "reposilite.example.com";
            type = types.str;
          };
        };
      };

      description = "nginx config TODO";
      default = { };
    };

    user = mkOption {
      type = types.nonEmptyStr;
      default = "reposilite";
      description = "User account under which Reposilite runs.";
    };

    group = mkOption {
      type = types.nonEmptyStr;
      default = "reposilite";
      description = "Group account under which Reposilite runs.";
    };
  };

  config = mkIf cfg.enable (
    let
      config-cdn = settingsFormat.generate "reposilite.cdn" cfg.settings;
    in
    {
      users = {
        users."${cfg.user}" = {
          description = "Reposilite user";
          group = cfg.group;
          isSystemUser = true;
        };
        groups."${cfg.group}" = { };
      };

      # This is done so that the reposilite command is available in PATH so users can setup their first token (see reposilite.md).
      environment.systemPackages = [ cfg.package ];

      systemd.services.reposilite = {
        description = "Reposilite server";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];

        serviceConfig = {
          Type = "exec";
          User = cfg.user;
          Group = cfg.group;
          UMask = "0077";
          ExecStart = "${getExe cfg.package} --local-configuration ${config-cdn} --local-configuration-mode none --working-directory /var/lib/reposilite";
          WorkingDirectory = "/var/lib/reposilite";
          StateDirectory = "reposilite";

          ProtectProc = "invisible";
          ProcSubset = "pid";
          ProtectSystem = "strict";
          ProtectHome = true;
          PrivateTmp = true;
          PrivateDevices = true;
          PrivateUsers = true;
          PrivateIPC = true;
          ProtectHostname = true;
          ProtectClock = true;
          ProtectKernelTunables = true;
          ProtectKernelModules = true;
          ProtectKernelLogs = true;
          ProtectControlGroups = true;

          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
          ];
          RestrictNamespaces = true;
          LockPersonality = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          RemoveIPC = true;

          CapabilityBoundingSet = [ "" ];

          NoNewPrivileges = true;
          SystemCallFilter = [ "@system-service" ];
          SystemCallErrorNumber = "EPERM";
          SystemCallArchitectures = "native";

          DevicePolicy = "closed";

          IPAddressDeny = "any";
          IPAddressAllow = cfg.settings.hostname;
        };
      };

      services.reposilite = mkIf cfg.nginx.enable {
        settings.hostname = mkDefault "localhost";
        openFirewall = mkDefault false;
      };

      networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.settings.server.port ];

      services.nginx = mkIf cfg.nginx.enable {
        enable = true;
        virtualHosts.${cfg.nginx.hostname} = {
          locations."/" = {
            proxyPass = "http://${cfg.settings.hostname}:${toString cfg.settings.port}/";
          };
        };
      };
    }
  );

  meta.doc = ./reposilite.md;
  meta.maintainers = with lib.maintainers; [
    jamalam
    magneticflux-
  ];
}
