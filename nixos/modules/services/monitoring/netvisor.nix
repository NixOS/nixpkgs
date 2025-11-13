{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.netvisor;

  package = cfg.package.override {
    public_server_hostname = cfg.server.publicHostname;
    public_server_port = cfg.server.publicPort;
  };

  serverArgs = lib.cli.toGNUCommandLineShell { } {
    server-port = cfg.server.port;
    use-secure-session-cookies = cfg.server.useSecureSessionCookies;
    integrated-daemon-url = cfg.server.integratedDaemonUrl;
    disable-registration = cfg.server.disableRegistration;
    database-url = cfg.server.database.connectionUrl;
    log-level = cfg.server.logLevel;
  };

  daemonArgs = lib.cli.toGNUCommandLineShell { } (
    {
      server-target = cfg.daemon.serverTarget;
      server-port = cfg.daemon.serverPort;
      bind-address = cfg.daemon.bindAddress;
      daemon-port = cfg.daemon.port;
      name = cfg.daemon.name;
      heartbeat-interval = cfg.daemon.heartbeatInterval;
      concurrent-scans = cfg.daemon.concurrentScans;
      log-level = cfg.daemon.logLevel;
    }
    // lib.optionalAttrs (cfg.daemon.daemonApiKey != null) {
      daemon-api-key = cfg.daemon.daemonApiKey;
    }
    // lib.optionalAttrs (cfg.daemon.networkId != null) {
      network-id = cfg.daemon.networkId;
    }
    // lib.optionalAttrs (cfg.daemon.dockerProxy != null) {
      docker-proxy = cfg.daemon.dockerProxy;
    }
  );
in
{
  options.services.netvisor = {
    package = lib.mkPackageOption pkgs "netvisor" { };

    finalPackage = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = package;
      defaultText = lib.literalExpression "package";
      description = ''
        The final package used by the module.
      '';
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "netvisor";
      description = ''
        User under which the NetVisor service runs.
      '';
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "netvisor";
      description = ''
        Group under which the NetVisor service runs.
      '';
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/netvisor";
      description = "State directory for the netvisor server.";
    };

    server = lib.mkOption {
      description = ''
        NetVisor server configuration
      '';
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
          publicHostname = lib.mkOption {
            type = lib.types.str;
            default = "netvisor";
            description = "Frontend uses this variable to contact backend, variables used for NGINX virtual host.";
          };
          publicPort = lib.mkOption {
            type = lib.types.port;
            default = config.services.nginx.defaultHTTPListenPort;
            defaultText = lib.literalExpression "config.services.nginx.defaultHTTPListenPort";
            description = "Frontend uses this variable to contact backend, needs to be changed if SSL is used.";
          };
          openFirewall = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Open port for the web ui.";
          };
          port = lib.mkOption {
            type = lib.types.port;
            default = 60072;
            description = "Port for the server to listen on.";
          };
          useSecureSessionCookies = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable secure session cookies for HTTPS deployments.";
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
            description = "Flag to disable new user registration";
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

    daemon = lib.mkOption {
      description = ''
        NetVisor daemon configuration
      '';
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
            description = ''
              API key for daemon authentication with server (generated via UI).
            '';
          };
          serverTarget = lib.mkOption {
            type = lib.types.str;
            default = if cfg.server.enable then "http://127.0.0.1" else null;
            defaultText = lib.literalExpression ''if config.server.enable then "http://127.0.0.1" else null'';
            description = "IP address or hostname of the NetVisor server.";
          };
          serverPort = lib.mkOption {
            type = lib.types.port;
            default = 60072;
            description = "Port the NetVisor server is listening on.";
          };
          bindAddress = lib.mkOption {
            type = lib.types.str;
            default = "127.0.0.1";
            description = "IP address to bind the daemon to.";
          };
          port = lib.mkOption {
            type = lib.types.port;
            default = 60073;
            description = "Port for the daemon to listen on.";
          };
          name = lib.mkOption {
            type = lib.types.str;
            default = "netvisor-daemon";
            description = "Human-readable name for this daemon instance.";
          };
          networkId = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "Network ID to report discoveries to.";
          };
          heartbeatInterval = lib.mkOption {
            type = lib.types.int;
            default = 30;
            description = "Seconds between heartbeat updates to the server.";
          };
          concurrentScans = lib.mkOption {
            type = lib.types.int;
            default = 15;
            description = "Maximum number of hosts to scan in parallel during discovery.";
          };
          dockerProxy = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "Optional HTTP proxy to use to connect to docker.";
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

        virtualHosts."${cfg.server.publicHostname}" = lib.mkMerge [
          cfg.server.nginx
          {
            root = lib.mkForce "${package.ui}/html";

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
          ExecStart = "${lib.getExe' package "server"} ${serverArgs}";
          User = cfg.user;
          Group = cfg.group;
        };
      };

      netvisor-daemon = lib.mkIf cfg.daemon.enable {
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          ExecStart = "${lib.getExe' package "daemon"} ${daemonArgs}";
          User = cfg.user;
          Group = cfg.group;
        };
      };
    };

    networking.firewall = lib.mkIf cfg.server.openFirewall {
      allowedTCPPorts = [ cfg.server.port ];
    };
  };
}
