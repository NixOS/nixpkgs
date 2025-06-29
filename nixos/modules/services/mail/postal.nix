{
  config,
  lib,
  options,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.services.postal;
  opt = options.services.postal;

  yaml = pkgs.formats.yaml { };
  postalConfigFile = yaml.generate "postal-config.yml" cfg.settings;

in
{
  options.services.postal = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable Postal service, check [the manual](#module-services-postal)
        for basic usage example.
      '';
    };

    user = mkOption {
      type = types.str;
      default = "postal";
      description = "User to run postal and related services.";
    };

    createDatabaseLocally = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether a mariadb database should be automatically set up on the local host.
        Set to `false` if you want to provision a database yourself.
      '';
    };

    domain = mkOption {
      type = types.str;
      description = "The domain name for your postal installation.";
      example = "postal.example.com";
    };

    environmentFile = mkOption {
      type = with types; nullOr path;
      default = null;
      description = ''
        File to load environment variables, especially secrets that cannot be set
        via the module options. It should include `RAILS_SECRET_KEY`, which can
        be generated with `openssl rand -hex 64`.
        [List of available variables](https://github.com/postalserver/postal/blob/main/doc/config/environment-variables.md)
      '';
      example = "/run/secrets/postal.env";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to open the firewall port for the [smtp server](#opt-services.postal.settings.smtp_server.default_port).
        Note that it won't open the ports for the healthcheck services or the web UI, which should be placed behind a web proxy.
      '';
    };

    workers = mkOption {
      type = types.int;
      default = 1;
      description = "Number of workers to handle incoming and outgoing e-mail, to increase if you process lots of e-mails.";
    };

    settings = lib.mkOption {
      default = { };
      description = ''
        Options for postal configuration. Only [`settings.postal.signing_key_path`](#opt-services.postal.settings.postal.signing_key_path)
        is mandatory, refer to <https://github.com/postalserver/postal/blob/main/doc/config/yaml.yml> for details on all supported values.
      '';

      type = lib.types.submodule {
        freeformType = yaml.type;

        options = {
          postal = {
            web_hostname = mkOption {
              type = types.str;
              default = cfg.domain;
              defaultText = literalExpression "config.${opt.domain}";
              description = "The hostname that the Postal web interface runs on";
            };

            web_protocol = mkOption {
              type = types.enum [
                "http"
                "https"
              ];
              default = "https";
              description = "The HTTP protocol to use for the Postal web interface";
            };

            smtp_hostname = mkOption {
              type = types.str;
              default = cfg.domain;
              defaultText = literalExpression "config.${opt.domain}";
              description = "The hostname that the Postal SMTP server runs on";
            };

            signing_key_path = mkOption {
              type = types.path;
              description = ''
                Path to the private key used for signing.
                The web UI won't work without it, can be
                generated with `openssl genrsa 2048`
              '';
            };
          };

          web_server = {
            default_port = mkOption {
              type = types.port;
              default = 5000;
              description = "The default port the web server should listen on unless overriden by the PORT environment variable";
            };

            default_bind_address = mkOption {
              type = types.str;
              default = "localhost";
              description = "The default bind address the web server should listen on unless overriden by the BIND_ADDRESS environment variable";
            };
          };

          worker = {
            default_health_server_port = mkOption {
              type = types.port;
              default = 10130;
              description = ''
                The default port for the worker health server to listen on.
                If you have more than one worker, this port number will be
                incremented for every additional worker (10131, 10132, ...).
              '';
            };

            default_health_server_bind_address = mkOption {
              type = types.str;
              default = "localhost";
              description = "The default bind address for the worker health server to listen on";
            };
          };

          main_db = {
            host = mkOption {
              type = types.str;
              default = "localhost";
              description = "Hostname for the main MariaDB server";
            };

            port = mkOption {
              type = types.port;
              default = 3306;
              description = "The MariaDB port to connect to";
            };

            username = mkOption {
              type = types.str;
              default = cfg.user;
              defaultText = literalExpression "config.${opt.user}";
              description = "The MariaDB username";
            };

            database = mkOption {
              type = types.str;
              default = "postal";
              description = "The MariaDB database name";
            };

            encoding = mkOption {
              type = types.str;
              default = "utf8mb4";
              description = "The encoding to use when connecting to the MariaDB database";
            };
          };

          message_db = {
            host = mkOption {
              type = types.str;
              default = "localhost";
              description = "Hostname for the MariaDB server which stores the mail server databases";
            };

            port = mkOption {
              type = types.port;
              default = 3306;
              description = "The MariaDB port to connect to";
            };

            username = mkOption {
              type = types.str;
              default = cfg.user;
              defaultText = literalExpression "config.${opt.user}";
              description = "The MariaDB username";
            };

            encoding = mkOption {
              type = types.str;
              default = "utf8mb4";
              description = "The encoding to use when connecting to the MariaDB database";
            };

            database_name_prefix = mkOption {
              type = types.str;
              default = "postal";
              description = "The MariaDB prefix to add to database names";
            };
          };

          smtp_server = {
            default_port = mkOption {
              type = types.port;
              default = if cfg.settings.smtp_server.tls_enabled then 587 else 25;
              defaultText = literalExpression "if config.services.postal.settings.smtp_server.tls_enabled then 587 else 25";
              description = "The default port the SMTP server should listen on unless overriden by the PORT environment variable";
            };

            default_bind_address = mkOption {
              type = types.str;
              default = "::";
              description = "The default bind address the SMTP server should listen on unless overriden by the BIND_ADDRESS environment variable";
            };

            default_health_server_port = mkOption {
              type = types.port;
              default = 9091;
              description = "The default port for the SMTP server health server to listen on";
            };

            default_health_server_bind_address = mkOption {
              type = types.str;
              default = "localhost";
              description = "The default bind address for the SMTP server health server to listen on";
            };

            tls_enabled = mkOption {
              type = types.bool;
              default = false;
              description = "Enable TLS for the SMTP server (requires certificate)";
            };

            tls_certificate_path = mkOption {
              type = with types; nullOr path;
              default = null;
              description = "The path to the SMTP server's TLS certificate";
            };

            tls_private_key_path = mkOption {
              type = with types; nullOr path;
              default = null;
              description = "The path to the SMTP server's TLS private key";
            };
          };

          dns = {
            mx_records = mkOption {
              type = with types; listOf str;
              default = [
                "mx1.${cfg.domain}"
                "mx2.${cfg.domain}"
              ];
              defaultText = literalExpression ''
                [
                  "mx1" + config.${opt.domain}
                  "mx2" + config.${opt.domain}
                ]
              '';
              description = "The names of the default MX records";
            };

            spf_include = mkOption {
              type = types.str;
              default = "spf.${cfg.domain}";
              defaultText = literalExpression ''"spf." + config.${opt.domain}'';
              description = "The location of the SPF record";
            };

            return_path_domain = mkOption {
              type = types.str;
              default = "rp.${cfg.domain}";
              defaultText = literalExpression ''"rp." + config.${opt.domain}'';
              description = "The return path hostname";
            };

            route_domain = mkOption {
              type = types.str;
              default = "routes.${cfg.domain}";
              defaultText = literalExpression ''"routes." + config.${opt.domain}'';
              description = "The domain to use for hosting route-specific addresses";
            };

            track_domain = mkOption {
              type = types.str;
              default = "track.${cfg.domain}";
              defaultText = literalExpression ''"track." + config.${opt.domain}'';
              description = "The CNAME which tracking domains should be pointed to";
            };

            helo_hostname = mkOption {
              type = with types; nullOr str;
              default = null;
              description = "The hostname to use in HELO/EHLO when connecting to external SMTP servers";
            };
          };

          smtp = {
            host = mkOption {
              type = types.str;
              default = "localhost";
              description = "The hostname to send application-level e-mails to";
            };

            port = mkOption {
              type = types.port;
              default = cfg.settings.smtp_server.default_port;
              defaultText = literalExpression "config.services.postal.settings.smtp_server.default_port";
              description = "The port number to send application-level e-mails to";
            };

            username = mkOption {
              type = types.str;
              default = "postal";
              description = "The username to use when authentication to the SMTP server";
            };

            enable_starttls = mkOption {
              type = types.bool;
              default = cfg.settings.smtp_server.tls_enabled;
              defaultText = literalExpression "config.services.postal.settings.smtp_server.tls_enabled";
              description = "Use STARTTLS when connecting to the SMTP server and fail if unsupported";
            };

            from_address = mkOption {
              type = types.str;
              default = "postal@example.com";
              description = "The e-mail to use as the from address outgoing emails from Postal";
            };
          };

          version = mkOption {
            type = types.int;
            default = 2;
            description = "Version of the current Postal configuration";
          };
        };
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = optionals cfg.settings.smtp_server.tls_enabled [
      {
        assertion = cfg.settings.smtp_server.tls_certificate_path != null;
        message = "`services.postal.settings.smtp_server.tls_certificate_path` must be set when TLS is enabled.";
      }
      {
        assertion = cfg.settings.smtp_server.tls_private_key_path != null;
        message = "`services.postal.settings.smtp_server.tls_private_key_path` must be set when TLS is enabled.";
      }
    ];

    environment.systemPackages =
      let
        # disable IRB history to avoid an error when leaving the rails console
        irbRc = pkgs.writeText "postal-irb-rc" ''
          IRB.conf[:SAVE_HISTORY] = nil
          IRB.conf[:EVAL_HISTORY] = nil
        '';

        wrapper = pkgs.writeShellScriptBin "postal-wrapper" ''
          export IRBRC=${irbRc}
          export POSTAL_CONFIG_FILE_PATH=${postalConfigFile}
          ${lib.optionalString (cfg.environmentFile != null) "export $(cat ${cfg.environmentFile} | xargs)"}
          ${lib.getExe pkgs.postal} $@
        '';

        postal = pkgs.writeShellScriptBin "postal" ''
          /run/wrappers/bin/sudo -u ${cfg.user} ${lib.getExe wrapper} $@
        '';
      in
      [ postal ];

    networking.firewall.allowedTCPPorts = lib.optionals cfg.openFirewall [
      cfg.settings.smtp_server.default_port
    ];

    systemd.tmpfiles.settings."10-postal"."/run/postal".d = {
      mode = "0750";
      user = cfg.user;
      group = config.users.users.${cfg.user}.group;
    };

    users = optionalAttrs (cfg.user == "postal") {
      users.postal = {
        useDefaultShell = true;
        group = cfg.user;
        isSystemUser = true;
      };
      groups.${cfg.user} = { };
    };

    services.mysql = optionalAttrs cfg.createDatabaseLocally {
      enable = true;
      package = pkgs.mariadb;
      ensureDatabases = [ cfg.settings.main_db.database ];
      ensureUsers = [
        {
          name = cfg.user;
          ensurePermissions = {
            "${cfg.settings.main_db.database}.*" = "ALL PRIVILEGES";
            "\\`${cfg.settings.message_db.database_name_prefix}-%\\`.*" = "ALL PRIVILEGES";
          };
        }
      ];
    };

    systemd.targets.postal = {
      description = "Target for postal services.";
      wantedBy = [ "multi-user.target" ];
      wants = map (i: "postal-worker@${toString i}.service") (range 1 cfg.workers);
    };

    systemd.services =
      let
        serviceDefaults = {
          after = [ "postal-update.service" ];
          bindsTo = [ "postal-update.service" ];
          wantedBy = [ "postal.target" ];
          partOf = [ "postal.target" ];
          environment.POSTAL_CONFIG_FILE_PATH = postalConfigFile;
        };

        serviceConfigDefaults = {
          User = cfg.user;
          EnvironmentFile = optionals (cfg.environmentFile != null) cfg.environmentFile;

          # hardening
          BindReadOnlyPaths =
            [
              "/etc"
              builtins.storeDir
            ]
            ++ optional config.services.mysql.enable "/run/mysqld/mysqld.sock"
            ++ optional (
              cfg.settings.smtp_server.tls_certificate_path != null
            ) cfg.settings.smtp_server.tls_certificate_path
            ++ optional (
              cfg.settings.smtp_server.tls_private_key_path != null
            ) cfg.settings.smtp_server.tls_private_key_path;
          CapabilityBoundingSet = "";
          DevicePolicy = "closed";
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          NoNewPrivileges = true;
          PrivateDevices = true;
          PrivateTmp = true;
          ProcSubset = "pid";
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectHome = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectProc = "invisible";
          ProtectSystem = "strict";
          RemoveIPC = true;
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
            "AF_NETLINK"
            "AF_UNIX"
          ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          RootDirectory = "/run/postal";
          SystemCallArchitectures = "native";
          SystemCallFilter = [
            "@system-service"
            "~@privileged"
            "@chown"
          ];
          UMask = "0066";
        };

      in
      {
        postal-update = serviceDefaults // {
          after = optional config.services.mysql.enable "mysql.service";
          bindsTo = optional config.services.mysql.enable "mysql.service";
          serviceConfig = serviceConfigDefaults // {
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStart = "${lib.getExe pkgs.postal} update";
          };
        };

        postal-smtp = serviceDefaults // {
          serviceConfig = serviceConfigDefaults // {
            ExecStart = "${lib.getExe pkgs.postal} smtp-server";
            AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
            CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
          };
        };

        postal-web = serviceDefaults // {
          serviceConfig = serviceConfigDefaults // {
            Type = "notify";
            ExecStart = "${lib.getExe pkgs.postal} web-server";
          };
        };

        "postal-worker@" = serviceDefaults // {
          serviceConfig = serviceConfigDefaults // {
            ExecStart = ''
              ${lib.getExe pkgs.bash} -c "WORKER_DEFAULT_HEALTH_SERVER_PORT=$((%i - 1 + ${toString cfg.settings.worker.default_health_server_port})) ${pkgs.postal}/bin/postal worker"
            '';
          };
        };
      };
  };

  meta.doc = ./postal.md;
  meta.maintainers = with lib.maintainers; [ MatthieuBarthel ];
}
