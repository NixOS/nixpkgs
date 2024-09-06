{ config
, lib
, pkgs
, ...
}:
with lib; let
  cfg = config.services.headscale;

  dataDir = "/var/lib/headscale";
  runDir = "/run/headscale";

  cliConfig = {
    # Turn off update checks since the origin of our package
    # is nixpkgs and not Github.
    disable_check_updates = true;

    unix_socket = "${runDir}/headscale.sock";
  };

  settingsFormat = pkgs.formats.yaml { };
  configFile = settingsFormat.generate "headscale.yaml" cfg.settings;
  cliConfigFile = settingsFormat.generate "headscale.yaml" cliConfig;
in
{
  options = {
    services.headscale = {
      enable = mkEnableOption "headscale, Open Source coordination server for Tailscale";

      package = mkPackageOption pkgs "headscale" { };

      user = mkOption {
        default = "headscale";
        type = types.str;
        description = ''
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
        description = ''
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
        description = ''
          Listening address of headscale.
        '';
        example = "0.0.0.0";
      };

      port = mkOption {
        type = types.port;
        default = 8080;
        description = ''
          Listening port of headscale.
        '';
        example = 443;
      };

      settings = mkOption {
        description = ''
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
              description = ''
                The url clients will connect to.
              '';
              example = "https://myheadscale.example.com:443";
            };

            noise.private_key_path = mkOption {
              type = types.path;
              default = "${dataDir}/noise_private.key";
              description = ''
                Path to noise private key file, generated automatically if it does not exist.
              '';
            };

            prefixes =
              let
                prefDesc = ''
                  Each prefix consists of either an IPv4 or IPv6 address,
                  and the associated prefix length, delimited by a slash.
                  It must be within IP ranges supported by the Tailscale
                  client - i.e., subnets of 100.64.0.0/10 and fd7a:115c:a1e0::/48.
                '';
              in
              {
                v4 = mkOption {
                  type = types.str;
                  default = "100.64.0.0/10";
                  description = prefDesc;
                };

                v6 = mkOption {
                  type = types.str;
                  default = "fd7a:115c:a1e0::/48";
                  description = prefDesc;
                };

                allocation = mkOption {
                  type = types.enum [ "sequential" "random" ];
                  example = "random";
                  default = "sequential";
                  description = ''
                    Strategy used for allocation of IPs to nodes, available options:
                    - sequential (default): assigns the next free IP from the previous given IP.
                    - random: assigns the next free IP from a pseudo-random IP generator (crypto/rand).
                  '';
                };
              };

            derp = {
              urls = mkOption {
                type = types.listOf types.str;
                default = [ "https://controlplane.tailscale.com/derpmap/default" ];
                description = ''
                  List of urls containing DERP maps.
                  See [How Tailscale works](https://tailscale.com/blog/how-tailscale-works/) for more information on DERP maps.
                '';
              };

              paths = mkOption {
                type = types.listOf types.path;
                default = [ ];
                description = ''
                  List of file paths containing DERP maps.
                  See [How Tailscale works](https://tailscale.com/blog/how-tailscale-works/) for more information on DERP maps.
                '';
              };

              auto_update_enable = mkOption {
                type = types.bool;
                default = true;
                description = ''
                  Whether to automatically update DERP maps on a set frequency.
                '';
                example = false;
              };

              update_frequency = mkOption {
                type = types.str;
                default = "24h";
                description = ''
                  Frequency to update DERP maps.
                '';
                example = "5m";
              };

              server.private_key_path = lib.mkOption {
                type = lib.types.path;
                default = "${dataDir}/derp_server_private.key";
                description = ''
                  Path to derp private key file, generated automatically if it does not exist.
                '';
              };
            };

            ephemeral_node_inactivity_timeout = mkOption {
              type = types.str;
              default = "30m";
              description = ''
                Time before an inactive ephemeral node is deleted.
              '';
              example = "5m";
            };

            database = {
              type = mkOption {
                type = types.enum [ "sqlite" "sqlite3" "postgres" ];
                example = "postgres";
                default = "sqlite";
                description = ''
                  Database engine to use.
                  Please note that using Postgres is highly discouraged as it is only supported for legacy reasons.
                  All new development, testing and optimisations are done with SQLite in mind.
                '';
              };

              sqlite = {
                path = mkOption {
                  type = types.nullOr types.str;
                  default = "${dataDir}/db.sqlite";
                  description = "Path to the sqlite3 database file.";
                };

                write_ahead_log = mkOption {
                  type = types.bool;
                  default = true;
                  description = ''
                    Enable WAL mode for SQLite. This is recommended for production environments.
                    https://www.sqlite.org/wal.html
                  '';
                  example = true;
                };
              };

              postgres = {
                host = mkOption {
                  type = types.nullOr types.str;
                  default = null;
                  example = "127.0.0.1";
                  description = "Database host address.";
                };

                port = mkOption {
                  type = types.nullOr types.port;
                  default = null;
                  example = 3306;
                  description = "Database host port.";
                };

                name = mkOption {
                  type = types.nullOr types.str;
                  default = null;
                  example = "headscale";
                  description = "Database name.";
                };

                user = mkOption {
                  type = types.nullOr types.str;
                  default = null;
                  example = "headscale";
                  description = "Database user.";
                };

                password_file = mkOption {
                  type = types.nullOr types.path;
                  default = null;
                  example = "/run/keys/headscale-dbpassword";
                  description = ''
                    A file containing the password corresponding to
                    {option}`database.user`.
                  '';
                };
              };
            };

            log = {
              level = mkOption {
                type = types.str;
                default = "info";
                description = ''
                  headscale log level.
                '';
                example = "debug";
              };

              format = mkOption {
                type = types.str;
                default = "text";
                description = ''
                  headscale log format.
                '';
                example = "json";
              };
            };

            dns = {
              magic_dns = mkOption {
                type = types.bool;
                default = true;
                description = ''
                  Whether to use [MagicDNS](https://tailscale.com/kb/1081/magicdns/).
                  Only works if there is at least a nameserver defined.
                '';
                example = false;
              };

              base_domain = mkOption {
                type = types.str;
                default = "";
                description = ''
                  Defines the base domain to create the hostnames for MagicDNS.
                  {option}`baseDomain` must be a FQDNs, without the trailing dot.
                  The FQDN of the hosts will be
                  `hostname.namespace.base_domain` (e.g.
                  `myhost.mynamespace.example.com`).
                '';
              };

              nameservers = {
                global = mkOption {
                  type = types.listOf types.str;
                  default = [ ];
                  description = ''
                    List of nameservers to pass to Tailscale clients.
                  '';
                };
              };

              search_domains = mkOption {
                type = types.listOf types.str;
                default = [ ];
                description = ''
                  Search domains to inject to Tailscale clients.
                '';
                example = [ "mydomain.internal" ];
              };
            };

            oidc = {
              issuer = mkOption {
                type = types.str;
                default = "";
                description = ''
                  URL to OpenID issuer.
                '';
                example = "https://openid.example.com";
              };

              client_id = mkOption {
                type = types.str;
                default = "";
                description = ''
                  OpenID Connect client ID.
                '';
              };

              client_secret_path = mkOption {
                type = types.nullOr types.str;
                default = null;
                description = ''
                  Path to OpenID Connect client secret file. Expands environment variables in format ''${VAR}.
                '';
              };

              scope = mkOption {
                type = types.listOf types.str;
                default = [ "openid" "profile" "email" ];
                description = ''
                  Scopes used in the OIDC flow.
                '';
              };

              extra_params = mkOption {
                type = types.attrsOf types.str;
                default = { };
                description = ''
                  Custom query parameters to send with the Authorize Endpoint request.
                '';
                example = {
                  domain_hint = "example.com";
                };
              };

              allowed_domains = mkOption {
                type = types.listOf types.str;
                default = [ ];
                description = ''
                  Allowed principal domains. if an authenticated user's domain
                  is not in this list authentication request will be rejected.
                '';
                example = [ "example.com" ];
              };

              allowed_users = mkOption {
                type = types.listOf types.str;
                default = [ ];
                description = ''
                  Users allowed to authenticate even if not in allowedDomains.
                '';
                example = [ "alice@example.com" ];
              };

              strip_email_domain = mkOption {
                type = types.bool;
                default = true;
                description = ''
                  Whether the domain part of the email address should be removed when generating namespaces.
                '';
              };
            };

            tls_letsencrypt_hostname = mkOption {
              type = types.nullOr types.str;
              default = "";
              description = ''
                Domain name to request a TLS certificate for.
              '';
            };

            tls_letsencrypt_challenge_type = mkOption {
              type = types.enum [ "TLS-ALPN-01" "HTTP-01" ];
              default = "HTTP-01";
              description = ''
                Type of ACME challenge to use, currently supported types:
                `HTTP-01` or `TLS-ALPN-01`.
              '';
            };

            tls_letsencrypt_listen = mkOption {
              type = types.nullOr types.str;
              default = ":http";
              description = ''
                When HTTP-01 challenge is chosen, letsencrypt must set up a
                verification endpoint, and it will be listening on:
                `:http = port 80`.
              '';
            };

            tls_cert_path = mkOption {
              type = types.nullOr types.path;
              default = null;
              description = ''
                Path to already created certificate.
              '';
            };

            tls_key_path = mkOption {
              type = types.nullOr types.path;
              default = null;
              description = ''
                Path to key for already created certificate.
              '';
            };

            policy = {
              mode = mkOption {
                type = types.enum [ "file" "database" ];
                default = "file";
                description = ''
                  The mode can be "file" or "database" that defines
                  where the ACL policies are stored and read from.
                '';
              };

              path = mkOption {
                type = types.nullOr types.path;
                default = null;
                description = ''
                  If the mode is set to "file", the path to a
                  HuJSON file containing ACL policies.
                '';
              };
            };
          };
        };
      };
    };
  };

  imports = [
    (mkRenamedOptionModule [ "services" "headscale" "serverUrl" ] [ "services" "headscale" "settings" "server_url" ])
    (mkRenamedOptionModule [ "services" "headscale" "derp" "urls" ] [ "services" "headscale" "settings" "derp" "urls" ])
    (mkRenamedOptionModule [ "services" "headscale" "derp" "paths" ] [ "services" "headscale" "settings" "derp" "paths" ])
    (mkRenamedOptionModule [ "services" "headscale" "derp" "autoUpdate" ] [ "services" "headscale" "settings" "derp" "auto_update_enable" ])
    (mkRenamedOptionModule [ "services" "headscale" "derp" "updateFrequency" ] [ "services" "headscale" "settings" "derp" "update_frequency" ])
    (mkRenamedOptionModule [ "services" "headscale" "ephemeralNodeInactivityTimeout" ] [ "services" "headscale" "settings" "ephemeral_node_inactivity_timeout" ])

    # (mkRenamedOptionModule ["services" "headscale" "settings" "db_type"] ["services" "headscale" "settings" "database" "type"])
    # (mkRenamedOptionModule ["services" "headscale" "settings" "db_path"] ["services" "headscale" "settings" "database" "sqlite" "path"])
    # (mkRenamedOptionModule ["services" "headscale" "settings" "db_host"] ["services" "headscale" "settings" "database" "postgres" "host"])
    # (mkRenamedOptionModule ["services" "headscale" "settings" "db_port"] ["services" "headscale" "settings" "database" "postgres" "port"])
    # (mkRenamedOptionModule ["services" "headscale" "settings" "db_name"] ["services" "headscale" "settings" "database" "postgres" "name"])
    # (mkRenamedOptionModule ["services" "headscale" "settings" "db_user"] ["services" "headscale" "settings" "database" "postgres" "user"])
    # (mkRenamedOptionModule ["services" "headscale" "settings" "db_password_file"] ["services" "headscale" "settings" "database" "postgres" "password_file"])

    (mkRenamedOptionModule [ "services" "headscale" "logLevel" ] [ "services" "headscale" "settings" "log" "level" ])

    # (mkRenamedOptionModule ["services" "headscale" "settings" "dns_config" "nameservers"] ["services" "headscale" "settings" "dns" "nameservers" "global"])
    # (mkRenamedOptionModule ["services" "headscale" "settings" "dns_config" "domains"] ["services" "headscale" "settings" "dns" "search_domains"])
    # (mkRenamedOptionModule ["services" "headscale" "settings" "dns_config" "magic_dns"] ["services" "headscale" "settings" "dns" "magic_dns"])
    # (mkRenamedOptionModule ["services" "headscale" "settings" "dns_config" "base_domain"] ["services" "headscale" "settings" "dns" "base_domain"])

    (mkRenamedOptionModule [ "services" "headscale" "openIdConnect" "issuer" ] [ "services" "headscale" "settings" "oidc" "issuer" ])
    (mkRenamedOptionModule [ "services" "headscale" "openIdConnect" "clientId" ] [ "services" "headscale" "settings" "oidc" "client_id" ])
    (mkRenamedOptionModule [ "services" "headscale" "openIdConnect" "clientSecretFile" ] [ "services" "headscale" "settings" "oidc" "client_secret_path" ])
    (mkRenamedOptionModule [ "services" "headscale" "tls" "letsencrypt" "hostname" ] [ "services" "headscale" "settings" "tls_letsencrypt_hostname" ])
    (mkRenamedOptionModule [ "services" "headscale" "tls" "letsencrypt" "challengeType" ] [ "services" "headscale" "settings" "tls_letsencrypt_challenge_type" ])
    (mkRenamedOptionModule [ "services" "headscale" "tls" "letsencrypt" "httpListen" ] [ "services" "headscale" "settings" "tls_letsencrypt_listen" ])
    (mkRenamedOptionModule [ "services" "headscale" "tls" "certFile" ] [ "services" "headscale" "settings" "tls_cert_path" ])
    (mkRenamedOptionModule [ "services" "headscale" "tls" "keyFile" ] [ "services" "headscale" "settings" "tls_key_path" ])

    # (mkRenamedOptionModule ["services" "headscale" "settings" "acl_policy_path"] ["services" "headscale" "settings" "policy" "path"])

    (mkRemovedOptionModule [ "services" "headscale" "openIdConnect" "domainMap" ] ''
      Headscale no longer uses domain_map. If you're using an old version of headscale you can still set this option via services.headscale.settings.oidc.domain_map.
    '')
  ];

  config = mkIf cfg.enable {
    services.headscale.settings = mkMerge [
      cliConfig
      {
        listen_addr = mkDefault "${cfg.address}:${toString cfg.port}";

        tls_letsencrypt_cache_dir = "${dataDir}/.cache";
      }
    ];

    environment = {
      # Headscale CLI needs a minimal config to be able to locate the unix socket
      # to talk to the server instance.
      etc."headscale/config.yaml".source = cliConfigFile;

      systemPackages = [ cfg.package ];
    };

    users.groups.headscale = mkIf (cfg.group == "headscale") { };

    users.users.headscale = mkIf (cfg.user == "headscale") {
      description = "headscale user";
      home = dataDir;
      group = cfg.group;
      isSystemUser = true;
    };

    systemd.services.headscale = {
      description = "headscale coordination server for Tailscale";
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      script = ''
        ${optionalString (cfg.settings.database.postgres.password_file != null) ''
          export HEADSCALE_DATABASE_POSTGRES_PASS="$(head -n1 ${escapeShellArg cfg.settings.database.postgres.password_file})"
        ''}

        exec ${lib.getExe cfg.package} serve --config ${configFile}
      '';

      serviceConfig =
        let
          capabilityBoundingSet = [ "CAP_CHOWN" ] ++ optional (cfg.port < 1024) "CAP_NET_BIND_SERVICE";
        in
        {
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
          SystemCallFilter = [ "@system-service" "~@privileged" "@chown" ];
          SystemCallArchitectures = "native";
          RestrictAddressFamilies = "AF_INET AF_INET6 AF_UNIX";
        };
    };
  };

  meta.maintainers = with maintainers; [ kradalby misterio77 ];
}
