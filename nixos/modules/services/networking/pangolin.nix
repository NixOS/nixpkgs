{
  utils,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.pangolin;
  format = pkgs.formats.yaml { };
  finalSettings = lib.attrsets.recursiveUpdate pangolinConf cfg.settings;
  cfgFile = format.generate "config.yml" finalSettings;

  pangolinConf = {
    app = {
      dashboard_url = "https://${cfg.dashboardDomain}";
      log_level = "info";
      save_logs = false;
    };
    domains.domain1 = {
      base_domain = cfg.baseDomain;
      cert_resolver = "letsencrypt";
      prefer_wildcard_cert = false;
    };
    server = {
      external_port = 3000;
      internal_port = 3001;
      next_port = 3002;
      internal_hostname = "localhost";
      session_cookie_name = "p_session_token";
      resource_access_token_param = "p_token";
      resource_access_token_headers = {
        id = "P-Access-Token-Id";
        token = "P-Access-Token";
      };
      resource_session_request_param = "p_session_request";
    };
    traefik = {
      cert_resolver = "letsencrypt";
      http_entrypoint = "web";
      https_entrypoint = "websecure";
    };
    gerbil = {
      start_port = 51820;
      base_endpoint = cfg.dashboardDomain;
      block_size = 24;
      site_block_size = 30;
      subnet_group = "100.89.128.1/24";
      use_subdomain = false;
    };
    rate_limits.global = {
      window_minutes = 1;
      max_requests = 500;
    };
    users.server_admin = {
      email = cfg.letsEncryptEmail;
      password = "Password123!"; # this is a dummy password and is overwritten by the environment variable USERS_SERVERADMIN_PASSWORD declared in pangolinEnvironmentFile
    };
  };
in
{
  options = {
    services.pangolin = {
      enable = lib.mkEnableOption "Pangolin";
      package = lib.mkPackageOption pkgs "fosrl-pangolin" { };

      settings = lib.mkOption {
        inherit (format) type;
        default = { };
        description = ''
          Additional attributes to be merged with the configuration options and written to Pangolin's config.yml file.
        '';
        example = {
          app = {
            save_logs = true;
          };
          server = {
            external_port = 3007;
            internal_port = 3008;
          };
          domains.domain1 = {
            prefer_wildcard_cert = true;
          };
        };
      };

      openFirewall = lib.mkEnableOption "opening TCP ports 80 and 443, and UDP port 51820 in the firewall for the Pangolin service(s).";

      baseDomain = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = ''
          Your base fully qualified domain name (without any subdomains).
        '';
        example = "example.com";
      };

      dashboardDomain = lib.mkOption {
        type = lib.types.str;
        default = if (isNull cfg.baseDomain) then "" else "pangolin.${cfg.baseDomain}";
        defaultText = "pangolin.\${config.services.pangolin.baseDomain}";
        description = ''
          The domain where the application will be hosted. This is used for many things, including generating links. You can run Pangolin on a subdomain or root domain. Do not prefix with http or https.
        '';
        example = "auth.example.com";
      };

      letsEncryptEmail = lib.mkOption {
        type = with lib.types; nullOr str;
        default = config.security.acme.defaults.email;
        defaultText = lib.literalExpression "config.security.acme.defaults.email";
        description = ''
          An email address for SSL certificate registration with Let's Encrypt. This should be an email you have access to.
        '';
      };

      # this assumes that all domains are hosted by the same provider
      dnsProvider = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = ''
          The dnsProvider Traefik will request wildcard certificates from. See https://doc.traefik.io/traefik/https/acme/#providers
          for more information. If enabled, the environment variable(s) specified in the documentation must be provided.
        '';
      };

      # provide path to file to keep secrets out of the nix store
      pangolinEnvironmentFile = lib.mkOption {
        type = with lib.types; nullOr path;
        default = null;
        description = ''
          Path to a file containing sensitive environment variables for Pangolin. See https://docs.fossorial.io/Pangolin/Configuration/config for more information.
          These will overwrite anything defined in the config.
          The password must meet the following requirements:
            At least 8 characters
            At least one uppercase letter
            At least one lowercase letter
            At least one digit
            At least one special character

          The file should contain environment-variable assignments like:
          USERS_SERVERADMIN_EMAIL=mysecretemail
          USERS_SERVERADMIN_PASSWORD=mysecretpassword
        '';
        example = "/etc/nixos/secrets/pangolin.env";
      };

      gerbilPort = lib.mkOption {
        type = lib.types.port;
        default = 3003;
        description = ''
          Specifies the port to listen on for Gerbil.
        '';
      };

      gerbilEnvironmentFile = lib.mkOption {
        type = with lib.types; nullOr path;
        default = null;
        description = ''
          Path to a file containing sensitive environment variables for Gerbil. See https://docs.fossorial.io/Pangolin/Configuration/config for more information.
          These will overwrite anything defined in the config.
        '';
        example = "/etc/nixos/secrets/gerbil.env";
      };

      traefikEnvironmentFile = lib.mkOption {
        type = with lib.types; nullOr path;
        default = null;
        description = ''
          Path to a file containing sensitive environment variables for Traefik. See https://docs.fossorial.io/Pangolin/Configuration/config for more information.
          These will overwrite anything defined in the config.
        '';
        example = "/etc/nixos/secrets/traefik.env";
      };

      dataDir = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/pangolin";
        example = "/srv/pangolin";
        description = "Path to variable state data directory for Pangolin.";
      };
    };
  };

  config = lib.mkIf cfg.enable {

    assertions =
      map
        (opt: {
          assertion = cfg.${opt} != null;
          message = "services.pangolin.${opt} must be provided when Pangolin is enabled.";
        })
        (
          builtins.filter (
            attrName:
            !builtins.elem attrName [
              "gerbilEnvironmentFile"
              "dnsProvider"
              "traefikEnvironmentFile"
            ]
          ) (builtins.attrNames cfg)
        )
      ++ [
        {
          # wildcards implies (dnsProvider and traefikEnvironmentFile)
          assertion =
            finalSettings.domains.domain1.prefer_wildcard_cert
            -> (cfg.dnsProvider != "" && cfg.traefikEnvironmentFile != null);
          message = "services.pangolin.dnsProvider and traefikEnvironmentFile must be provided when prefer_wildcard_cert is true.";
        }
      ];

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [
        80
        443
      ];
      allowedUDPPorts = [ 51820 ];
    };

    users = {
      users = {
        pangolin = {
          description = "Pangolin service user";
          group = "fossorial";
          isSystemUser = true;
        };
        gerbil = {
          description = "Gerbil service user";
          group = "fossorial";
          isSystemUser = true;
        };
      };
      groups.fossorial = {
        members = [
          "pangolin"
          "gerbil"
          "traefik"
        ];
      };
    };
    # order is as follows
    # "pangolin.service"
    # "gerbil.service"
    # "traefik.service"
    ### TODO:
    # make tunnels declarative by calling API
    ###
    systemd = {
      tmpfiles.settings."10-fossorial-paths" = {
        "${cfg.dataDir}".d = {
          user = "pangolin";
          group = "fossorial";
          mode = "0770";
        };
        "${cfg.dataDir}/config".d = {
          user = "pangolin";
          group = "fossorial";
          mode = "0770";
        };
        "${cfg.dataDir}/config/letsencrypt".d = {
          user = "traefik";
          group = "traefik";
          mode = "0700";
        };
      };
      services = {
        pangolin = {
          description = "Pangolin reverse proxy tunneling service";
          wantedBy = [ "multi-user.target" ];
          requires = [ "network.target" ];
          after = [ "network.target" ];

          environment = {
            NODE_OPTIONS = "enable-source-maps";
            NODE_ENV = "development";
            ENVIRONMENT = "prod";
          };

          preStart = ''
            mkdir -p ${cfg.dataDir}/config
            touch ${cfg.dataDir}/config/config.yml
            cp ${cfgFile} ${cfg.dataDir}/config/config.yml
          '';

          serviceConfig = {
            User = "pangolin";
            Group = "fossorial";
            WorkingDirectory = cfg.dataDir;
            Restart = "always";
            EnvironmentFile = cfg.pangolinEnvironmentFile;
            # hardening
            ProtectSystem = "full";
            ProtectHome = true;
            PrivateTmp = "disconnected";
            PrivateDevices = true;
            PrivateMounts = true;
            ProtectKernelTunables = true;
            ProtectKernelModules = true;
            ProtectKernelLogs = true;
            ProtectControlGroups = true;
            LockPersonality = true;
            RestrictRealtime = true;
            ProtectClock = true;
            ProtectProc = "noaccess";
            ProtectHostname = true;
            NoNewPrivileges = true;
            RestrictSUIDSGID = true;
            RestrictAddressFamilies = [
              "AF_INET"
              "AF_INET6"
              "AF_NETLINK"
              "AF_UNIX"
            ];
            SocketBindDeny = [
              "ipv4:tcp"
              "ipv4:udp"
              "ipv6:udp"
            ];
            CapabilityBoundingSet = [
              "~CAP_BLOCK_SUSPEND"
              "~CAP_BPF"
              "~CAP_CHOWN"
              "~CAP_MKNOD"
              "~CAP_NET_RAW"
              "~CAP_PERFMON"
              "~CAP_SYS_BOOT"
              "~CAP_SYS_CHROOT"
              "~CAP_SYS_MODULE"
              "~CAP_SYS_NICE"
              "~CAP_SYS_PACCT"
              "~CAP_SYS_PTRACE"
              "~CAP_SYS_TIME"
              "~CAP_SYSLOG"
              "~CAP_WAKE_ALARM"
            ];
            SystemCallFilter = [
              "~@chown:EPERM"
              "~@clock:EPERM"
              "~@cpu-emulation:EPERM"
              "~@debug:EPERM"
              "~@keyring:EPERM"
              "~@memlock:EPERM"
              "~@module:EPERM"
              "~@mount:EPERM"
              "~@obsolete:EPERM"
              "~@pkey:EPERM"
              "~@privileged:EPERM"
              "~@raw-io:EPERM"
              "~@reboot:EPERM"
              "~@resources:EPERM"
              "~@sandbox:EPERM"
              "~@setuid:EPERM"
              "~@swap:EPERM"
              "~@timer:EPERM"
            ];
            BindPaths = [
              "${cfg.package}/.next:${cfg.dataDir}/.next"
              "${cfg.package}/public:${cfg.dataDir}/public"
              "${cfg.package}/dist:${cfg.dataDir}/dist"
              "${cfg.package}/node_modules:${cfg.dataDir}/node_modules"
            ];
            ExecStartPre = utils.escapeSystemdExecArgs [
              (lib.getExe pkgs.nodejs_22)
              "${cfg.package}/dist/migrations.mjs"
            ];
            ExecStart = utils.escapeSystemdExecArgs [
              (lib.getExe pkgs.nodejs_22)
              "${cfg.package}/dist/server.mjs"
            ];
          };
        };
        gerbil = {
          description = "Gerbil Service";
          wantedBy = [ "multi-user.target" ];
          after = [ "pangolin.service" ];
          requires = [ "pangolin.service" ];
          before = [ "traefik.service" ];
          requiredBy = [ "traefik.service" ];

          # provide default to use correct port without envfile
          environment = {
            LISTEN = "localhost:" + builtins.toString cfg.gerbilPort;
          };

          serviceConfig = {
            User = "gerbil";
            Group = "fossorial";
            WorkingDirectory = cfg.dataDir;
            Restart = "always";
            EnvironmentFile = cfg.gerbilEnvironmentFile;
            ReadWritePaths = "${cfg.dataDir}/config";
            # hardening
            AmbientCapabilities = [
              "CAP_NET_ADMIN"
              "CAP_SYS_MODULE"
            ];
            CapabilityBoundingSet = [
              "CAP_NET_ADMIN"
              "CAP_SYS_MODULE"
              "~CAP_BLOCK_SUSPEND"
              "~CAP_BPF"
              "~CAP_CHOWN"
              "~CAP_MKNOD"
              "~CAP_PERFMON"
              "~CAP_SYS_BOOT"
              "~CAP_SYS_CHROOT"
              "~CAP_SYS_NICE"
              "~CAP_SYS_PACCT"
              "~CAP_SYS_PTRACE"
              "~CAP_SYS_TIME"
              "~CAP_SYS_TTY_CONFIG"
              "~CAP_SYSLOG"
              "~CAP_WAKE_ALARM"
            ];
            ProtectSystem = "full";
            ProtectHome = true;
            PrivateTmp = "disconnected";
            PrivateDevices = true;
            PrivateMounts = true;
            ProtectKernelTunables = true;
            ProtectKernelModules = true;
            ProtectKernelLogs = true;
            ProtectControlGroups = true;
            LockPersonality = true;
            RestrictRealtime = true;
            ProtectClock = true;
            ProtectProc = "hidden";
            ProtectHostname = true;
            NoNewPrivileges = true;
            RestrictSUIDSGID = true;
            MemoryDenyWriteExecute = true;
            RestrictAddressFamilies = [
              "AF_INET"
              "AF_INET6"
              "AF_NETLINK"
              "AF_UNIX"
            ];
            SystemCallFilter = [
              "~@aio:EPERM"
              "~@chown:EPERM"
              "~@clock:EPERM"
              "~@cpu-emulation:EPERM"
              "~@debug:EPERM"
              "~@keyring:EPERM"
              "~@memlock:EPERM"
              "~@mount:EPERM"
              "~@obsolete:EPERM"
              "~@pkey:EPERM"
              "~@privileged:EPERM"
              "~@raw-io:EPERM"
              "~@reboot:EPERM"
              "~@resources:EPERM"
              "~@sandbox:EPERM"
              "~@setuid:EPERM"
              "~@swap:EPERM"
              "~@sync:EPERM"
              "~@timer:EPERM"
            ];

            ExecStart = utils.escapeSystemdExecArgs [
              (lib.getExe pkgs.fosrl-gerbil)
              "--reachableAt=http://localhost:${builtins.toString cfg.gerbilPort}"
              "--generateAndSaveKeyTo=${builtins.toString cfg.dataDir}/config/key"
              "--remoteConfig=http://localhost:${builtins.toString finalSettings.server.internal_port}/api/v1/gerbil/get-config"
              "--reportBandwidthTo=http://localhost:${builtins.toString finalSettings.server.internal_port}/api/v1/gerbil/receive-bandwidth"
            ];
          };
        };
        # make sure traefik places plugins in local dir instead of /
        traefik.serviceConfig = {
          EnvironmentFile = cfg.traefikEnvironmentFile;
          WorkingDirectory = "${cfg.dataDir}/config/traefik";
        };
      };
    };

    services.traefik = {
      enable = true;
      group = "fossorial";
      dataDir = "${cfg.dataDir}/config/traefik";
      staticConfigOptions = {
        api = {
          insecure = true;
          dashboard = true;
        };
        providers = {
          http = {
            endpoint = "http://localhost:${builtins.toString finalSettings.server.internal_port}/api/v1/traefik-config";
            pollInterval = "5s";
          };
        };
        experimental.plugins.badger = {
          moduleName = "github.com/fosrl/badger";
          version = "v1.1.0";
        };
        log = {
          level = "INFO";
          format = "common";
        };
        certificatesResolvers = {
          letsencrypt = {
            acme =
              if (finalSettings.domains.domain1.prefer_wildcard_cert) then
                {
                  # see https://doc.traefik.io/traefik/https/acme/#providers
                  dnsChallenge.provider = cfg.dnsProvider;
                }
              else
                {
                  httpChallenge.entryPoint = "web";
                }
                //
                  # common
                  {
                    email = cfg.letsEncryptEmail;
                    storage = "${cfg.dataDir}/config/letsencrypt/acme.json";
                    caServer = "https://acme-v02.api.letsencrypt.org/directory";
                  };
          };
        };
        entryPoints = {
          web.address = ":80";
          websecure = {
            address = ":443";
            transport.respondingTimeouts.readTimeout = "30m";
            http.tls.certResolver = "letsencrypt";
          };
        };
        serversTransport.insecureSkipVerify = true;
      };
      dynamicConfigOptions = {
        http = {
          middlewares.redirect-to-https.redirectScheme.scheme = "https";
          routers = {
            # HTTP to HTTPS redirect router
            main-app-router-redirect = {
              rule = "Host(`${cfg.dashboardDomain}`)";
              service = "next-service";
              entryPoints = [ "web" ];
              middlewares = [ "redirect-to-https" ];
            };
            # Next.js router (handles everything except API and WebSocket paths)
            next-router = {
              rule = "Host(`${cfg.dashboardDomain}`) && !PathPrefix(`/api/v1`)";
              service = "next-service";
              entryPoints = [ "websecure" ];
              tls =
                lib.optionalAttrs (finalSettings.domains.domain1.prefer_wildcard_cert) {
                  domains = [
                    { main = cfg.baseDomain; }
                    { sans = "*.${cfg.baseDomain}"; }
                  ];
                }
                //
                # common
                {
                  certResolver = "letsencrypt";
                };
            };
            # API router (handles /api/v1 paths)
            api-router = {
              rule = "Host(`${cfg.dashboardDomain}`) && PathPrefix(`/api/v1`)";
              service = "api-service";
              entryPoints = [ "websecure" ];
              tls.certResolver = "letsencrypt";
            };
            # WebSocket router
            ws-router = {
              rule = "Host(`${cfg.dashboardDomain}`)";
              service = "api-service";
              entryPoints = [ "websecure" ];
              tls.certResolver = "letsencrypt";
            };
          };
          services = {
            next-service.loadBalancer.servers = [
              { url = "http://localhost:${builtins.toString finalSettings.server.next_port}"; }
            ]; # Next.js server
            api-service.loadBalancer.servers = [
              { url = "http://localhost:${builtins.toString finalSettings.server.external_port}"; }
            ]; # API/WebSocket server
          };
        };
      };
    };
  };

  meta.maintainers = with lib.maintainers; [
    jackr
    sigmasquadron
  ];
}
