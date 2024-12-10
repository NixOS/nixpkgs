{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.services.listmonk;
  tomlFormat = pkgs.formats.toml { };
  cfgFile = tomlFormat.generate "listmonk.toml" cfg.settings;
  # Escaping is done according to https://www.postgresql.org/docs/current/sql-syntax-lexical.html#SQL-SYNTAX-CONSTANTS
  setDatabaseOption =
    key: value:
    "UPDATE settings SET value = '${
      lib.replaceStrings [ "'" ] [ "''" ] (builtins.toJSON value)
    }' WHERE key = '${key}';";
  updateDatabaseConfigSQL = pkgs.writeText "update-database-config.sql" (
    concatStringsSep "\n" (
      mapAttrsToList setDatabaseOption (
        if (cfg.database.settings != null) then cfg.database.settings else { }
      )
    )
  );
  updateDatabaseConfigScript = pkgs.writeShellScriptBin "update-database-config.sh" ''
    ${
      if cfg.database.mutableSettings then
        ''
          if [ ! -f /var/lib/listmonk/.db_settings_initialized ]; then
            ${pkgs.postgresql}/bin/psql -d listmonk -f ${updateDatabaseConfigSQL} ;
            touch /var/lib/listmonk/.db_settings_initialized
          fi
        ''
      else
        "${pkgs.postgresql}/bin/psql -d listmonk -f ${updateDatabaseConfigSQL}"
    }
  '';

  databaseSettingsOpts = with types; {
    freeformType = oneOf [
      (listOf str)
      (listOf (attrsOf anything))
      str
      int
      bool
    ];

    options = {
      "app.notify_emails" = mkOption {
        type = listOf str;
        default = [ ];
        description = "Administrator emails for system notifications";
      };

      "privacy.exportable" = mkOption {
        type = listOf str;
        default = [
          "profile"
          "subscriptions"
          "campaign_views"
          "link_clicks"
        ];
        description = "List of fields which can be exported through an automatic export request";
      };

      "privacy.domain_blocklist" = mkOption {
        type = listOf str;
        default = [ ];
        description = "E-mail addresses with these domains are disallowed from subscribing.";
      };

      smtp = mkOption {
        type = listOf (submodule {
          freeformType = with types; attrsOf anything;

          options = {
            enabled = mkEnableOption "this SMTP server for listmonk";
            host = mkOption {
              type = types.str;
              description = "Hostname for the SMTP server";
            };
            port = mkOption {
              type = types.port;
              description = "Port for the SMTP server";
            };
            max_conns = mkOption {
              type = types.int;
              description = "Maximum number of simultaneous connections, defaults to 1";
              default = 1;
            };
            tls_type = mkOption {
              type = types.enum [
                "none"
                "STARTTLS"
                "TLS"
              ];
              description = "Type of TLS authentication with the SMTP server";
            };
          };
        });

        description = "List of outgoing SMTP servers";
      };

      # TODO: refine this type based on the smtp one.
      "bounce.mailboxes" = mkOption {
        type = listOf (submodule {
          freeformType = with types; listOf (attrsOf anything);
        });
        default = [ ];
        description = "List of bounce mailboxes";
      };

      messengers = mkOption {
        type = listOf str;
        default = [ ];
        description = "List of messengers, see: <https://github.com/knadh/listmonk/blob/master/models/settings.go#L64-L74> for options.";
      };
    };
  };
in
{
  ###### interface
  options = {
    services.listmonk = {
      enable = mkEnableOption "Listmonk, this module assumes a reverse proxy to be set";
      database = {
        createLocally = mkOption {
          type = types.bool;
          default = false;
          description = "Create the PostgreSQL database and database user locally.";
        };

        settings = mkOption {
          default = null;
          type = with types; nullOr (submodule databaseSettingsOpts);
          description = "Dynamic settings in the PostgreSQL database, set by a SQL script, see <https://github.com/knadh/listmonk/blob/master/schema.sql#L177-L230> for details.";
        };
        mutableSettings = mkOption {
          type = types.bool;
          default = true;
          description = ''
            Database settings will be reset to the value set in this module if this is not enabled.
            Enable this if you want to persist changes you have done in the application.
          '';
        };
      };
      package = mkPackageOption pkgs "listmonk" { };
      settings = mkOption {
        type = types.submodule { freeformType = tomlFormat.type; };
        description = ''
          Static settings set in the config.toml, see <https://github.com/knadh/listmonk/blob/master/config.toml.sample> for details.
          You can set secrets using the secretFile option with environment variables following <https://listmonk.app/docs/configuration/#environment-variables>.
        '';
      };
      secretFile = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "A file containing secrets as environment variables. See <https://listmonk.app/docs/configuration/#environment-variables> for details on supported values.";
      };
    };
  };

  ###### implementation
  config = mkIf cfg.enable {
    # Default parameters from https://github.com/knadh/listmonk/blob/master/config.toml.sample
    services.listmonk.settings."app".address = mkDefault "localhost:9000";
    services.listmonk.settings."db" = mkMerge [
      ({
        max_open = mkDefault 25;
        max_idle = mkDefault 25;
        max_lifetime = mkDefault "300s";
      })
      (mkIf cfg.database.createLocally {
        host = mkDefault "/run/postgresql";
        port = mkDefault 5432;
        user = mkDefault "listmonk";
        database = mkDefault "listmonk";
      })
    ];

    services.postgresql = mkIf cfg.database.createLocally {
      enable = true;

      ensureUsers = [
        {
          name = "listmonk";
          ensureDBOwnership = true;
        }
      ];

      ensureDatabases = [ "listmonk" ];
    };

    systemd.services.listmonk = {
      description = "Listmonk - newsletter and mailing list manager";
      after = [ "network.target" ] ++ optional cfg.database.createLocally "postgresql.service";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "exec";
        EnvironmentFile = mkIf (cfg.secretFile != null) [ cfg.secretFile ];
        ExecStartPre = [
          # StateDirectory cannot be used when DynamicUser = true is set this way.
          # Indeed, it will try to create all the folders and realize one of them already exist.
          # Therefore, we have to create it ourselves.
          ''${pkgs.coreutils}/bin/mkdir -p "''${STATE_DIRECTORY}/listmonk/uploads"''
          # setup database if not already done
          "${cfg.package}/bin/listmonk --config ${cfgFile} --idempotent --install --yes"
          # apply db migrations (setup and migrations can not be done in one step
          # with "--install --upgrade" listmonk ignores the upgrade)
          "${cfg.package}/bin/listmonk --config ${cfgFile} --upgrade --yes"
          "${updateDatabaseConfigScript}/bin/update-database-config.sh"
        ];
        ExecStart = "${cfg.package}/bin/listmonk --config ${cfgFile}";

        Restart = "on-failure";

        StateDirectory = [ "listmonk" ];

        User = "listmonk";
        Group = "listmonk";
        DynamicUser = true;
        NoNewPrivileges = true;
        CapabilityBoundingSet = "";
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ];
        PrivateDevices = true;
        ProtectControlGroups = true;
        ProtectKernelTunables = true;
        ProtectHome = true;
        RestrictNamespaces = true;
        RestrictRealtime = true;
        UMask = "0027";
        MemoryDenyWriteExecute = true;
        LockPersonality = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        ProtectKernelModules = true;
        PrivateUsers = true;
      };
    };
  };
}
