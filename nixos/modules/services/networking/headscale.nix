{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.headscale;

  dataDir = "/var/lib/headscale";
  runDir = "/run/headscale";

  settingsFormat = pkgs.formats.yaml {};
  configFile = settingsFormat.generate "headscale.yaml" cfg.settings;
in {
  options = {
    services.headscale = {
      enable = mkEnableOption (lib.mdDoc "headscale, Open Source coordination server for Tailscale");

      package = mkOption {
        type = types.package;
        default = pkgs.headscale;
        defaultText = literalExpression "pkgs.headscale";
        description = lib.mdDoc ''
          Which headscale package to use for the running server.
        '';
      };

      user = mkOption {
        default = "headscale";
        type = types.str;
        description = lib.mdDoc ''
          User account under which headscale runs.

          ::: {.note}
          If left as the default value this user will automatically be created
          on system activation, otherwise you are responsible for
          ensuring the user exists before the headscale service starts.
          :::
        '';
      };

      group = mkOption {
        default = "headscale";
        type = types.str;
        description = lib.mdDoc ''
          Group under which headscale runs.

          ::: {.note}
          If left as the default value this group will automatically be created
          on system activation, otherwise you are responsible for
          ensuring the user exists before the headscale service starts.
          :::
        '';
      };

      address = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = lib.mdDoc ''
          Listening address of headscale.
        '';
        example = "0.0.0.0";
      };

      port = mkOption {
        type = types.port;
        default = 8080;
        description = lib.mdDoc ''
          Listening port of headscale.
        '';
        example = 443;
      };

      settings = mkOption {
        description = lib.mdDoc ''
          Overrides to {file}`config.yaml` as a Nix attribute set.
          Check the [example config](https://github.com/juanfont/headscale/blob/main/config-example.yaml)
          for possible options.
        '';
        type = types.submodule {
          freeformType = settingsFormat.type;

          options = {
            server_url = mkOption {
              type = types.str;
              default = "http://127.0.0.1:8080";
              description = lib.mdDoc ''
                The url clients will connect to.
              '';
              example = "https://myheadscale.example.com:443";
            };

            private_key_path = mkOption {
              type = types.path;
              default = "${dataDir}/private.key";
              description = lib.mdDoc ''
                Path to private key file, generated automatically if it does not exist.
              '';
            };

            noise.private_key_path = mkOption {
              type = types.path;
              default = "${dataDir}/noise_private.key";
              description = lib.mdDoc ''
                Path to noise private key file, generated automatically if it does not exist.
              '';
            };

            derp = {
              urls = mkOption {
                type = types.listOf types.str;
                default = ["https://controlplane.tailscale.com/derpmap/default"];
                description = lib.mdDoc ''
                  List of urls containing DERP maps.
                  See [How Tailscale works](https://tailscale.com/blog/how-tailscale-works/) for more information on DERP maps.
                '';
              };

              paths = mkOption {
                type = types.listOf types.path;
                default = [];
                description = lib.mdDoc ''
                  List of file paths containing DERP maps.
                  See [How Tailscale works](https://tailscale.com/blog/how-tailscale-works/) for more information on DERP maps.
                '';
              };

              auto_update_enable = mkOption {
                type = types.bool;
                default = true;
                description = lib.mdDoc ''
                  Whether to automatically update DERP maps on a set frequency.
                '';
                example = false;
              };

              update_frequency = mkOption {
                type = types.str;
                default = "24h";
                description = lib.mdDoc ''
                  Frequency to update DERP maps.
                '';
                example = "5m";
              };
            };

            ephemeral_node_inactivity_timeout = mkOption {
              type = types.str;
              default = "30m";
              description = lib.mdDoc ''
                Time before an inactive ephemeral node is deleted.
              '';
              example = "5m";
            };

            db_type = mkOption {
              type = types.enum ["sqlite3" "postgres"];
              example = "postgres";
              default = "sqlite3";
              description = lib.mdDoc "Database engine to use.";
            };

            db_host = mkOption {
              type = types.nullOr types.str;
              default = null;
              example = "127.0.0.1";
              description = lib.mdDoc "Database host address.";
            };

            db_port = mkOption {
              type = types.nullOr types.port;
              default = null;
              example = 3306;
              description = lib.mdDoc "Database host port.";
            };

            db_name = mkOption {
              type = types.nullOr types.str;
              default = null;
              example = "headscale";
              description = lib.mdDoc "Database name.";
            };

            db_user = mkOption {
              type = types.nullOr types.str;
              default = null;
              example = "headscale";
              description = lib.mdDoc "Database user.";
            };

            db_password_file = mkOption {
              type = types.nullOr types.path;
              default = null;
              example = "/run/keys/headscale-dbpassword";
              description = lib.mdDoc ''
                A file containing the password corresponding to
                {option}`database.user`.
              '';
            };

            db_path = mkOption {
              type = types.nullOr types.str;
              default = "${dataDir}/db.sqlite";
              description = lib.mdDoc "Path to the sqlite3 database file.";
            };

            log.level = mkOption {
              type = types.str;
              default = "info";
              description = lib.mdDoc ''
                headscale log level.
              '';
              example = "debug";
            };

            log.format = mkOption {
              type = types.str;
              default = "text";
              description = lib.mdDoc ''
                headscale log format.
              '';
              example = "json";
            };

            dns_config = {
              nameservers = mkOption {
                type = types.listOf types.str;
                default = ["1.1.1.1"];
                description = lib.mdDoc ''
                  List of nameservers to pass to Tailscale clients.
                '';
              };

              override_local_dns = mkOption {
                type = types.bool;
                default = false;
                description = lib.mdDoc ''
                  Whether to use [Override local DNS](https://tailscale.com/kb/1054/dns/).
                '';
                example = true;
              };

              domains = mkOption {
                type = types.listOf types.str;
                default = [];
                description = lib.mdDoc ''
                  Search domains to inject to Tailscale clients.
                '';
                example = ["mydomain.internal"];
              };

              magic_dns = mkOption {
                type = types.bool;
                default = true;
                description = lib.mdDoc ''
                  Whether to use [MagicDNS](https://tailscale.com/kb/1081/magicdns/).
                  Only works if there is at least a nameserver defined.
                '';
                example = false;
              };

              base_domain = mkOption {
                type = types.str;
                default = "";
                description = lib.mdDoc ''
                  Defines the base domain to create the hostnames for MagicDNS.
                  {option}`baseDomain` must be a FQDNs, without the trailing dot.
                  The FQDN of the hosts will be
                  `hostname.namespace.base_domain` (e.g.
                  `myhost.mynamespace.example.com`).
                '';
              };
            };

            oidc = {
              issuer = mkOption {
                type = types.str;
                default = "";
                description = lib.mdDoc ''
                  URL to OpenID issuer.
                '';
                example = "https://openid.example.com";
              };

              client_id = mkOption {
                type = types.str;
                default = "";
                description = lib.mdDoc ''
                  OpenID Connect client ID.
                '';
              };

              client_secret_file = mkOption {
                type = types.nullOr types.path;
                default = null;
                description = lib.mdDoc ''
                  Path to OpenID Connect client secret file.
                '';
              };

              domain_map = mkOption {
                type = types.attrsOf types.str;
                default = {};
                description = lib.mdDoc ''
                  Domain map is used to map incomming users (by their email) to
                  a namespace. The key can be a string, or regex.
                '';
                example = {
                  ".*" = "default-namespace";
                };
              };
            };

            tls_letsencrypt_hostname = mkOption {
              type = types.nullOr types.str;
              default = "";
              description = lib.mdDoc ''
                Domain name to request a TLS certificate for.
              '';
            };

            tls_letsencrypt_challenge_type = mkOption {
              type = types.enum ["TLS-ALPN-01" "HTTP-01"];
              default = "HTTP-01";
              description = lib.mdDoc ''
                Type of ACME challenge to use, currently supported types:
                `HTTP-01` or `TLS-ALPN-01`.
              '';
            };

            tls_letsencrypt_listen = mkOption {
              type = types.nullOr types.str;
              default = ":http";
              description = lib.mdDoc ''
                When HTTP-01 challenge is chosen, letsencrypt must set up a
                verification endpoint, and it will be listening on:
                `:http = port 80`.
              '';
            };

            tls_cert_path = mkOption {
              type = types.nullOr types.path;
              default = null;
              description = lib.mdDoc ''
                Path to already created certificate.
              '';
            };

            tls_key_path = mkOption {
              type = types.nullOr types.path;
              default = null;
              description = lib.mdDoc ''
                Path to key for already created certificate.
              '';
            };

            acl_policy_path = mkOption {
              type = types.nullOr types.path;
              default = null;
              description = lib.mdDoc ''
                Path to a file containg ACL policies.
              '';
            };
          };
        };
      };
    };
  };

  imports = [
    # TODO address + port = listen_addr
    (mkRenamedOptionModule ["services" "headscale" "serverUrl"] ["services" "headscale" "settings" "server_url"])
    (mkRenamedOptionModule ["services" "headscale" "privateKeyFile"] ["services" "headscale" "settings" "private_key_path"])
    (mkRenamedOptionModule ["services" "headscale" "derp" "urls"] ["services" "headscale" "settings" "derp" "urls"])
    (mkRenamedOptionModule ["services" "headscale" "derp" "paths"] ["services" "headscale" "settings" "derp" "paths"])
    (mkRenamedOptionModule ["services" "headscale" "derp" "autoUpdate"] ["services" "headscale" "settings" "derp" "auto_update_enable"])
    (mkRenamedOptionModule ["services" "headscale" "derp" "updateFrequency"] ["services" "headscale" "settings" "derp" "update_frequency"])
    (mkRenamedOptionModule ["services" "headscale" "ephemeralNodeInactivityTimeout"] ["services" "headscale" "settings" "ephemeral_node_inactivity_timeout"])
    (mkRenamedOptionModule ["services" "headscale" "database" "type"] ["services" "headscale" "settings" "db_type"])
    (mkRenamedOptionModule ["services" "headscale" "database" "path"] ["services" "headscale" "settings" "db_path"])
    (mkRenamedOptionModule ["services" "headscale" "database" "host"] ["services" "headscale" "settings" "db_host"])
    (mkRenamedOptionModule ["services" "headscale" "database" "port"] ["services" "headscale" "settings" "db_port"])
    (mkRenamedOptionModule ["services" "headscale" "database" "name"] ["services" "headscale" "settings" "db_name"])
    (mkRenamedOptionModule ["services" "headscale" "database" "user"] ["services" "headscale" "settings" "db_user"])
    (mkRenamedOptionModule ["services" "headscale" "database" "passwordFile"] ["services" "headscale" "settings" "db_password_file"])
    (mkRenamedOptionModule ["services" "headscale" "logLevel"] ["services" "headscale" "settings" "log" "level"])
    (mkRenamedOptionModule ["services" "headscale" "dns" "nameservers"] ["services" "headscale" "settings" "dns_config" "nameservers"])
    (mkRenamedOptionModule ["services" "headscale" "dns" "domains"] ["services" "headscale" "settings" "dns_config" "domains"])
    (mkRenamedOptionModule ["services" "headscale" "dns" "magicDns"] ["services" "headscale" "settings" "dns_config" "magic_dns"])
    (mkRenamedOptionModule ["services" "headscale" "dns" "baseDomain"] ["services" "headscale" "settings" "dns_config" "base_domain"])
    (mkRenamedOptionModule ["services" "headscale" "openIdConnect" "issuer"] ["services" "headscale" "settings" "oidc" "issuer"])
    (mkRenamedOptionModule ["services" "headscale" "openIdConnect" "clientId"] ["services" "headscale" "settings" "oidc" "client_id"])
    (mkRenamedOptionModule ["services" "headscale" "openIdConnect" "clientSecretFile"] ["services" "headscale" "settings" "oidc" "client_secret_file"])
    (mkRenamedOptionModule ["services" "headscale" "openIdConnect" "domainMap"] ["services" "headscale" "settings" "oidc" "domain_map"])
    (mkRenamedOptionModule ["services" "headscale" "tls" "letsencrypt" "hostname"] ["services" "headscale" "settings" "tls_letsencrypt_hostname"])
    (mkRenamedOptionModule ["services" "headscale" "tls" "letsencrypt" "challengeType"] ["services" "headscale" "settings" "tls_letsencrypt_challenge_type"])
    (mkRenamedOptionModule ["services" "headscale" "tls" "letsencrypt" "httpListen"] ["services" "headscale" "settings" "tls_letsencrypt_listen"])
    (mkRenamedOptionModule ["services" "headscale" "tls" "certFile"] ["services" "headscale" "settings" "tls_cert_path"])
    (mkRenamedOptionModule ["services" "headscale" "tls" "keyFile"] ["services" "headscale" "settings" "tls_key_path"])
    (mkRenamedOptionModule ["services" "headscale" "aclPolicyFile"] ["services" "headscale" "settings" "acl_policy_path"])
  ];

  config = mkIf cfg.enable {
    services.headscale.settings = {
      listen_addr = mkDefault "${cfg.address}:${toString cfg.port}";

      # Turn off update checks since the origin of our package
      # is nixpkgs and not Github.
      disable_check_updates = true;

      unix_socket = "${runDir}/headscale.sock";

      tls_letsencrypt_cache_dir = "${dataDir}/.cache";
    };

    # Setup the headscale configuration in a known path in /etc to
    # allow both the Server and the Client use it to find the socket
    # for communication.
    environment.etc."headscale/config.yaml".source = configFile;

    users.groups.headscale = mkIf (cfg.group == "headscale") {};

    users.users.headscale = mkIf (cfg.user == "headscale") {
      description = "headscale user";
      home = dataDir;
      group = cfg.group;
      isSystemUser = true;
    };

    systemd.services.headscale = {
      description = "headscale coordination server for Tailscale";
      after = ["network-online.target"];
      wantedBy = ["multi-user.target"];
      restartTriggers = [configFile];

      environment.GIN_MODE = "release";

      script = ''
        ${optionalString (cfg.settings.db_password_file != null) ''
          export HEADSCALE_DB_PASS="$(head -n1 ${escapeShellArg cfg.settings.db_password_file})"
        ''}

        ${optionalString (cfg.settings.oidc.client_secret_file != null) ''
          export HEADSCALE_OIDC_CLIENT_SECRET="$(head -n1 ${escapeShellArg cfg.settings.oidc.client_secret_file})"
        ''}
        exec ${cfg.package}/bin/headscale serve
      '';

      serviceConfig = let
        capabilityBoundingSet = ["CAP_CHOWN"] ++ optional (cfg.port < 1024) "CAP_NET_BIND_SERVICE";
      in {
        Restart = "always";
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;

        # Hardening options
        RuntimeDirectory = "headscale";
        # Allow headscale group access so users can be added and use the CLI.
        RuntimeDirectoryMode = "0750";

        StateDirectory = "headscale";
        StateDirectoryMode = "0750";

        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        RestrictSUIDSGID = true;
        PrivateMounts = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectHostname = true;
        ProtectClock = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";
        RestrictNamespaces = true;
        RemoveIPC = true;
        UMask = "0077";

        CapabilityBoundingSet = capabilityBoundingSet;
        AmbientCapabilities = capabilityBoundingSet;
        NoNewPrivileges = true;
        LockPersonality = true;
        RestrictRealtime = true;
        SystemCallFilter = ["@system-service" "~@privileged" "@chown"];
        SystemCallArchitectures = "native";
        RestrictAddressFamilies = "AF_INET AF_INET6 AF_UNIX";
      };
    };
  };

  meta.maintainers = with maintainers; [kradalby misterio77];
}
