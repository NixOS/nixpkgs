{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let
  inherit (utils)
    recursiveGetAttrsetWithJqPrefix
    ;

  inherit (lib)
    attrNames
    concatStringsSep
    escapeShellArg
    getExe
    getExe'
    imap1
    mapAttrs
    optionalString
    ;

  cfg = config.services.listmonk;
  tomlFormat = pkgs.formats.toml { };
  cfgFile = tomlFormat.generate "listmonk.toml" cfg.settings;

  # Adapted script from genJqSecretsReplacementSnippet
  updateDatabaseConfig =
    let
      set = cfg.database.settings;
      secretsRaw = recursiveGetAttrsetWithJqPrefix set "_secret";
      secrets = mapAttrs (
        _name: set:
        {
          quote = true;
        }
        // set
      ) secretsRaw;
      stringOrDefault = str: def: if str == "" then def else str;
    in
    ''
      inherit_errexit_enabled=0
      shopt -pq inherit_errexit && inherit_errexit_enabled=1
      shopt -s inherit_errexit
    ''
    + concatStringsSep "\n" (
      imap1 (index: name: ''
        secret${toString index}=$(<'${secrets.${name}._secret}')
        export secret${toString index}
      '') (attrNames secrets)
    )
    + "\n"
    + "json=$(${getExe pkgs.jq} "
    + escapeShellArg (
      stringOrDefault (concatStringsSep " | " (
        imap1 (
          index: name:
          ''${name} = ($ENV.secret${toString index}${optionalString (!secrets.${name}.quote) " | fromjson"})''
        ) (attrNames secrets)
      )) "."
    )
    + ''
        <<'EOF'
      ${builtins.toJSON set}
      EOF)

      (( ! inherit_errexit_enabled )) && shopt -u inherit_errexit

      ${getExe' pkgs.postgresql "psql"} -d listmonk <<< "SELECT * FROM settings WHERE key='privacy.exportable'"

      echo "$json" | ${getExe pkgs.jq} ". | keys[]" --raw-output | \
      while IFS= read -r key; do
        value=$(echo "$json" | ${getExe pkgs.jq} ".$key")

        ${getExe' pkgs.postgresql "psql"} -d listmonk -v key="$key" -v value="$value" <<< "
          UPDATE settings SET value=:'value' WHERE key=:'key'
        "
      done
    '';

  updateDatabaseConfigScript = pkgs.writeShellScriptBin "update-database-config.sh" ''
    ${
      if cfg.database.mutableSettings then
        ''
          if [ ! -f /var/lib/listmonk/.db_settings_initialized ]; then
            ${updateDatabaseConfig}
            touch /var/lib/listmonk/.db_settings_initialized
          fi
        ''
      else
        updateDatabaseConfig
    }
  '';

  databaseSettingsOpts = with lib.types; {
    freeformType = attrsOf (oneOf [
      (listOf str)
      (listOf (attrsOf anything))
      str
      int
      bool
    ]);

    options = {
      "app.notify_emails" = lib.mkOption {
        type = listOf str;
        default = [ ];
        description = "Administrator emails for system notifications";
      };

      "privacy.exportable" = lib.mkOption {
        type = listOf str;
        default = [
          "profile"
          "subscriptions"
          "campaign_views"
          "link_clicks"
        ];
        description = "List of fields which can be exported through an automatic export request";
      };

      "privacy.domain_blocklist" = lib.mkOption {
        type = listOf str;
        default = [ ];
        description = "E-mail addresses with these domains are disallowed from subscribing.";
      };

      smtp = lib.mkOption {
        type = listOf (submodule {
          freeformType = with lib.types; attrsOf anything;

          options = {
            enabled = lib.mkEnableOption "this SMTP server for listmonk";
            host = lib.mkOption {
              type = lib.types.str;
              description = "Hostname for the SMTP server";
            };
            port = lib.mkOption {
              type = lib.types.port;
              description = "Port for the SMTP server";
            };
            max_conns = lib.mkOption {
              type = lib.types.int;
              description = "Maximum number of simultaneous connections, defaults to 1";
              default = 1;
            };
            tls_type = lib.mkOption {
              type = lib.types.enum [
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
      "bounce.mailboxes" = lib.mkOption {
        type = listOf (submodule {
          freeformType = with lib.types; listOf (attrsOf anything);
        });
        default = [ ];
        description = "List of bounce mailboxes";
      };

      messengers = lib.mkOption {
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
      enable = lib.mkEnableOption "Listmonk, this module assumes a reverse proxy to be set";
      database = {
        createLocally = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Create the PostgreSQL database and database user locally.";
        };

        settings = lib.mkOption {
          default = null;
          type = with lib.types; nullOr (submodule databaseSettingsOpts);
          description = ''
            Dynamic settings in the PostgreSQL database, set by a SQL script,
            see <https://github.com/knadh/listmonk/blob/master/schema.sql#L177-L230> for details.

            Options containing secret data should be set to an attribute set containing the attribute
            _secret - a string pointing to a file containing the value the option should be set to.
          '';
        };

        mutableSettings = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = ''
            Database settings will be reset to the value set in this module if this is not enabled.
            Enable this if you want to persist changes you have done in the application.
          '';
        };
      };
      package = lib.mkPackageOption pkgs "listmonk" { };
      settings = lib.mkOption {
        type = lib.types.submodule { freeformType = tomlFormat.type; };
        description = ''
          Static settings set in the config.toml, see <https://github.com/knadh/listmonk/blob/master/config.toml.sample> for details.
          You can set secrets using the secretFile option with environment variables following <https://listmonk.app/docs/configuration/#environment-variables>.
        '';
      };
      secretFile = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "A file containing secrets as environment variables. See <https://listmonk.app/docs/configuration/#environment-variables> for details on supported values.";
      };
    };
  };

  ###### implementation
  config = lib.mkIf cfg.enable {
    # Default parameters from https://github.com/knadh/listmonk/blob/master/config.toml.sample
    services.listmonk.settings."app".address = lib.mkDefault "localhost:9000";
    services.listmonk.settings."db" = lib.mkMerge [
      ({
        max_open = lib.mkDefault 25;
        max_idle = lib.mkDefault 25;
        max_lifetime = lib.mkDefault "300s";
      })
      (lib.mkIf cfg.database.createLocally {
        host = lib.mkDefault "/run/postgresql";
        port = lib.mkDefault 5432;
        user = lib.mkDefault "listmonk";
        database = lib.mkDefault "listmonk";
      })
    ];

    services.postgresql = lib.mkIf cfg.database.createLocally {
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
      after = [ "network.target" ] ++ lib.optional cfg.database.createLocally "postgresql.target";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "exec";
        EnvironmentFile = lib.mkIf (cfg.secretFile != null) [ cfg.secretFile ];
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
