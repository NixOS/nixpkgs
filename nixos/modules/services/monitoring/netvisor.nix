{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.netvisor;

  serverArgs = lib.cli.toGNUCommandLineShell { } (
    {
      public-url = cfg.server.publicUrl;
      server-port = cfg.server.port;
      use-secure-session-cookies = lib.boolToString cfg.server.useSecureSessionCookies;
      integrated-daemon-url = cfg.server.integratedDaemonUrl;
      disable-registration = cfg.server.disableRegistration;
      database-url = cfg.server.database.connectionUrl;
      log-level = cfg.server.logLevel;
    }
    // lib.optionalAttrs (cfg.server.clientIpSource != null) {
      client-ip-source = cfg.server.clientIpSource;
    }
    // lib.optionalAttrs (cfg.server.smtp.username != null) {
      smtp-username = cfg.server.smtp.username;
    }
    // lib.optionalAttrs (cfg.server.smtp.password != null) {
      smtp-password = cfg.server.smtp.password;
    }
    // lib.optionalAttrs (cfg.server.smtp.relay != null) {
      smtp-relay = cfg.server.smtp.relay;
    }
    // lib.optionalAttrs (cfg.server.smtp.email != null) {
      smtp-email = cfg.server.smtp.email;
    }
  );

  daemonArgs = lib.cli.toGNUCommandLineShell { } (
    {
      server-url = cfg.daemon.serverUrl;
      bind-address = cfg.daemon.bindAddress;
      daemon-port = cfg.daemon.port;
      name = cfg.daemon.name;
      mode = cfg.daemon.mode;
      heartbeat-interval = cfg.daemon.heartbeatInterval;
      log-level = cfg.daemon.logLevel;
    }
    // lib.optionalAttrs (cfg.daemon.daemonApiKey != null) {
      daemon-api-key = cfg.daemon.daemonApiKey;
    }
    // lib.optionalAttrs (cfg.daemon.networkId != null) {
      network-id = cfg.daemon.networkId;
    }
    // lib.optionalAttrs (cfg.daemon.concurrentScans != null) {
      concurrent-scans = cfg.daemon.concurrentScans;
    }
    // lib.optionalAttrs (cfg.daemon.dockerProxy != null) {
      docker-proxy = cfg.daemon.dockerProxy;
    }
  );
in
{
  options.services.netvisor = {
    package = lib.mkPackageOption pkgs "netvisor" { };

    user = lib.mkOption {
      type = lib.types.str;
      default = "netvisor";
      description = "User under which the NetVisor service runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "netvisor";
      description = "Group under which the NetVisor service runs.";
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/netvisor";
      description = "State directory for the netvisor server.";
    };

    server = lib.mkOption {
      description = "NetVisor server configuration.";
      default = { };
      type = lib.types.submodule {
        options = {
          enable = lib.mkEnableOption "NetVisor server";
          database = {
            enable =
              lib.mkEnableOption "The postgresql database for use with netvisor. See {option}`services.postgresql`"
              // {
                default = true;
              };
            createDB = lib.mkEnableOption "The automatic creation of the database for netvisor." // {
              default = true;
            };
            name = lib.mkOption {
              type = lib.types.str;
              default = "netvisor";
              description = "The name of the netvisor database.";
            };
            connectionUrl = lib.mkOption {
              type = lib.types.str;
              default = "postgresql:///${cfg.server.database.name}";
              defaultText = lib.literalExpression ''postgresql:///''${config.services.netvisor.server.database.name}'';
              description = "The Database connection string.";
            };
            user = lib.mkOption {
              type = lib.types.str;
              default = "netvisor";
              description = "The database user for netvisor.";
            };
          };
          nginx = lib.mkOption {
            type = lib.types.submodule (
              lib.recursiveUpdate (import ../web-servers/nginx/vhost-options.nix { inherit config lib; }) { }
            );
            default = { };
            example = lib.literalExpression ''
              {
                forceSSL = true;
                enableACME = true;
                default = true;
              }
            '';
            description = "Custom nginx virtualHost settings for the NetVisor web UI.";
          };
          publicUrl = lib.mkOption {
            type = lib.types.str;
            default = "http://127.0.0.1:60072";
            description = "Public URL for webhooks, email links, etc.";
          };
          hostname = lib.mkOption {
            type = lib.types.str;
            default = "netvisor";
            description = "The hostname to serve frontend on.";
          };
          clientIpSource = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = "XRealIp";
            description = ''
              Source of IP address from request headers, used to log accurate IP address in auth logs while using a
              reverse proxy. Refer to <https://github.com/imbolc/axum-client-ip?tab=readme-ov-file#configurable-vs-specific-extractors>
              docs for values you can set.
            '';
          };
          openFirewall = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Whether to open ports in the firewall for the server.";
          };
          port = lib.mkOption {
            type = lib.types.port;
            default = 60072;
            description = "Port for server to listen on.";
          };
          useSecureSessionCookies = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable HTTPS-only cookies.";
          };
          integratedDaemonUrl = lib.mkOption {
            type = lib.types.str;
            default = "http://127.0.0.1:${toString cfg.daemon.port}";
            defaultText = lib.literalExpression ''http://127.0.0.1:''${toString config.services.netvisor.daemon.port}'';
            description = "URL where the server can reach the integrated daemon.";
          };
          disableRegistration = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Disable new user registration.";
          };
          logLevel = lib.mkOption {
            type = lib.types.enum [
              "trace"
              "debug"
              "info"
              "warn"
              "error"
            ];
            default = "info";
            description = "Logging verbosity.";
          };
          smtp = lib.mkOption {
            description = "NetVisor server SMTP configuration.";
            default = { };
            type = lib.types.submodule {
              options = {
                username = lib.mkOption {
                  type = lib.types.nullOr lib.types.str;
                  default = null;
                  description = "SMTP username for email features (password reset, notifications).";
                };
                password = lib.mkOption {
                  type = lib.types.nullOr lib.types.str;
                  default = null;
                  description = "SMTP password for email authentication";
                };
                relay = lib.mkOption {
                  type = lib.types.nullOr lib.types.str;
                  default = null;
                  description = "SMTP server address (e.g., `smtp.gmail.com`) .";
                };
                email = lib.mkOption {
                  type = lib.types.nullOr lib.types.str;
                  default = null;
                  description = "ender email address for outgoing emails.";
                };
              };
            };
          };
        };
      };
    };

    daemon = lib.mkOption {
      description = "NetVisor daemon configuration.";
      default = { };
      type = lib.types.submodule {
        options = {
          enable = lib.mkEnableOption "NetVisor daemon" // {
            default = cfg.server.enable;
            defaultText = lib.literalExpression "config.server.enable";
          };
          daemonApiKey = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "Authentication key for daemon (generated via UI).";
          };
          serverUrl = lib.mkOption {
            type = lib.types.str;
            default = "http://127.0.0.1:60072";
            description = "URL where the daemon can reach the server.";
          };
          bindAddress = lib.mkOption {
            type = lib.types.str;
            default = "127.0.0.1";
            description = "IP address to bind daemon to.";
          };
          openFirewall = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Whether to open ports in the firewall for the daemon.";
          };
          port = lib.mkOption {
            type = lib.types.port;
            default = 60073;
            description = "Port for daemon to listen on.";
          };
          name = lib.mkOption {
            type = lib.types.str;
            default = "netvisor-daemon";
            description = "Human-readable name for this daemon.";
          };
          mode = lib.mkOption {
            type = lib.types.enum [
              "push"
              "pull"
            ];
            default = "push";
            description = "Whether server will push work to daemon or daemon should poll for work from server.";
          };
          networkId = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "UUID of the network to scan.";
          };
          heartbeatInterval = lib.mkOption {
            type = lib.types.int;
            default = 30;
            description = "Seconds between heartbeat updates / work requests (for daemons in pull mode) to server.";
          };
          concurrentScans = lib.mkOption {
            type = lib.types.nullOr lib.types.int;
            default = null;
            description = "Maximum parallel host scans during discovery.";
          };
          dockerProxy = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "Optional HTTP proxy for Docker API connections.";
          };
          logLevel = lib.mkOption {
            type = lib.types.enum [
              "trace"
              "debug"
              "info"
              "warn"
              "error"
            ];
            default = "info";
            description = "Logging verbosity.";
          };
        };
      };
    };
  };

  config = lib.mkIf (cfg.server.enable || cfg.daemon.enable) {
    users.groups.${cfg.group} = { };

    users.users.${cfg.user} = {
      description = "NetVisor service user";
      group = cfg.group;
      home = cfg.dataDir;
      createHome = true;
      isSystemUser = true;
    };

    services = {
      postgresql = lib.mkIf (cfg.server.enable && cfg.server.database.enable) {
        enable = true;

        ensureDatabases = lib.mkIf cfg.server.database.createDB [ cfg.server.database.name ];
        ensureUsers = lib.mkIf cfg.server.database.createDB [
          {
            name = cfg.server.database.user;
            ensureDBOwnership = true;
          }
        ];
      };

      nginx = lib.mkIf cfg.server.enable {
        enable = true;

        virtualHosts."${cfg.server.hostname}" = lib.mkMerge [
          cfg.server.nginx
          {
            root = lib.mkForce "${cfg.package.ui}/html";

            locations."/" = {
              index = "index.html";
              tryFiles = "$uri $uri/ /index.html";
            };

            locations."/api".proxyPass = "http://127.0.0.1:${toString cfg.server.port}";
          }
        ];
      };
    };

    systemd.services = {
      netvisor-server = lib.mkIf cfg.server.enable {
        requires = lib.mkIf cfg.server.database.enable [ "postgresql.target" ];
        after = [ "network.target" ] ++ lib.optionals cfg.server.database.enable [ "postgresql.target" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          ExecStart = "${lib.getExe' cfg.package "server"} ${serverArgs}";

          User = cfg.user;
          Group = cfg.group;

          ProtectSystem = "strict";
          ProtectHome = true;

          ReadWritePaths = cfg.dataDir;
          StateDirectory = cfg.dataDir;
        };
      };

      netvisor-daemon = lib.mkIf cfg.daemon.enable {
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          ExecStart = "${lib.getExe' cfg.package "daemon"} ${daemonArgs}";

          User = cfg.user;
          Group = cfg.group;

          ProtectSystem = "strict";
          ProtectHome = true;

          ReadWritePaths = cfg.dataDir;
          StateDirectory = cfg.dataDir;
        };
      };
    };

    networking.firewall =
      lib.mkIf cfg.server.openFirewall {
        allowedTCPPorts = [ cfg.server.port ];
      }
      // lib.mkIf cfg.daemon.openFirewall {
        allowedTCPPorts = [ cfg.daemon.port ];
      };
  };
}
