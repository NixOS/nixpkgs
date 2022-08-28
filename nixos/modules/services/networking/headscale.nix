{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.headscale;

  dataDir = "/var/lib/headscale";
  runDir = "/run/headscale";

  settingsFormat = pkgs.formats.yaml { };
  configFile = settingsFormat.generate "headscale.yaml" cfg.settings;
in
{
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
        description = ''
          User account under which headscale runs.
          <note><para>
          If left as the default value this user will automatically be created
          on system activation, otherwise you are responsible for
          ensuring the user exists before the headscale service starts.
          </para></note>
        '';
      };

      group = mkOption {
        default = "headscale";
        type = types.str;
        description = ''
          Group under which headscale runs.
          <note><para>
          If left as the default value this group will automatically be created
          on system activation, otherwise you are responsible for
          ensuring the user exists before the headscale service starts.
          </para></note>
        '';
      };

      serverUrl = mkOption {
        type = types.str;
        default = "http://127.0.0.1:8080";
        description = lib.mdDoc ''
          The url clients will connect to.
        '';
        example = "https://myheadscale.example.com:443";
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

      privateKeyFile = mkOption {
        type = types.path;
        default = "${dataDir}/private.key";
        description = lib.mdDoc ''
          Path to private key file, generated automatically if it does not exist.
        '';
      };

      derp = {
        urls = mkOption {
          type = types.listOf types.str;
          default = [ "https://controlplane.tailscale.com/derpmap/default" ];
          description = lib.mdDoc ''
            List of urls containing DERP maps.
            See [How Tailscale works](https://tailscale.com/blog/how-tailscale-works/) for more information on DERP maps.
          '';
        };

        paths = mkOption {
          type = types.listOf types.path;
          default = [ ];
          description = lib.mdDoc ''
            List of file paths containing DERP maps.
            See [How Tailscale works](https://tailscale.com/blog/how-tailscale-works/) for more information on DERP maps.
          '';
        };


        autoUpdate = mkOption {
          type = types.bool;
          default = true;
          description = lib.mdDoc ''
            Whether to automatically update DERP maps on a set frequency.
          '';
          example = false;
        };

        updateFrequency = mkOption {
          type = types.str;
          default = "24h";
          description = lib.mdDoc ''
            Frequency to update DERP maps.
          '';
          example = "5m";
        };

      };

      ephemeralNodeInactivityTimeout = mkOption {
        type = types.str;
        default = "30m";
        description = lib.mdDoc ''
          Time before an inactive ephemeral node is deleted.
        '';
        example = "5m";
      };

      database = {
        type = mkOption {
          type = types.enum [ "sqlite3" "postgres" ];
          example = "postgres";
          default = "sqlite3";
          description = lib.mdDoc "Database engine to use.";
        };

        host = mkOption {
          type = types.nullOr types.str;
          default = null;
          example = "127.0.0.1";
          description = lib.mdDoc "Database host address.";
        };

        port = mkOption {
          type = types.nullOr types.port;
          default = null;
          example = 3306;
          description = lib.mdDoc "Database host port.";
        };

        name = mkOption {
          type = types.nullOr types.str;
          default = null;
          example = "headscale";
          description = lib.mdDoc "Database name.";
        };

        user = mkOption {
          type = types.nullOr types.str;
          default = null;
          example = "headscale";
          description = lib.mdDoc "Database user.";
        };

        passwordFile = mkOption {
          type = types.nullOr types.path;
          default = null;
          example = "/run/keys/headscale-dbpassword";
          description = lib.mdDoc ''
            A file containing the password corresponding to
            {option}`database.user`.
          '';
        };

        path = mkOption {
          type = types.nullOr types.str;
          default = "${dataDir}/db.sqlite";
          description = lib.mdDoc "Path to the sqlite3 database file.";
        };
      };

      logLevel = mkOption {
        type = types.str;
        default = "info";
        description = lib.mdDoc ''
          headscale log level.
        '';
        example = "debug";
      };

      dns = {
        nameservers = mkOption {
          type = types.listOf types.str;
          default = [ "1.1.1.1" ];
          description = lib.mdDoc ''
            List of nameservers to pass to Tailscale clients.
          '';
        };

        domains = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = lib.mdDoc ''
            Search domains to inject to Tailscale clients.
          '';
          example = [ "mydomain.internal" ];
        };

        magicDns = mkOption {
          type = types.bool;
          default = true;
          description = lib.mdDoc ''
            Whether to use [MagicDNS](https://tailscale.com/kb/1081/magicdns/).
            Only works if there is at least a nameserver defined.
          '';
          example = false;
        };

        baseDomain = mkOption {
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

      openIdConnect = {
        issuer = mkOption {
          type = types.str;
          default = "";
          description = lib.mdDoc ''
            URL to OpenID issuer.
          '';
          example = "https://openid.example.com";
        };

        clientId = mkOption {
          type = types.str;
          default = "";
          description = lib.mdDoc ''
            OpenID Connect client ID.
          '';
        };

        clientSecretFile = mkOption {
          type = types.nullOr types.path;
          default = null;
          description = lib.mdDoc ''
            Path to OpenID Connect client secret file.
          '';
        };

        domainMap = mkOption {
          type = types.attrsOf types.str;
          default = { };
          description = lib.mdDoc ''
            Domain map is used to map incomming users (by their email) to
            a namespace. The key can be a string, or regex.
          '';
          example = {
            ".*" = "default-namespace";
          };
        };

      };

      tls = {
        letsencrypt = {
          hostname = mkOption {
            type = types.nullOr types.str;
            default = "";
            description = lib.mdDoc ''
              Domain name to request a TLS certificate for.
            '';
          };
          challengeType = mkOption {
            type = types.enum [ "TLS-ALPN-01" "HTTP-01" ];
            default = "HTTP-01";
            description = lib.mdDoc ''
              Type of ACME challenge to use, currently supported types:
              `HTTP-01` or `TLS-ALPN-01`.
            '';
          };
          httpListen = mkOption {
            type = types.nullOr types.str;
            default = ":http";
            description = lib.mdDoc ''
              When HTTP-01 challenge is chosen, letsencrypt must set up a
              verification endpoint, and it will be listening on:
              `:http = port 80`.
            '';
          };
        };

        certFile = mkOption {
          type = types.nullOr types.path;
          default = null;
          description = lib.mdDoc ''
            Path to already created certificate.
          '';
        };
        keyFile = mkOption {
          type = types.nullOr types.path;
          default = null;
          description = lib.mdDoc ''
            Path to key for already created certificate.
          '';
        };
      };

      aclPolicyFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = lib.mdDoc ''
          Path to a file containg ACL policies.
        '';
      };

      settings = mkOption {
        type = settingsFormat.type;
        default = { };
        description = lib.mdDoc ''
          Overrides to {file}`config.yaml` as a Nix attribute set.
          This option is ideal for overriding settings not exposed as Nix options.
          Check the [example config](https://github.com/juanfont/headscale/blob/main/config-example.yaml)
          for possible options.
        '';
      };


    };

  };
  config = mkIf cfg.enable {

    services.headscale.settings = {
      server_url = mkDefault cfg.serverUrl;
      listen_addr = mkDefault "${cfg.address}:${toString cfg.port}";

      private_key_path = mkDefault cfg.privateKeyFile;

      derp = {
        urls = mkDefault cfg.derp.urls;
        paths = mkDefault cfg.derp.paths;
        auto_update_enable = mkDefault cfg.derp.autoUpdate;
        update_frequency = mkDefault cfg.derp.updateFrequency;
      };

      # Turn off update checks since the origin of our package
      # is nixpkgs and not Github.
      disable_check_updates = true;

      ephemeral_node_inactivity_timeout = mkDefault cfg.ephemeralNodeInactivityTimeout;

      db_type = mkDefault cfg.database.type;
      db_path = mkDefault cfg.database.path;

      log_level = mkDefault cfg.logLevel;

      dns_config = {
        nameservers = mkDefault cfg.dns.nameservers;
        domains = mkDefault cfg.dns.domains;
        magic_dns = mkDefault cfg.dns.magicDns;
        base_domain = mkDefault cfg.dns.baseDomain;
      };

      unix_socket = "${runDir}/headscale.sock";

      # OpenID Connect
      oidc = {
        issuer = mkDefault cfg.openIdConnect.issuer;
        client_id = mkDefault cfg.openIdConnect.clientId;
        domain_map = mkDefault cfg.openIdConnect.domainMap;
      };

      tls_letsencrypt_cache_dir = "${dataDir}/.cache";

    } // optionalAttrs (cfg.database.host != null) {
      db_host = mkDefault cfg.database.host;
    } // optionalAttrs (cfg.database.port != null) {
      db_port = mkDefault cfg.database.port;
    } // optionalAttrs (cfg.database.name != null) {
      db_name = mkDefault cfg.database.name;
    } // optionalAttrs (cfg.database.user != null) {
      db_user = mkDefault cfg.database.user;
    } // optionalAttrs (cfg.tls.letsencrypt.hostname != null) {
      tls_letsencrypt_hostname = mkDefault cfg.tls.letsencrypt.hostname;
    } // optionalAttrs (cfg.tls.letsencrypt.challengeType != null) {
      tls_letsencrypt_challenge_type = mkDefault cfg.tls.letsencrypt.challengeType;
    } // optionalAttrs (cfg.tls.letsencrypt.httpListen != null) {
      tls_letsencrypt_listen = mkDefault cfg.tls.letsencrypt.httpListen;
    } // optionalAttrs (cfg.tls.certFile != null) {
      tls_cert_path = mkDefault cfg.tls.certFile;
    } // optionalAttrs (cfg.tls.keyFile != null) {
      tls_key_path = mkDefault cfg.tls.keyFile;
    } // optionalAttrs (cfg.aclPolicyFile != null) {
      acl_policy_path = mkDefault cfg.aclPolicyFile;
    };

    # Setup the headscale configuration in a known path in /etc to
    # allow both the Server and the Client use it to find the socket
    # for communication.
    environment.etc."headscale/config.yaml".source = configFile;

    users.groups.headscale = mkIf (cfg.group == "headscale") { };

    users.users.headscale = mkIf (cfg.user == "headscale") {
      description = "headscale user";
      home = dataDir;
      group = cfg.group;
      isSystemUser = true;
    };

    systemd.services.headscale = {
      description = "headscale coordination server for Tailscale";
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      restartTriggers = [ configFile ];

      environment.GIN_MODE = "release";

      script = ''
        ${optionalString (cfg.database.passwordFile != null) ''
          export HEADSCALE_DB_PASS="$(head -n1 ${escapeShellArg cfg.database.passwordFile})"
        ''}

        ${optionalString (cfg.openIdConnect.clientSecretFile != null) ''
          export HEADSCALE_OIDC_CLIENT_SECRET="$(head -n1 ${escapeShellArg cfg.openIdConnect.clientSecretFile})"
        ''}
        exec ${cfg.package}/bin/headscale serve
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

  meta.maintainers = with maintainers; [ kradalby ];
}
