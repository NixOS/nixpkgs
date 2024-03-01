{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.portunus;

in
{
  options.services.portunus = {
    enable = mkEnableOption (lib.mdDoc "Portunus, a self-contained user/group management and authentication service for LDAP");

    domain = mkOption {
      type = types.str;
      example = "sso.example.com";
      description = lib.mdDoc "Subdomain which gets reverse proxied to Portunus webserver.";
    };

    port = mkOption {
      type = types.port;
      default = 8080;
      description = lib.mdDoc ''
        Port where the Portunus webserver should listen on.

        This must be put behind a TLS-capable reverse proxy because Portunus only listens on localhost.
      '';
    };

    package = mkPackageOption pkgs "portunus" { };

    seedPath = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = lib.mdDoc ''
        Path to a portunus seed file in json format.
        See <https://github.com/majewsky/portunus#seeding-users-and-groups-from-static-configuration> for available options.
      '';
    };

    seedSettings = lib.mkOption {
      type = with lib.types; nullOr (attrsOf (listOf (attrsOf anything)));
      default = null;
      description = lib.mdDoc ''
        Seed settings for users and groups.
        See upstream for format <https://github.com/majewsky/portunus#seeding-users-and-groups-from-static-configuration>
      '';
    };

    stateDir = mkOption {
      type = types.path;
      default = "/var/lib/portunus";
      description = lib.mdDoc "Path where Portunus stores its state.";
    };

    user = mkOption {
      type = types.str;
      default = "portunus";
      description = lib.mdDoc "User account under which Portunus runs its webserver.";
    };

    group = mkOption {
      type = types.str;
      default = "portunus";
      description = lib.mdDoc "Group account under which Portunus runs its webserver.";
    };

    dex = {
      enable = mkEnableOption (lib.mdDoc ''
        Dex ldap connector.

        To activate dex, first a search user must be created in the Portunus web ui
        and then the password must to be set as the `DEX_SEARCH_USER_PASSWORD` environment variable
        in the [](#opt-services.dex.environmentFile) setting.
      '');

      oidcClients = mkOption {
        type = types.listOf (types.submodule {
          options = {
            callbackURL = mkOption {
              type = types.str;
              description = lib.mdDoc "URL where the OIDC client should redirect";
            };
            id = mkOption {
              type = types.str;
              description = lib.mdDoc "ID of the OIDC client";
            };
          };
        });
        default = [ ];
        example = [
          {
            callbackURL = "https://example.com/client/oidc/callback";
            id = "service";
          }
        ];
        description = lib.mdDoc ''
          List of OIDC clients.

          The OIDC secret must be set as the `DEX_CLIENT_''${id}` environment variable
          in the [](#opt-services.dex.environmentFile) setting.
        '';
      };

      port = mkOption {
        type = types.port;
        default = 5556;
        description = lib.mdDoc "Port where dex should listen on.";
      };
    };

    ldap = {
      package = mkOption {
        type = types.package;
        # needs openldap built with a libxcrypt that support crypt sha256 until users have had time to migrate to newer hashes
        # Ref: <https://github.com/majewsky/portunus/issues/2>
        # TODO: remove in NixOS 24.11 (cf. same note on pkgs/servers/portunus/default.nix)
        default = pkgs.openldap.override { libxcrypt = pkgs.libxcrypt-legacy; };
        defaultText = lib.literalExpression "pkgs.openldap.override { libxcrypt = pkgs.libxcrypt-legacy; }";
        description = lib.mdDoc "The OpenLDAP package to use.";
      };

      searchUserName = mkOption {
        type = types.str;
        default = "";
        example = "admin";
        description = lib.mdDoc ''
          The login name of the search user.
          This user account must be configured in Portunus either manually or via seeding.
        '';
      };

      suffix = mkOption {
        type = types.str;
        example = "dc=example,dc=org";
        description = lib.mdDoc ''
          The DN of the topmost entry in your LDAP directory.
          Please refer to the Portunus documentation for more information on how this impacts the structure of the LDAP directory.
        '';
      };

      tls = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to enable LDAPS protocol.
          This also adds two entries to the `/etc/hosts` file to point [](#opt-services.portunus.domain) to localhost,
          so that CLIs and programs can use ldaps protocol and verify the certificate without opening the firewall port for the protocol.

          This requires a TLS certificate for [](#opt-services.portunus.domain) to be configured via [](#opt-security.acme.certs).
        '';
      };

      user = mkOption {
        type = types.str;
        default = "openldap";
        description = lib.mdDoc "User account under which Portunus runs its LDAP server.";
      };

      group = mkOption {
        type = types.str;
        default = "openldap";
        description = lib.mdDoc "Group account under which Portunus runs its LDAP server.";
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.dex.enable -> cfg.ldap.searchUserName != "";
        message = "services.portunus.dex.enable requires services.portunus.ldap.searchUserName to be set.";
      }
    ];

    # add ldapsearch(1) etc. to interactive shells
    environment.systemPackages = [ cfg.ldap.package ];

    # allow connecting via ldaps /w certificate without opening ports
    networking.hosts = mkIf cfg.ldap.tls {
      "::1" = [ cfg.domain ];
      "127.0.0.1" = [ cfg.domain ];
    };

    services = {
      dex = mkIf cfg.dex.enable {
        enable = true;
        settings = {
          issuer = "https://${cfg.domain}/dex";
          web.http = "127.0.0.1:${toString cfg.dex.port}";
          storage = {
            type = "sqlite3";
            config.file = "/var/lib/dex/dex.db";
          };
          enablePasswordDB = false;
          connectors = [{
            type = "ldap";
            id = "ldap";
            name = "LDAP";
            config = {
              host = "${cfg.domain}:636";
              bindDN = "uid=${cfg.ldap.searchUserName},ou=users,${cfg.ldap.suffix}";
              bindPW = "$DEX_SEARCH_USER_PASSWORD";
              userSearch = {
                baseDN = "ou=users,${cfg.ldap.suffix}";
                filter = "(objectclass=person)";
                username = "uid";
                idAttr = "uid";
                emailAttr = "mail";
                nameAttr = "cn";
                preferredUsernameAttr = "uid";
              };
              groupSearch = {
                baseDN = "ou=groups,${cfg.ldap.suffix}";
                filter = "(objectclass=groupOfNames)";
                nameAttr = "cn";
                userMatchers = [{ userAttr = "DN"; groupAttr = "member"; }];
              };
            };
          }];

          staticClients = forEach cfg.dex.oidcClients (client: {
            inherit (client) id;
            redirectURIs = [ client.callbackURL ];
            name = "OIDC for ${client.id}";
            secretEnv = "DEX_CLIENT_${client.id}";
          });
        };
      };

      portunus.seedPath = lib.mkIf (cfg.seedSettings != null) (pkgs.writeText "seed.json" (builtins.toJSON cfg.seedSettings));
    };

    systemd.services = {
      dex.serviceConfig = mkIf cfg.dex.enable {
        # `dex.service` is super locked down out of the box, but we need some
        # place to write the SQLite database. This creates $STATE_DIRECTORY below
        # /var/lib/private because DynamicUser=true, but it gets symlinked into
        # /var/lib/dex inside the unit
        StateDirectory = "dex";
      };

      portunus = {
        description = "Self-contained authentication service";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig = {
          ExecStart = "${cfg.package}/bin/portunus-orchestrator";
          Restart = "on-failure";
        };
        environment = {
          PORTUNUS_LDAP_SUFFIX = cfg.ldap.suffix;
          PORTUNUS_SERVER_BINARY = "${cfg.package}/bin/portunus-server";
          PORTUNUS_SERVER_GROUP = cfg.group;
          PORTUNUS_SERVER_USER = cfg.user;
          PORTUNUS_SERVER_HTTP_LISTEN = "127.0.0.1:${toString cfg.port}";
          PORTUNUS_SERVER_STATE_DIR = cfg.stateDir;
          PORTUNUS_SLAPD_BINARY = "${cfg.ldap.package}/libexec/slapd";
          PORTUNUS_SLAPD_GROUP = cfg.ldap.group;
          PORTUNUS_SLAPD_USER = cfg.ldap.user;
          PORTUNUS_SLAPD_SCHEMA_DIR = "${cfg.ldap.package}/etc/schema";
        } // (optionalAttrs (cfg.seedPath != null) ({
          PORTUNUS_SEED_PATH = cfg.seedPath;
        })) // (optionalAttrs cfg.ldap.tls (
          let
            acmeDirectory = config.security.acme.certs."${cfg.domain}".directory;
          in
          {
            PORTUNUS_SERVER_HTTP_SECURE = "true";
            PORTUNUS_SLAPD_TLS_CA_CERTIFICATE = "/etc/ssl/certs/ca-certificates.crt";
            PORTUNUS_SLAPD_TLS_CERTIFICATE = "${acmeDirectory}/cert.pem";
            PORTUNUS_SLAPD_TLS_DOMAIN_NAME = cfg.domain;
            PORTUNUS_SLAPD_TLS_PRIVATE_KEY = "${acmeDirectory}/key.pem";
          }));
      };
    };

    users.users = mkMerge [
      (mkIf (cfg.ldap.user == "openldap") {
        openldap = {
          group = cfg.ldap.group;
          isSystemUser = true;
        };
      })
      (mkIf (cfg.user == "portunus") {
        portunus = {
          group = cfg.group;
          isSystemUser = true;
        };
      })
    ];

    users.groups = mkMerge [
      (mkIf (cfg.ldap.user == "openldap") {
        openldap = { };
      })
      (mkIf (cfg.user == "portunus") {
        portunus = { };
      })
    ];
  };

  meta.maintainers = [ maintainers.majewsky ] ++ teams.c3d2.members;
}
