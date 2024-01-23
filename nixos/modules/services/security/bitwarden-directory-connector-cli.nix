{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.bitwarden-directory-connector-cli;
in {
  options.services.bitwarden-directory-connector-cli = {
    enable = mkEnableOption "Bitwarden Directory Connector";

    package = mkPackageOption pkgs "bitwarden-directory-connector-cli" {};

    domain = mkOption {
      type = types.str;
      description = lib.mdDoc "The domain the Bitwarden/Vaultwarden is accessible on.";
      example = "https://vaultwarden.example.com";
    };

    user = mkOption {
      type = types.str;
      description = lib.mdDoc "User to run the program.";
      default = "bwdc";
    };

    interval = mkOption {
      type = types.str;
      default = "*:0,15,30,45";
      description = lib.mdDoc "The interval when to run the connector. This uses systemd's OnCalendar syntax.";
    };

    ldap = mkOption {
      description = lib.mdDoc ''
        Options to configure the LDAP connection.
        If you used the desktop application to test the configuration you can find the settings by searching for `ldap` in `~/.config/Bitwarden\ Directory\ Connector/data.json`.
      '';
      default = {};
      type = types.submodule ({
        config,
        options,
        ...
      }: {
        freeformType = types.attrsOf (pkgs.formats.json {}).type;

        config.finalJSON = builtins.toJSON (removeAttrs config (filter (x: x == "finalJSON" || ! options.${x}.isDefined or false) (attrNames options)));

        options = {
          finalJSON = mkOption {
            type = (pkgs.formats.json {}).type;
            internal = true;
            readOnly = true;
            visible = false;
          };

          ssl = mkOption {
            type = types.bool;
            default = false;
            description = lib.mdDoc "Whether to use TLS.";
          };
          startTls = mkOption {
            type = types.bool;
            default = false;
            description = lib.mdDoc "Whether to use STARTTLS.";
          };

          hostname = mkOption {
            type = types.str;
            description = lib.mdDoc "The host the LDAP is accessible on.";
            example = "ldap.example.com";
          };

          port = mkOption {
            type = types.port;
            default = 389;
            description = lib.mdDoc "Port LDAP is accessible on.";
          };

          ad = mkOption {
            type = types.bool;
            default = false;
            description = lib.mdDoc "Whether the LDAP Server is an Active Directory.";
          };

          pagedSearch = mkOption {
            type = types.bool;
            default = false;
            description = lib.mdDoc "Whether the LDAP server paginates search results.";
          };

          rootPath = mkOption {
            type = types.str;
            description = lib.mdDoc "Root path for LDAP.";
            example = "dc=example,dc=com";
          };

          username = mkOption {
            type = types.str;
            description = lib.mdDoc "The user to authenticate as.";
            example = "cn=admin,dc=example,dc=com";
          };
        };
      });
    };

    sync = mkOption {
      description = lib.mdDoc ''
        Options to configure what gets synced.
        If you used the desktop application to test the configuration you can find the settings by searching for `sync` in `~/.config/Bitwarden\ Directory\ Connector/data.json`.
      '';
      default = {};
      type = types.submodule ({
        config,
        options,
        ...
      }: {
        freeformType = types.attrsOf (pkgs.formats.json {}).type;

        config.finalJSON = builtins.toJSON (removeAttrs config (filter (x: x == "finalJSON" || ! options.${x}.isDefined or false) (attrNames options)));

        options = {
          finalJSON = mkOption {
            type = (pkgs.formats.json {}).type;
            internal = true;
            readOnly = true;
            visible = false;
          };

          removeDisabled = mkOption {
            type = types.bool;
            default = true;
            description = lib.mdDoc "Remove users from bitwarden groups if no longer in the ldap group.";
          };

          overwriteExisting = mkOption {
            type = types.bool;
            default = false;
            description =
              lib.mdDoc "Remove and re-add users/groups, See https://bitwarden.com/help/user-group-filters/#overwriting-syncs for more details.";
          };

          largeImport = mkOption {
            type = types.bool;
            default = false;
            description = lib.mdDoc "Enable if you are syncing more than 2000 users/groups.";
          };

          memberAttribute = mkOption {
            type = types.str;
            description = lib.mdDoc "Attribute that lists members in a LDAP group.";
            example = "uniqueMember";
          };

          creationDateAttribute = mkOption {
            type = types.str;
            description = lib.mdDoc "Attribute that lists a user's creation date.";
            example = "whenCreated";
          };

          useEmailPrefixSuffix = mkOption {
            type = types.bool;
            default = false;
            description = lib.mdDoc "If a user has no email address, combine a username prefix with a suffix value to form an email.";
          };
          emailPrefixAttribute = mkOption {
            type = types.str;
            description = lib.mdDoc "The attribute that contains the users username.";
            example = "accountName";
          };
          emailSuffix = mkOption {
            type = types.str;
            description = lib.mdDoc "Suffix for the email, normally @example.com.";
            example = "@example.com";
          };

          users = mkOption {
            type = types.bool;
            default = false;
            description = lib.mdDoc "Sync users.";
          };
          userPath = mkOption {
            type = types.str;
            description = lib.mdDoc "User directory, relative to root.";
            default = "ou=users";
          };
          userObjectClass = mkOption {
            type = types.str;
            description = lib.mdDoc "Class that users must have.";
            default = "inetOrgPerson";
          };
          userEmailAttribute = mkOption {
            type = types.str;
            description = lib.mdDoc "Attribute for a users email.";
            default = "mail";
          };
          userFilter = mkOption {
            type = types.str;
            description = lib.mdDoc "LDAP filter for users.";
            example = "(memberOf=cn=sales,ou=groups,dc=example,dc=com)";
            default = "";
          };

          groups = mkOption {
            type = types.bool;
            default = false;
            description = lib.mdDoc "Whether to sync ldap groups into BitWarden.";
          };
          groupPath = mkOption {
            type = types.str;
            description = lib.mdDoc "Group directory, relative to root.";
            default = "ou=groups";
          };
          groupObjectClass = mkOption {
            type = types.str;
            description = lib.mdDoc "A class that groups will have.";
            default = "groupOfNames";
          };
          groupNameAttribute = mkOption {
            type = types.str;
            description = lib.mdDoc "Attribute for a name of group.";
            default = "cn";
          };
          groupFilter = mkOption {
            type = types.str;
            description = lib.mdDoc "LDAP filter for groups.";
            example = "(cn=sales)";
            default = "";
          };
        };
      });
    };

    secrets = {
      ldap = mkOption {
        type = types.str;
        description = "Path to file that contains LDAP password for user in {option}`ldap.username";
      };

      bitwarden = {
        client_path_id = mkOption {
          type = types.str;
          description = "Path to file that contains Client ID.";
        };
        client_path_secret = mkOption {
          type = types.str;
          description = "Path to file that contains Client Secret.";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    users.groups."${cfg.user}" = {};
    users.users."${cfg.user}" = {
      isSystemUser = true;
      group = cfg.user;
    };

    systemd = {
      timers.bitwarden-directory-connector-cli = {
        description = "Sync timer for Bitwarden Directory Connector";
        wantedBy = ["timers.target"];
        after = ["network-online.target"];
        timerConfig = {
          OnCalendar = cfg.interval;
          Unit = "bitwarden-directory-connector-cli.service";
          Persistent = true;
        };
      };

      services.bitwarden-directory-connector-cli = {
        description = "Main process for Bitwarden Directory Connector";
        path = [pkgs.jq];

        environment = {
          BITWARDENCLI_CONNECTOR_APPDATA_DIR = "/tmp";
          BITWARDENCLI_CONNECTOR_PLAINTEXT_SECRETS = "true";
        };

        serviceConfig = {
          Type = "oneshot";
          User = "${cfg.user}";
          PrivateTmp = true;
          preStart = ''
            set -eo pipefail

            # create the config file
            ${lib.getExe cfg.package} data-file
            touch /tmp/data.json.tmp
            chmod 600 /tmp/data.json{,.tmp}

            ${lib.getExe cfg.package} config server ${cfg.domain}

            # now login to set credentials
            export BW_CLIENTID="$(< ${escapeShellArg cfg.secrets.bitwarden.client_path_id})"
            export BW_CLIENTSECRET="$(< ${escapeShellArg cfg.secrets.bitwarden.client_path_secret})"
            ${lib.getExe cfg.package} login

            jq '.authenticatedAccounts[0] as $account
              | .[$account].directoryConfigurations.ldap |= $ldap_data
              | .[$account].directorySettings.organizationId |= $orgID
              | .[$account].directorySettings.sync |= $sync_data' \
              --argjson ldap_data ${escapeShellArg cfg.ldap.finalJSON} \
              --arg orgID "''${BW_CLIENTID//organization.}" \
              --argjson sync_data ${escapeShellArg cfg.sync.finalJSON} \
              /tmp/data.json \
              > /tmp/data.json.tmp

            mv -f /tmp/data.json.tmp /tmp/data.json

            # final config
            ${lib.getExe cfg.package} config directory 0
            ${lib.getExe cfg.package} config ldap.password --secretfile ${cfg.secrets.ldap}
          '';

          ExecStart = "${lib.getExe cfg.package} sync";
        };
      };
    };
  };

  meta.maintainers = with maintainers; [Silver-Golden];
}
