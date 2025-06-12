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
  cfgFile = format.generate "config.yml" (lib.attrsets.recursiveUpdate pangolinConf cfg.settings);

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
      external_port = cfg.externalPort;
      internal_port = cfg.internalPort;
      next_port = cfg.nextPort;
      internal_hostname = "localhost";
      session_cookie_name = "p_session_token";
      resource_access_token_param = "p_token";
      resource_access_token_headers = {
        id = "P-Access-Token-Id";
        token = "P-Access-Token";
      };
      resource_session_request_param = "p_session_request";
      cors = {
        origins = [ "https://${cfg.dashboardDomain}" ];
        methods = [
          "GET"
          "POST"
          "PUT"
          "DELETE"
          "PATCH"
        ];
        headers = [
          "X-CSRF-Token"
          "Content-Type"
        ];
        credentials = false;
      };
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
      use_subdomain = true;
    };
    rate_limits.global = {
      window_minutes = 1;
      max_requests = 500;
    };
    users.server_admin = {
      email = cfg.letsEncryptEmail;
      password = "Password123!"; # this is a dummy password and is overwritten by the environment variable USERS_SERVERADMIN_PASSWORD declared in pangolinEnvironmentFile
    };
    flags = {
      require_email_verification = false;
      disable_signup_without_invite = true;
      disable_user_create_org = true;
      allow_raw_resources = true;
      allow_base_domain_resources = true;
    };
  };
in
{
  options = {
    services.pangolin = {
      enable = lib.mkEnableOption "Pangolin";
      package = lib.mkPackageOption pkgs "pangolin" { };

      settings = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = { };
        description = ''
          Additional attributes to be merged with the configuration options and written to Pangolin's config.yml file.
        '';
        example = {

        };
      };
      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to open ports 80, 443, and 51820 in the firewall for the Pangolin service(s).
        '';
      };

      baseDomain = lib.mkOption {
        type = lib.types.str;
        default = "example.com";
        description = ''
          Your base fully qualified domain name (without any subdomains).
        '';
        example = "example.com";
      };
      dashboardDomain = lib.mkOption {
        type = lib.types.str;
        default = "pangolin.example.com";
        description = ''
          The domain where the application will be hosted. This is used for many things, including generating links. You can run Pangolin on a subdomain or root domain. Do not prefix with http or https.
        '';
        example = "pangolin.example.com";
      };

      letsEncryptEmail = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = ''
          An email address for SSL certificate registration with Lets Encrypt. This should be an email you have access to.
        '';
      };
      # provide path to file to keep secrets out of the nix store
      pangolinEnvironmentFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = ''
          Path to a file containing sensitive environment variables. See https://docs.fossorial.io/Pangolin/Configuration/config for more information.
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
      gerbilEnvironment = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = { };
        description = ''
          Environment variables Gerbil will use. See https://docs.fossorial.io/Pangolin/Configuration/config for more information.
          These will overwrite anything defined in the config.
        '';
        example = {
          INTERFACE = "wg2";
          MTU = "1280";
          LISTEN = ''"localhost:" + builtins.toString cfg.gerbilPort;'';
        };
      };
      externalPort = lib.mkOption {
        type = lib.types.port;
        default = 3000;
        description = ''
          Specifies the port to listen on for the external server.
        '';
      };
      internalPort = lib.mkOption {
        type = lib.types.port;
        default = 3001;
        description = ''
          Specifies the port to listen on for the internal server.
        '';
      };
      nextPort = lib.mkOption {
        type = lib.types.port;
        default = 3002;
        description = ''
          Specifies the port to listen on for the nextjs frontend.
        '';
      };
      gerbilPort = lib.mkOption {
        type = lib.types.port;
        default = 3003;
        description = ''
          Specifies the port to listen on for Gerbil.
        '';
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

    assertions = map (opt: {
      assertion = cfg.${opt} != null;
      message = "services.pangolin.${opt} must be provided when Pangolin is enabled.";
    }) (builtins.attrNames cfg);

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
          mode = "0771";
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
            BindPaths = [
              "${pkgs.fosrl-pangolin}/.next:${cfg.dataDir}/.next"
              "${pkgs.fosrl-pangolin}/public:${cfg.dataDir}/public"
              "${pkgs.fosrl-pangolin}/dist:${cfg.dataDir}/dist"
              "${pkgs.fosrl-pangolin}/node_modules:${cfg.dataDir}/node_modules"
            ];
            ExecStartPre = utils.escapeSystemdExecArgs [
              (lib.getExe pkgs.nodejs_22)
              "${pkgs.fosrl-pangolin}/dist/migrations.mjs"
            ];
            ExecStart = utils.escapeSystemdExecArgs [
              (lib.getExe pkgs.nodejs_22)
              "${pkgs.fosrl-pangolin}/dist/server.mjs"
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

          environment = {
            LISTEN = "localhost:" + builtins.toString cfg.gerbilPort;
          } // cfg.gerbilEnvironment;

          serviceConfig = {
            User = "gerbil";
            Group = "fossorial";
            WorkingDirectory = cfg.dataDir;
            Restart = "always";
            AmbientCapabilities = [
              "CAP_NET_ADMIN"
              "CAP_SYS_MODULE"
            ];
            CapabilityBoundingSet = [
              "CAP_NET_ADMIN"
              "CAP_SYS_MODULE"
            ];

            ExecStart = utils.escapeSystemdExecArgs [
              (lib.getExe pkgs.fosrl-gerbil)
              "--reachableAt=http://localhost:${builtins.toString cfg.gerbilPort}"
              "--generateAndSaveKeyTo=${builtins.toString cfg.dataDir}/config/key"
              "--remoteConfig=http://localhost:${builtins.toString cfg.internalPort}/api/v1/gerbil/get-config"
              "--reportBandwidthTo=http://localhost:${builtins.toString cfg.internalPort}/api/v1/gerbil/receive-bandwidth"
            ];
          };
        };
        # make sure traefik places plugins in local dir instead of /
        traefik.serviceConfig.WorkingDirectory = "${cfg.dataDir}/config/traefik";
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
            endpoint = "http://localhost:${builtins.toString cfg.internalPort}/api/v1/traefik-config";
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
            acme = {
              httpChallenge.entryPoint = "web";
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
              tls.certResolver = "letsencrypt";
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
              { url = "http://localhost:${builtins.toString cfg.nextPort}"; }
            ]; # Next.js server
            api-service.loadBalancer.servers = [
              { url = "http://localhost:${builtins.toString cfg.externalPort}"; }
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
