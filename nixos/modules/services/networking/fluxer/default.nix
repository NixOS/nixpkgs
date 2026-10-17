{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    mkOption
    mkDefault
    types
    toUpper
    join
    ;

  cfg = config.services.fluxer;
  settingsType = (pkgs.formats.json { }).type; # Not really json but a useful shorthand for supported values
  mkPartEnableOption =
    name:
    lib.mkOption {
      description = "Configure ${name} for use with fluxer";
      type = types.bool;
      default = cfg.enable;
      defaultText = "config.services.fluxer.enable";
    };
  mkPartSettingsOptions =
    name: default:
    lib.mkOption {
      description = ''
        Configuration for ${name}. See https://docs.fluxer.app/operator/configuration/
        for supported values.

        Values configured here will be converted to environment variables by
        - converting their name to upper case
        - concatenating nested options with _
        - prefixing them with FLUXER_
        and passed to ${name}.

        For example, `svc.port` becomes `FLUXER_SVC_PORT`.

        For global configuration, consider `config.services.fluxer.settings`.
      '';
      type = types.submodule {
        freeformType = settingsType;
        config = default; # Put here so we don't accidentally overwrite the entirety of the defaults
      };
      default = { };
    };
  mkSvcOptions = name: {
    settings = mkPartSettingsOptions name cfg.settings;
    router = {
      enable = mkPartEnableOption "fluxer-${name} router";
      settings = mkPartSettingsOptions "fluxer-${name} router" cfg.${name}.settings;
    };
    shard = {
      enable = mkPartEnableOption "fluxer-${name} shard";
      settings = mkPartSettingsOptions "fluxer-${name} shard" cfg.${name}.settings;
    };
  };
  mkSvcOptionsWithUser = name: {
    settings = mkPartSettingsOptions name cfg.settings;
    router = {
      enable = mkPartEnableOption "${name} router";
      settings = mkPartSettingsOptions "${name} router" cfg.${name}.settings;
    };
    shard = {
      enable = mkPartEnableOption "${name} shard";
      settings = mkPartSettingsOptions "${name} shard" cfg.${name}.settings;
      user = mkOption {
        description = ''
          The user to run the fluxer-messages shard service as.
          Set to null to run as dynamic user.
        '';
        type = types.nullOr types.str;
        default = if cfg.aux.pgsql.enable then "fluxer" else null;
        defaultText = "'fluxer', if automatic postgres is enabled, otherwise null";
      };
    };
  };

  portSuffix =
    if cfg.settings.public_scheme == "http" && cfg.settings.public_port == 80 then
      ""
    else if cfg.settings.public_scheme == "https" && cfg.settings.public_port == 443 then
      ""
    else
      ":${toString cfg.settings.public_port}";

  # Config massage
  pathToEnvVar = path: toUpper (join "_" ([ "fluxer" ] ++ path));
  # secrets can be passed as ENV_VAR_FILE=...
  # we remap these to take advantage of LoadCredential
  isSecret = value: builtins.isAttrs value && value ? file;

  settingsToEnvVars =
    attrs:
    let
      nonSecretAttrs = lib.filterAttrsRecursive (n: v: !isSecret v) attrs;
    in
    lib.listToAttrs (
      (lib.mapAttrsToListRecursiveCond (n: v: !lib.isDerivation v) (
        path: value: lib.nameValuePair (pathToEnvVar path) (toString value)
      ) nonSecretAttrs)
      ++ (remapSecretEnvVars attrs)
    )
    // {
      LOG_LEVEL = mkIf (cfg.log_level != null) cfg.log_level;
      RUST_LOG = mkIf (cfg.log_level != null) cfg.log_level;
      DISCOVERY_UPSTREAM_URL = "${cfg.settings.internal.api_endpoint}/.well-known/fluxer";
    };
  collectSecrets =
    pathSoFar: value:
    if lib.isDerivation value || !builtins.isAttrs value then
      [ ]
    else if value ? file then
      {
        path = pathSoFar ++ [ "file" ];
        value = value.file;
      }
    else
      lib.flatten (lib.mapAttrsToList (name: inner: collectSecrets (pathSoFar ++ [ name ]) inner) value);
  loadCredential =
    attrs:
    let
      secrets = collectSecrets [ ] attrs;
    in
    map ({ path, value }: "${pathToEnvVar path}:${value}") secrets;
  remapSecretEnvVars =
    attrs:
    let
      secrets = collectSecrets [ ] attrs;
    in
    map ({ path, ... }: lib.nameValuePair (pathToEnvVar path) "%d/${pathToEnvVar path}") secrets;

  standardSystemdSettings = {
    confinement = {
      #enable = true;
    };

    unitConfig = {
      StartLimitBurst = "5";
      StartLimitIntervalSec = "2m";
    };

    serviceConfig = {
      Type = "simple";
      Restart = "on-failure";
      RestartSec = "5s";
      RestartMaxDelaySec = "60s";
      RestartSteps = "4";

      BindReadOnlyPaths = [
        "/etc/resolv.conf"
        "/etc/hosts"
        "/etc/nsswitch.conf"
        "/etc/ssl/certs"
      ];

      ProtectHome = true;
      ProtectSystem = "full";
      ProtectProc = "invisible";
      PrivateTmp = true;
      DynamicUser = true;

      NoNewPrivileges = true;
      CapabilityBoundingSet = [ "~" ];
      PrivateDevices = true;
      ProtectHostname = true;
      ProtectClock = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectKernelLogs = true;
      ProtectControlGroups = "strict";
      RestrictAddressFamilies = [
        "AF_UNIX"
        "AF_INET"
        "AF_INET6"
      ];
      RestrictNamespaces = true;
      LockPersonality = true;
      RemoveIPC = true;
      PrivateMounts = true;
      SystemCallFilter = [
        "~@cpu-emulation @debug @keyring @mount @obsolete @privileged @setuid"
      ];
      SystemCallErrorNumber = "EPERM";
      SystemCallArchitectures = "native";
    };
  };

  settingsTools = {
    inherit
      settingsToEnvVars
      loadCredential
      standardSystemdSettings
      ;
  };

  mkSvc = import ./svc.nix settingsTools;
in
{
  imports = [
    (mkSvc {
      name = "gifs";
      description = "gif search and proxy service";
      defaultPort = cfg.settings.api.port + 10;
    })
    (mkSvc {
      name = "messages";
      description = "message storage service";
      defaultPort = cfg.settings.api.port + 12;
      needsPostgres = true;
    })
    (mkSvc {
      name = "snowflakes";
      description = "snowflake service";
      defaultPort = cfg.settings.api.port + 14;
    })
    (mkSvc {
      name = "unfurl";
      description = "link unfurling/embedding service";
      defaultPort = cfg.settings.api.port + 16;
    })
    (mkSvc {
      name = "users";
      description = "user storage service";
      defaultPort = cfg.settings.api.port + 18;
      needsPostgres = true;
    })
    (import ./seaweedfs.nix settingsTools)
    (import ./api.nix settingsTools)
    (import ./admin.nix settingsTools)
    (import ./gateway.nix settingsTools)
    (import ./media-proxy.nix settingsTools)
    (import ./push.nix settingsTools)
    (import ./app-proxy.nix settingsTools)
  ];

  options.services.fluxer = {
    enable = lib.mkEnableOption "Fluxer Instant Messaging and VoIP Platform";
    openFirewall = lib.mkOption {
      description = ''
        Open the ports required for fluxer, specifically:
        - the livekit TCP and UDP ports
      '';
      type = types.bool;
      default = true;
      example = false;
    };
    log_level = mkOption {
      description = ''
        Log level of the services.

        Note that this sets different options on different services.
        Common log levels should work with this, but if you want
        to make full use of e.g. RUST_LOG's filtering you may want
        to set this to `null` and configure logging on the service directly.

        See https://docs.fluxer.app/operator/configuration/#logging-and-build-metadata
        for more details.
      '';
      type = types.nullOr types.str;
      default = "info";
      example = "warn";
    };
    settings = lib.mkOption {
      description = ''
        Configuration for all fluxer services. See https://docs.fluxer.app/operator/configuration/
        for supported values.

        Values configured here will be converted to environment variables by
        - converting their name to upper case
        - concatenating nested options with _
        - prefixing them with FLUXER_
        and passed to all services.

        For example, `svc.port` becomes `FLUXER_SVC_PORT`.
      '';
      type = types.submodule (
        args:
        let
          subconfig = args.config;
        in
        {
          freeformType = settingsType;

          options = {
            domain = mkOption {
              description = "The public-facing domain name of fluxer";
              type = types.str;
              example = "fluxer.example.com";
            };
            base_domain = mkOption {
              internal = true;
              default = subconfig.domain;
            };
            public_scheme = mkOption {
              description = "The default scheme for fluxer";
              type = types.enum [
                "http"
                "https"
              ];
              default = "https";
              visible = false;
            };
            public_port = mkOption {
              description = "The default port for fluxer";
              type = types.port;
              default = 443;
              visible = false;
            };
            public_origin = mkOption {
              description = "The origin for fluxer, i.e. scheme://domain:port";
              type = types.str;
              default = "${cfg.settings.public_scheme}://${cfg.settings.domain}${portSuffix}";
              readOnly = true;
              visible = false;
            };

            api = {
              port = mkOption {
                description = "The internal listening port of the api service";
                type = types.port;
                default = 10000;
                example = 8080;
              };
            };
            admin = {
              host = mkOption {
                description = "The internal listening address of the admin service";
                type = types.str;
                default = "127.0.0.1";
                example = "0.0.0.0";
              };
              port = mkOption {
                description = "The internal listening port of the admin service";
                type = types.port;
                default = cfg.settings.api.port + 1;
                defaultText = lib.literalExpression "cfg.settings.api.port + 1";
                example = 8081;
              };
              base_path = mkOption {
                description = "The base path under which the admin service is hosted";
                type = types.str;
                default = "/admin";
                example = "/";
                visible = false;
              };
            };
            gateway = {
              port = mkOption {
                description = "The internal listening port of the gateway service";
                type = types.port;
                default = cfg.settings.api.port + 2;
                defaultText = lib.literalExpression "cfg.settings.api.port + 2";
                example = 8082;
              };
            };
            media_proxy = {
              host = mkOption {
                description = "The internal listening address of the media-proxy service";
                type = types.str;
                default = "127.0.0.1";
                example = "0.0.0.0";
              };
              port = mkOption {
                description = "The internal listening port of the media-proxy service";
                type = types.port;
                default = cfg.settings.api.port + 3;
                defaultText = lib.literalExpression "cfg.settings.api.port + 3";
                example = 8083;
              };
            };
            app_proxy = {
              host = mkOption {
                description = "The internal listening address of the app-proxy service";
                type = types.str;
                default = "127.0.0.1";
                example = "0.0.0.0";
              };
              port = mkOption {
                description = "The internal listening port of the app-proxy service";
                default = cfg.settings.api.port + 4;
                defaultText = lib.literalExpression "cfg.settings.api.port + 4";
                example = 8084;
              };
            };
            push_service = {
              host = mkOption {
                description = "The internal listening address of the push notification service";
                type = types.str;
                default = "127.0.0.1";
                example = "0.0.0.0";
              };
              port = mkOption {
                description = ''
                  The internal listening port of the push notification service.
                '';
                default = cfg.settings.api.port + 5;
                defaultText = lib.literalExpression "cfg.settings.api.port + 5";
                example = 8085;
              };
            };
          };
        }
      );
      default = { };
    };
    api = {
      enable = mkPartEnableOption "fluxer-api";
      user = mkOption {
        description = ''
          The user to run the fluxer-messages shard service as.
          Set to null to run as dynamic user.
        '';
        type = types.nullOr types.str;
        default = if cfg.aux.pgsql.enable then "fluxer" else null;
        defaultText = "'fluxer', if automatic postgres is enabled, otherwise null";
      };
      settings = mkPartSettingsOptions "fluxer-api" cfg.settings;
    };
    admin = {
      enable = mkPartEnableOption "fluxer-admin";
      settings = mkPartSettingsOptions "fluxer-admin" cfg.settings;
    };
    gateway = {
      enable = mkPartEnableOption "fluxer-gateway";
      settings = mkPartSettingsOptions "fluxer-gateway" cfg.settings;
    };
    media-proxy = {
      enable = mkPartEnableOption "fluxer-media-proxy";
      settings = mkPartSettingsOptions "fluxer-media-proxy" cfg.settings;
    };
    push = {
      enable = mkPartEnableOption "fluxer-push";
      settings = mkPartSettingsOptions "fluxer-push" cfg.settings;
    };
    app-proxy = {
      enable = mkPartEnableOption "fluxer-app-proxy";
      settings = mkPartSettingsOptions "fluxer-app-proxy" cfg.settings;
    };

    gifs = mkSvcOptions "gifs";
    messages = mkSvcOptionsWithUser "messages";
    snowflakes = mkSvcOptions "snowflakes";
    unfurl = mkSvcOptions "unfurl";
    users = mkSvcOptionsWithUser "users";

    aux = {
      nats = {
        enable = lib.mkEnableOption "Nats for use with fluxer";
        authTokenBcrypt = mkOption {
          description = ''
            The access token for nats, in bcrypt format. Use `nats server passwd` to generate.

            Set `config.fluxer.settings.nats.auth_token.file` to a file containing the clear-text
            version of this token.
          '';
          type = types.str;
          example = "$2a$11$4I9tIK1JVbttZYtn.F.Jse5iY5ves4EtYWIpjlwyvgVYHJc8yTvk.";
        };
      };
      pgsql.enable = lib.mkEnableOption ''
        Postgres for use with fluxer.

        If postgres is enabled, then local services will attempt
        to connect via unix socket using peer authentication. If
        you would like to deviate from this, please configure
        postgres manually.  
      '';
      valkey.enable = lib.mkEnableOption ''
        Valkey for use with fluxer.

        This internally uses the redis module with a package override
        for valkey. If you have other redis instances running, consider
        leaving this option disabled and configuring valkey manually.
      '';
      meilisearch = {
        enable = lib.mkEnableOption "Meilisearch for use with fluxer.";
        masterKeyFile = mkOption {
          description = "Path to a file containing the authentication key for meilisearch.";
          type = types.path;
        };
      };
      seaweedfs.enable = lib.mkEnableOption "SeaweedFS for use with fluxer.";
      livekit = {
        enable = lib.mkEnableOption "Livekit for use with fluxer";
        keyFile = mkOption {
          description = "Path to a file containing the secrets for livekit. See `service.livekit.keyFile`";
          type = types.path;
        };
      };
      caddy.enable = lib.mkEnableOption "Caddy as reverse proxy for fluxer";
      nginx.enable = lib.mkEnableOption "Nginx as reverse proxy for fluxer";
    };
  };

  config = {
    systemd.targets."fluxer" = {
      enable = cfg.enable;
      wantedBy = [ "network-online.target" ];
    };
    systemd.targets."fluxer-svc" = {
      enable = cfg.enable;
      wantedBy = [ "fluxer.target" ];
    };

    services.nats = mkIf (cfg.enable && cfg.aux.nats.enable) {
      enable = true;
      jetstream = true;
      settings.host = "localhost";
      settings.authorization.token = cfg.aux.nats.authTokenBcrypt;
    };

    services.postgresql = mkIf (cfg.enable && cfg.aux.pgsql.enable) {
      enable = true;
      ensureDatabases = [ "fluxer" ];
      ensureUsers = [
        {
          name = "fluxer";
          ensureDBOwnership = true;
        }
      ];
    };

    services.redis = mkIf (cfg.enable && cfg.aux.valkey.enable) {
      package = pkgs.valkey;
      servers.fluxer = {
        enable = true;
        appendOnly = true;
      };
    };

    services.meilisearch = mkIf (cfg.enable && cfg.aux.meilisearch.enable) {
      enable = true;
      masterKeyFile = cfg.aux.meilisearch.masterKeyFile;
      settings = {
        experimental_dumpless_upgrade = true;
        # upgrade_db = true; # TODO for 26.11 and later
        no_analytics = true;
        env = "production";
      };
    };

    services.livekit = mkIf (cfg.enable && cfg.aux.livekit.enable) {
      enable = true;
      openFirewall = cfg.openFirewall;
      keyFile = cfg.aux.livekit.keyFile;
      settings = {
        port = 7880;
        log_level = "info";
        rtc = {
          tcp_port = 7081;
          use_external_ip = true;
        };
        webhook = {
          urls = [
            "${cfg.settings.internal.api_endpoint}/webhooks/livekit"
          ];
        };
      };
    };

    services.caddy = mkIf (cfg.enable && cfg.aux.caddy.enable) {
      enable = true;
      virtualHosts.${cfg.settings.domain} = {
        extraConfig = ''
          encode ${cfg.settings.edge.encode or "zstd gzip"}

          handle /_health { respond "OK" 200 }

          handle_path /api/* { 
            reverse_proxy ${cfg.settings.internal.api_endpoint} 
          }

          handle /gateway {
            rewrite * / 
            reverse_proxy ${cfg.settings.internal.gateway_endpoint}
          }

          handle_path /gateway/* {
            reverse_proxy ${cfg.settings.internal.gateway_endpoint}
          }

          handle_path /media/* {
            reverse_proxy ${cfg.settings.internal.media_proxy_endpoint}
          }

          handle_path /livekit/* {
            reverse_proxy ${cfg.settings.internal.livekit_endpoint}
          }

          handle /admin {
            rewrite * /
            reverse_proxy ${cfg.settings.internal.admin_endpoint}
          }

          handle_path /admin/* {
            reverse_proxy ${cfg.settings.internal.admin_endpoint}
          }

          @staticAssets path /web/* /emoji/* /libs/* /avatars/* /badges/* /desktop/*
          handle @staticAssets {
            root * ${pkgs.fluxer-server.static}/share/fluxer-static

            @hidden path /.*
            respond @hidden "Not Found" 404

            header {
              X-Content-Type-Options nosniff
              Referrer-Policy strict-origin-when-cross-origin
              X-Frame-Options DENY
              Permissions-Policy "accelerometer=(), camera=(), geolocation=(), gyroscope=(), magnetometer=(), microphone=(), payment=(), usb=()"
              Access-Control-Allow-Origin *
              Cache-Control "public, max-age=3600, must-revalidate"
              -Server
            }

            file_server
          }

          handle /.well-known/fluxer {
            reverse_proxy ${cfg.settings.internal.api_endpoint}
          }

          handle {
            reverse_proxy ${cfg.settings.internal.app_proxy_endpoint}
          }
        '';
      };
    };

    services.nginx = mkIf (cfg.enable && cfg.aux.nginx.enable) {
      enable = true;
      virtualHosts.${cfg.settings.domain} = {
        forceSSL = true;
        extraConfig = ''
          client_max_body_size 512m;
        '';

        locations."= /_health" = {
          return = "200 OK";
        };

        locations."= /.well-known/fluxer" = {
          recommendedProxySettings = true;
          proxyWebsockets = true;
          proxyPass = "${cfg.settings.internal.api_endpoint}/.well-known/fluxer";
        };

        locations."^~ /api/" = {
          recommendedProxySettings = true;
          proxyWebsockets = true;
          proxyPass = "${cfg.settings.internal.api_endpoint}/";
        };

        locations."^~ /gateway" = {
          extraConfig = ''
            rewrite .* / break;
          '';
          recommendedProxySettings = true;
          proxyWebsockets = true;
          proxyPass = "${cfg.settings.internal.gateway_endpoint}";
        };

        locations."^~ /media/" = {
          recommendedProxySettings = true;
          proxyWebsockets = true;
          proxyPass = "${cfg.settings.internal.media_proxy_endpoint}/";
        };

        locations."^~ /livekit/" = {
          recommendedProxySettings = true;
          proxyWebsockets = true;
          proxyPass = "${cfg.settings.internal.livekit_endpoint}/";
        };

        locations."^~ /admin/" = {
          recommendedProxySettings = true;
          proxyWebsockets = true;
          proxyPass = "${cfg.settings.internal.admin_endpoint}/";
        };

        locations."~ ^/(web|emoji|libs|avatars|badges|desktop)/" = {
          root = "${pkgs.fluxer-server.static}/share/fluxer-static/";
          extraConfig = ''
            add_header X-Content-Type-Options nosniff;
            add_header Referrer-Policy strict-origin-when-cross-origin;
            add_header X-Frame-Options DENY;
            add_header Permissions-Policy "accelerometer=(), camera=(), geolocation=(), gyroscope=(), magnetometer=(), microphone=(), payment=(), usb=()";
            add_header Access-Control-Allow-Origin *;
            add_header Cache-Control "public, max-age=3600, must-revalidate";
          '';
        };

        locations."/" = {
          recommendedProxySettings = true;
          proxyWebsockets = true;
          proxyPass = "${cfg.settings.internal.app_proxy_endpoint}/";
        };
      };
    };

    services.fluxer.settings = {
      self_hosted = mkDefault "true";
      env = mkDefault "production";

      # Public-facing endpoints
      api.endpoint = mkDefault "${cfg.settings.public_origin}/api";
      api.client_endpoint = mkDefault "${cfg.settings.public_origin}/api";
      app.endpoint = mkDefault "${cfg.settings.public_origin}";
      gateway.endpoint = mkDefault "${
        if cfg.settings.public_scheme == "http" then "ws" else "wss"
      }://${cfg.settings.domain}${portSuffix}/gateway";
      media.endpoint = mkDefault "${cfg.settings.public_origin}/media";
      media_proxy.upload_relay.endpoint = mkDefault "${cfg.settings.public_origin}/media";
      # Self-hosted setup defaults to the app-proxy serving the asset bundle and
      # setting this endpoint breaks that behavior
      # static_cdn.endpoint = mkDefault "${origin}";
      admin.endpoint = mkDefault "${cfg.settings.public_origin}/admin";
      marketing.endpoint = mkDefault "${cfg.settings.public_origin}/marketing";
      invite.endpoint = mkDefault "${cfg.settings.public_origin}/invite";
      gift.endpoint = mkDefault "${cfg.settings.public_origin}/gift";

      # Endpoints for service-to-service communication
      internal = {
        api_endpoint = mkIf cfg.api.enable "http://127.0.0.1:${toString cfg.settings.api.port}";
        admin_endpoint = mkIf cfg.admin.enable "http://127.0.0.1:${toString cfg.settings.admin.port}";
        gateway_endpoint = mkIf cfg.gateway.enable "http://127.0.0.1:${toString cfg.settings.gateway.port}";
        media_proxy_endpoint = mkIf cfg.media-proxy.enable "http://127.0.0.1:${toString cfg.settings.media_proxy.port}";
        app_proxy_endpoint = mkIf cfg.app-proxy.enable "http://127.0.0.1:${toString cfg.settings.app_proxy.port}";
        livekit_endpoint = mkIf cfg.aux.livekit.enable "http://127.0.0.1:${toString config.services.livekit.settings.port}";
      };

      database = {
        backend = mkDefault "postgres";
      };
      erlang = {
        dist.port = cfg.settings.api.port - 1;
      };
      gateway = {
        logger_level = mkIf (cfg.log_level != null) cfg.log_level;
      };
      kv = mkIf cfg.aux.valkey.enable {
        url = config.services.redis.servers.fluxer.unixSocket;
      };
      livekit = mkIf cfg.aux.livekit.enable {
        tcp_port = config.services.livekit.settings.port;
        udp_port = config.services.livekit.settings.rtc.port_range_start;
      };
      media_proxy = {
        upload_relay_endpoints = lib.mkDefault "${cfg.settings.public_scheme}://${cfg.settings.domain}/media";
      };
      nats = mkIf cfg.aux.nats.enable {
        url = "nats://127.0.0.1:${toString config.services.nats.port}";
        jetstream.url = "nats://127.0.0.1:${toString config.services.nats.port}";
      };
      postgres = mkIf cfg.aux.pgsql.enable {
        url = "host=/run/postgresql user=fluxer sslmode=disable";
        ssl = "false";
      };
      s3 = {
        # TODO change when switching out seaweedfs module
        endpoint = mkIf cfg.aux.seaweedfs.enable "http://192.168.0.130:8333";
        region = mkIf cfg.aux.seaweedfs.enable "local";
        read_signed = true;
        bucket = {
          cdn = mkDefault "fluxer";
          uploads = mkDefault "fluxer-uploads";
          reports = mkDefault "fluxer-reports";
          harvests = mkDefault "fluxer-harvests";
        };
        #access_key_id = cfg.settings.s3.access_key;
        #secret_access_key = cfg.settings.s3.secret_key;
      };
      search = mkIf cfg.aux.meilisearch.enable {
        engine = "meilisearch";
        url = "http://127.0.0.1:${toString config.services.meilisearch.listenPort}";
        api_key.file = cfg.aux.meilisearch.masterKeyFile;
      };
    };

    # Because node requires a different postgres url
    services.fluxer.api.settings = lib.optionalAttrs cfg.aux.pgsql.enable {
      postgres.url = lib.mkForce "socket://fluxer@/run/postgresql/";
    };

    # Because unfurl-shard uses different env vars for some reason
    services.fluxer.unfurl.shard.settings = {
      media_proxy.endpoint = cfg.settings.internal.media_proxy_endpoint;
    };

    # Because gifs-shard uses yet another different set of env vars
    services.fluxer.gifs.shard.settings = {
      #media.endpoint = cfg.settings.internal.media_proxy_endpoint;
    };
  };
}
