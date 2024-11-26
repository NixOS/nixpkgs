{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.portunus;

in
{
  options.services.portunus = {
    enable = lib.mkEnableOption "Portunus, a self-contained user/group management and authentication service for LDAP";

    domain = lib.mkOption {
      type = lib.types.str;
      example = "sso.example.com";
      description = "Subdomain which gets reverse proxied to Portunus webserver.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8080;
      description = ''
        Port where the Portunus webserver should listen on.

        This must be put behind a TLS-capable reverse proxy because Portunus only listens on localhost.
      '';
    };

    package = lib.mkPackageOption pkgs "portunus" { };

    seedPath = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Path to a portunus seed file in json format.
        See <https://github.com/majewsky/portunus#seeding-users-and-groups-from-static-configuration> for available options.
      '';
    };

    seedSettings = lib.mkOption {
      type = with lib.types; nullOr (attrsOf (listOf (attrsOf anything)));
      default = null;
      description = ''
        Seed settings for users and groups.
        See upstream for format <https://github.com/majewsky/portunus#seeding-users-and-groups-from-static-configuration>
      '';
    };

    stateDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/portunus";
      description = "Path where Portunus stores its state.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "portunus";
      description = "User account under which Portunus runs its webserver.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "portunus";
      description = "Group account under which Portunus runs its webserver.";
    };

    dex = {
      enable = lib.mkEnableOption ''
        Dex ldap connector.

        To activate dex, first a search user must be created in the Portunus web ui
        and then the password must to be set as the `DEX_SEARCH_USER_PASSWORD` environment variable
        in the [](#opt-services.dex.environmentFile) setting
      '';

      oidcClients = lib.mkOption {
        type = lib.types.listOf (
          lib.types.submodule {
            options = {
              callbackURL = lib.mkOption {
                type = lib.types.str;
                description = "URL where the OIDC client should redirect";
              };
              id = lib.mkOption {
                type = lib.types.str;
                description = "ID of the OIDC client";
              };
            };
          }
        );
        default = [ ];
        example = [
          {
            callbackURL = "https://example.com/client/oidc/callback";
            id = "service";
          }
        ];
        description = ''
          List of OIDC clients.

          The OIDC secret must be set as the `DEX_CLIENT_''${id}` environment variable
          in the [](#opt-services.dex.environmentFile) setting.

          ::: {.note}
          Make sure the id only contains characters that are allowed in an environment variable name, e.g. no -.
          :::
        '';
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 5556;
        description = "Port where dex should listen on.";
      };
    };

    ldap = {
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.openldap;
        defaultText = lib.literalExpression "pkgs.openldap.override { libxcrypt = pkgs.libxcrypt-legacy; }";
        description = "The OpenLDAP package to use.";
      };

      searchUserName = lib.mkOption {
        type = lib.types.str;
        default = "";
        example = "admin";
        description = ''
          The login name of the search user.
          This user account must be configured in Portunus either manually or via seeding.
        '';
      };

      suffix = lib.mkOption {
        type = lib.types.str;
        example = "dc=example,dc=org";
        description = ''
          The DN of the topmost entry in your LDAP directory.
          Please refer to the Portunus documentation for more information on how this impacts the structure of the LDAP directory.
        '';
      };

      tls = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to enable LDAPS protocol.
          This also adds two entries to the `/etc/hosts` file to point [](#opt-services.portunus.domain) to localhost,
          so that CLIs and programs can use ldaps protocol and verify the certificate without opening the firewall port for the protocol.

          This requires a TLS certificate for [](#opt-services.portunus.domain) to be configured via [](#opt-security.acme.certs).
        '';
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "openldap";
        description = "User account under which Portunus runs its LDAP server.";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "openldap";
        description = "Group account under which Portunus runs its LDAP server.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.dex.enable -> cfg.ldap.searchUserName != "";
        message = "services.portunus.dex.enable requires services.portunus.ldap.searchUserName to be set.";
      }
    ];

    # add ldapsearch(1) etc. to interactive shells
    environment.systemPackages = [ cfg.ldap.package ];

    # allow connecting via ldaps /w certificate without opening ports
    networking.hosts = lib.mkIf cfg.ldap.tls {
      "::1" = [ cfg.domain ];
      "127.0.0.1" = [ cfg.domain ];
    };

    services = {
      dex = lib.mkIf cfg.dex.enable {
        enable = true;
        settings = {
          issuer = "https://${cfg.domain}/dex";
          web.http = "127.0.0.1:${toString cfg.dex.port}";
          storage = {
            type = "sqlite3";
            config.file = "/var/lib/dex/dex.db";
          };
          enablePasswordDB = false;
          connectors = [
            {
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
                  userMatchers = [
                    {
                      userAttr = "DN";
                      groupAttr = "member";
                    }
                  ];
                };
              };
            }
          ];

          staticClients = lib.forEach cfg.dex.oidcClients (client: {
            inherit (client) id;
            redirectURIs = [ client.callbackURL ];
            name = "OIDC for ${client.id}";
            secretEnv = "DEX_CLIENT_${client.id}";
          });
        };
      };

      portunus.seedPath = lib.mkIf (cfg.seedSettings != null) (
        pkgs.writeText "seed.json" (builtins.toJSON cfg.seedSettings)
      );
    };

    systemd.services = {
      dex = lib.mkIf cfg.dex.enable {
        serviceConfig = {
          # `dex.service` is super locked down out of the box, but we need some
          # place to write the SQLite database. This creates $STATE_DIRECTORY below
          # /var/lib/private because DynamicUser=true, but it gets symlinked into
          # /var/lib/dex inside the unit
          StateDirectory = "dex";
        };
      };

      portunus = {
        description = "Self-contained authentication service";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig = {
          ExecStart = "${cfg.package}/bin/portunus-orchestrator";
          Restart = "on-failure";
        };
        environment =
          {
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
          }
          // (lib.optionalAttrs (cfg.seedPath != null) ({
            PORTUNUS_SEED_PATH = cfg.seedPath;
          }))
          // (lib.optionalAttrs cfg.ldap.tls (
            let
              acmeDirectory = config.security.acme.certs."${cfg.domain}".directory;
            in
            {
              PORTUNUS_SERVER_HTTP_SECURE = "true";
              PORTUNUS_SLAPD_TLS_CA_CERTIFICATE = "/etc/ssl/certs/ca-certificates.crt";
              PORTUNUS_SLAPD_TLS_CERTIFICATE = "${acmeDirectory}/cert.pem";
              PORTUNUS_SLAPD_TLS_DOMAIN_NAME = cfg.domain;
              PORTUNUS_SLAPD_TLS_PRIVATE_KEY = "${acmeDirectory}/key.pem";
            }
          ));
      };
    };

    users.users = lib.mkMerge [
      (lib.mkIf (cfg.ldap.user == "openldap") {
        openldap = {
          group = cfg.ldap.group;
          isSystemUser = true;
        };
      })
      (lib.mkIf (cfg.user == "portunus") {
        portunus = {
          group = cfg.group;
          isSystemUser = true;
        };
      })
    ];

    users.groups = lib.mkMerge [
      (lib.mkIf (cfg.ldap.user == "openldap") {
        openldap = { };
      })
      (lib.mkIf (cfg.user == "portunus") {
        portunus = { };
      })
    ];
  };

  meta.maintainers = [ lib.maintainers.majewsky ] ++ lib.teams.c3d2.members;
}
