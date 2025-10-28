{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.warpgate;
  yaml = pkgs.formats.yaml { };
in
{
  options.services.warpgate =
    let
      inherit (lib.types)
        nullOr
        enum
        str
        bool
        port
        listOf
        attrsOf
        submodule
        ;
      inherit (lib.options) mkOption mkPackageOption literalExpression;
    in
    {
      enable = mkOption {
        description = ''
          Whether to enable Warpgate.
          This module will initialize Warpgate base on your config automatically. Please run `warpgate recover-access` to gain access.
        '';
        type = bool;
        default = false;
      };

      package = mkPackageOption pkgs "warpgate" { };

      databaseUrlFile = mkOption {
        description = ''
          Path to file containing database connection string with credentials.
          Should be a one line file with: `database_url: <protocol>://<username>:<password>@<host>/<database>`.
          See [SeaORM documentation](https://www.sea-ql.org/SeaORM/docs/install-and-config/connection/).
        '';
        type = nullOr str;
        default = null;
      };

      settings = mkOption {
        description = "Warpgate configuration.";
        type = submodule {
          freeformType = yaml.type;
          options = {
            sso_providers = mkOption {
              description = "Configure OIDC single sign-on providers.";
              default = [ ];
              type = listOf (submodule {
                freeformType = yaml.type;
                options = {
                  name = mkOption {
                    description = "Internal identifier of SSO provider.";
                    type = str;
                  };
                  label = mkOption {
                    description = "SSO provider name displayed on login page.";
                    type = str;
                  };
                  provider = mkOption {
                    description = "SSO provider configurations.";
                    type = attrsOf yaml.type;
                  };
                };
              });
              example = literalExpression ''
                [
                  {
                    name = "3rd party SSO";
                    label = "ACME SSO";
                    provider = {
                      type = "custom";
                      client_id = "123...";
                      client_secret = "BC...";
                      issuer_url = "https://sso.acme.inc";
                      scopes = ["email"];
                    };
                  }
                  {
                    ...
                  }
                ]
              '';
            };
            recordings = {
              enable = mkOption {
                description = "Whether to enable session recording.";
                default = true;
                type = bool;
              };
              path = mkOption {
                description = "Path to store session recordings.";
                default = "/var/lib/warpgate/recordings";
                type = str;
              };
            };
            external_host = mkOption {
              description = ''
                Configure the domain name of this Warpgate instance.
                See [HTTP domain binding](https://warpgate.null.page/http-domain-binding/).
              '';
              default = null;
              type = nullOr str;
            };
            database_url = mkOption {
              description = ''
                Database connection string.
                See [SeaORM documentation](https://www.sea-ql.org/SeaORM/docs/install-and-config/connection/).
              '';
              default = "sqlite:/var/lib/warpgate/db";
              type = nullOr str;
            };
            ssh = {
              enable = mkOption {
                description = "Whether to enable SSH listener.";
                default = false;
                type = bool;
              };
              listen = mkOption {
                description = "Listen endpoint of SSH listener.";
                default = "[::]:2222";
                type = str;
              };
              external_port = mkOption {
                description = "The SSH listener is reachable via this port externally.";
                default = null;
                type = nullOr port;
              };
              keys = mkOption {
                description = "Path to store SSH host & client keys.";
                default = "/var/lib/warpgate/ssh-keys";
                type = str;
              };
              host_key_verification = mkOption {
                description = "Specify host key verification action when connecting to a SSH target with unknown/differing host key.";
                default = "prompt";
                type = enum [
                  "prompt"
                  "auto_accept"
                  "auto_reject"
                ];
              };
              inactivity_timeout = mkOption {
                description = "How long can user be inactive until Warpgate terminates the connection.";
                default = "5m";
                type = str;
              };
              keepalive_interval = mkOption {
                description = "If nothing is received from the client for this amount of time, server will send a keepalive message.";
                default = null;
                type = nullOr str;
              };
            };
            http = {
              listen = mkOption {
                description = "Listen endpoint of HTTP listener.";
                default = "[::]:8888";
                type = str;
              };
              external_port = mkOption {
                description = "The HTTP listener is reachable via this port externally.";
                default = null;
                type = nullOr port;
              };
              certificate = mkOption {
                description = "Path to HTTPS listener certificate.";
                default = "/var/lib/warpgate/tls.certificate.pem";
                type = str;
              };
              key = mkOption {
                description = "Path to HTTPS listener private key.";
                default = "/var/lib/warpgate/tls.key.pem";
                type = str;
              };
              sni_certificates = mkOption {
                description = "Certificates for additional domains.";
                default = [ ];
                type = listOf (submodule {
                  freeformType = yaml.type;
                  options = {
                    certificate = mkOption {
                      description = "Path to certificate.";
                      default = "";
                      type = str;
                    };
                    key = mkOption {
                      description = "Path to private key.";
                      default = "";
                      type = str;
                    };
                  };
                });
                example = literalExpression ''
                  [
                    {
                      certificate = "/var/lib/warpgate/example.tld.pem";
                      key = "/var/lib/warpgate/example.tld.key.pem";
                    }
                    {
                      ...
                    }
                  ]
                '';
              };
              trust_x_forwarded_headers = mkOption {
                description = ''
                  Trust X-Forwarded-* headers. Required when being reverse proxied.
                  See [Running behind a reverse proxy](https://warpgate.null.page/reverse-proxy/).
                '';
                default = false;
                type = bool;
              };
              session_max_age = mkOption {
                description = "How long until a logged in session expires.";
                default = "30m";
                type = str;
              };
              cookie_max_age = mkOption {
                description = "How long until logged in cookie expires.";
                default = "1day";
                type = str;
              };
            };
            mysql = {
              enable = mkOption {
                description = "Whether to enable MySQL listener.";
                default = false;
                type = bool;
              };
              listen = mkOption {
                description = "Listen endpoint of MySQL listener.";
                default = "[::]:33306";
                type = str;
              };
              external_port = mkOption {
                description = "The MySQL listener is reachable via this port externally.";
                default = null;
                type = nullOr port;
              };
              certificate = mkOption {
                description = "Path to MySQL listener certificate.";
                default = "/var/lib/warpgate/tls.certificate.pem";
                type = str;
              };
              key = mkOption {
                description = "Path to MySQL listener private key.";
                default = "/var/lib/warpgate/tls.key.pem";
                type = str;
              };
            };
            postgres = {
              enable = mkOption {
                description = "Whether to enable PostgreSQL listener.";
                default = false;
                type = bool;
              };
              listen = mkOption {
                description = "Listen endpoint of PostgreSQL listener.";
                default = "[::]:55432";
                type = str;
              };
              external_port = mkOption {
                description = "The PostgreSQL listener is reachable via this port externally.";
                default = null;
                type = nullOr str;
              };
              certificate = mkOption {
                description = "Path to PostgreSQL listener certificate.";
                default = "/var/lib/warpgate/tls.certificate.pem";
                type = str;
              };
              key = mkOption {
                description = "Path to PostgreSQL listener private key.";
                default = "/var/lib/warpgate/tls.key.pem";
                type = str;
              };
            };
            log = {
              retention = mkOption {
                description = "How long Warpgate keep its logs.";
                default = "7days";
                type = str;
              };
              send_to = mkOption {
                description = ''
                  Path of UNIX socket of log forwarder.
                  See [Log forwarding](https://warpgate.null.page/log-forwarding/);
                '';
                default = null;
                type = nullOr str;
              };
            };
            config_provider = mkOption {
              description = ''
                Source of truth of users.
                DO NOT change this, Warpgate only implemented database provider.
              '';
              default = "database";
              type = enum [
                "file"
                "database"
              ];
            };
          };
        };
        default = { };
        example = {
          ssh = {
            enable = true;
            listen = "[::]:2211";
          };
          http = {
            listen = "[::]:8011";
          };
        };
      };
    };

  config =
    let
      inherit (lib.lists)
        any
        map
        head
        reverseList
        ;
      inherit (lib.strings) splitString toIntBase10;

      preStartScript = pkgs.writers.writeBash "warpgate-init" ''
        CFGFILE=/var/lib/warpgate/config.yaml
        if [ ! -O $CFGFILE ] || [ ! -s $CFGFILE ]; then
          INITPWD=$(tr -dc 'A-Za-z0-9!?%=' </dev/urandom 2>/dev/null | head -c 16)
          ${lib.getExe cfg.package} \
            --config $CFGFILE unattended-setup \
            --data-path /var/lib/warpgate \
            --http-port 8888 \
            --admin-password $INITPWD
        fi
        ${
          if cfg.databaseUrlFile != null then
            ''
              sed -e '/^database_url: null/d' ${yaml.generate "warpgate-config" cfg.settings} > $CFGFILE
              cat /run/credentials/warpgate.service/databaseUrl >> $CFGFILE
            ''
          else
            "cp --no-preserve=ownership ${yaml.generate "warpgate-config" cfg.settings} $CFGFILE"
        }
      '';
      bindOnPrivilegedPorts = any (x: toIntBase10 x < 1025) (
        map (x: head (reverseList (splitString ":" x))) (
          [ cfg.settings.http.listen ]
          ++ lib.optional cfg.settings.ssh.enable cfg.settings.ssh.listen
          ++ lib.optional cfg.settings.mysql.enable cfg.settings.mysql.listen
          ++ lib.optional cfg.settings.postgres.enable cfg.settings.postgres.listen
        )
      );
    in
    lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = !((cfg.databaseUrlFile != null) && (cfg.settings.database_url != null));
          message = "You cannot configure databaseUrlFile and settings.database_url at the same time.";
        }
        {
          assertion = !((cfg.databaseUrlFile == null) && (cfg.settings.database_url == null));
          message = "Either databaseUrlFile or settings.database_url must be set; Set the other to null.";
        }
      ];

      environment.systemPackages = [ cfg.package ];

      systemd.services.warpgate = {
        description = "Warpgate smart bastion";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        startLimitBurst = 5;
        serviceConfig = {
          LoadCredential = "${
            if cfg.databaseUrlFile != null then "databaseUrl:${cfg.databaseUrlFile}" else ""
          }";
          ExecStartPre = preStartScript;
          ExecStart = "${lib.getExe cfg.package} --config /var/lib/warpgate/config.yaml run";
          DynamicUser = true;
          RestartSec = 3;
          Restart = "on-failure";
          StateDirectory = "warpgate";
          StateDirectoryMode = "0700";
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          NoNewPrivileges = true;
          PrivateTmp = true;
          ProtectHome = true;
          PrivateDevices = true;
          DeviceAllow = [
            "/dev/null rw"
            "/dev/urandom r"
          ];
          DevicePolicy = "strict";
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          RestrictNamespaces = true;
          ProtectProc = "invisible";
          ProtectSystem = "full";
          ProtectClock = true;
          ProtectControlGroups = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          RemoveIPC = true;
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
            "AF_UNIX"
          ];
          SystemCallArchitectures = "native";
          SystemCallFilter = [
            "@system-service"
            "~@privileged"
          ];
        }
        // (
          if bindOnPrivilegedPorts then
            {
              AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
              CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
            }
          else
            {
              PrivateUsers = true;
            }
        );
      };
    };

  meta.maintainers = with lib.maintainers; [ alemonmk ];
}
