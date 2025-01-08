{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.bitwarden-directory-connector-cli;
in
{
  options.services.bitwarden-directory-connector-cli = {
    enable = lib.mkEnableOption "Bitwarden Directory Connector";

    package = lib.mkPackageOption pkgs "bitwarden-directory-connector-cli" { };

    domain = lib.mkOption {
      type = lib.types.str;
      description = "The domain the Bitwarden/Vaultwarden is accessible on.";
      example = "https://vaultwarden.example.com";
    };

    user = lib.mkOption {
      type = lib.types.str;
      description = "User to run the program.";
      default = "bwdc";
    };

    interval = lib.mkOption {
      type = lib.types.str;
      default = "*:0,15,30,45";
      description = "The interval when to run the connector. This uses systemd's OnCalendar syntax.";
    };

    ldap = lib.mkOption {
      description = ''
        Options to configure the LDAP connection.
        If you used the desktop application to test the configuration you can find the settings by searching for `ldap` in `~/.config/Bitwarden\ Directory\ Connector/data.json`.
      '';
      default = { };
      type = lib.types.submodule (
        {
          config,
          options,
          ...
        }:
        {
          freeformType = lib.types.attrsOf (pkgs.formats.json { }).type;

          config.finalJSON = builtins.toJSON (
            removeAttrs config (
              lib.filter (x: x == "finalJSON" || !options.${x}.isDefined or false) (lib.attrNames options)
            )
          );

          options = {
            finalJSON = lib.mkOption {
              type = (pkgs.formats.json { }).type;
              internal = true;
              readOnly = true;
              visible = false;
            };

            ssl = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Whether to use TLS.";
            };
            startTls = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Whether to use STARTTLS.";
            };

            hostname = lib.mkOption {
              type = lib.types.str;
              description = "The host the LDAP is accessible on.";
              example = "ldap.example.com";
            };

            port = lib.mkOption {
              type = lib.types.port;
              default = 389;
              description = "Port LDAP is accessible on.";
            };

            ad = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Whether the LDAP Server is an Active Directory.";
            };

            pagedSearch = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Whether the LDAP server paginates search results.";
            };

            rootPath = lib.mkOption {
              type = lib.types.str;
              description = "Root path for LDAP.";
              example = "dc=example,dc=com";
            };

            username = lib.mkOption {
              type = lib.types.str;
              description = "The user to authenticate as.";
              example = "cn=admin,dc=example,dc=com";
            };
          };
        }
      );
    };

    sync = lib.mkOption {
      description = ''
        Options to configure what gets synced.
        If you used the desktop application to test the configuration you can find the settings by searching for `sync` in `~/.config/Bitwarden\ Directory\ Connector/data.json`.
      '';
      default = { };
      type = lib.types.submodule (
        {
          config,
          options,
          ...
        }:
        {
          freeformType = lib.types.attrsOf (pkgs.formats.json { }).type;

          config.finalJSON = builtins.toJSON (
            removeAttrs config (
              lib.filter (x: x == "finalJSON" || !options.${x}.isDefined or false) (lib.attrNames options)
            )
          );

          options = {
            finalJSON = lib.mkOption {
              type = (pkgs.formats.json { }).type;
              internal = true;
              readOnly = true;
              visible = false;
            };

            removeDisabled = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Remove users from bitwarden groups if no longer in the ldap group.";
            };

            overwriteExisting = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Remove and re-add users/groups, See https://bitwarden.com/help/user-group-filters/#overwriting-syncs for more details.";
            };

            largeImport = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Enable if you are syncing more than 2000 users/groups.";
            };

            memberAttribute = lib.mkOption {
              type = lib.types.str;
              description = "Attribute that lists members in a LDAP group.";
              example = "uniqueMember";
            };

            creationDateAttribute = lib.mkOption {
              type = lib.types.str;
              description = "Attribute that lists a user's creation date.";
              example = "whenCreated";
            };

            useEmailPrefixSuffix = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "If a user has no email address, combine a username prefix with a suffix value to form an email.";
            };
            emailPrefixAttribute = lib.mkOption {
              type = lib.types.str;
              description = "The attribute that contains the users username.";
              example = "accountName";
            };
            emailSuffix = lib.mkOption {
              type = lib.types.str;
              description = "Suffix for the email, normally @example.com.";
              example = "@example.com";
            };

            users = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Sync users.";
            };
            userPath = lib.mkOption {
              type = lib.types.str;
              description = "User directory, relative to root.";
              default = "ou=users";
            };
            userObjectClass = lib.mkOption {
              type = lib.types.str;
              description = "Class that users must have.";
              default = "inetOrgPerson";
            };
            userEmailAttribute = lib.mkOption {
              type = lib.types.str;
              description = "Attribute for a users email.";
              default = "mail";
            };
            userFilter = lib.mkOption {
              type = lib.types.str;
              description = "LDAP filter for users.";
              example = "(memberOf=cn=sales,ou=groups,dc=example,dc=com)";
              default = "";
            };

            groups = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Whether to sync ldap groups into BitWarden.";
            };
            groupPath = lib.mkOption {
              type = lib.types.str;
              description = "Group directory, relative to root.";
              default = "ou=groups";
            };
            groupObjectClass = lib.mkOption {
              type = lib.types.str;
              description = "A class that groups will have.";
              default = "groupOfNames";
            };
            groupNameAttribute = lib.mkOption {
              type = lib.types.str;
              description = "Attribute for a name of group.";
              default = "cn";
            };
            groupFilter = lib.mkOption {
              type = lib.types.str;
              description = "LDAP filter for groups.";
              example = "(cn=sales)";
              default = "";
            };
          };
        }
      );
    };

    secrets = {
      ldap = lib.mkOption {
        type = lib.types.str;
        description = "Path to file that contains LDAP password for user in {option}`ldap.username";
      };

      bitwarden = {
        client_path_id = lib.mkOption {
          type = lib.types.str;
          description = "Path to file that contains Client ID.";
        };
        client_path_secret = lib.mkOption {
          type = lib.types.str;
          description = "Path to file that contains Client Secret.";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    users.groups."${cfg.user}" = { };
    users.users."${cfg.user}" = {
      isSystemUser = true;
      group = cfg.user;
    };

    systemd = {
      timers.bitwarden-directory-connector-cli = {
        description = "Sync timer for Bitwarden Directory Connector";
        wantedBy = [ "timers.target" ];
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        timerConfig = {
          OnCalendar = cfg.interval;
          Unit = "bitwarden-directory-connector-cli.service";
          Persistent = true;
        };
      };

      services.bitwarden-directory-connector-cli = {
        description = "Main process for Bitwarden Directory Connector";
        path = [ pkgs.jq ];

        environment = {
          BITWARDENCLI_CONNECTOR_APPDATA_DIR = "/tmp";
          BITWARDENCLI_CONNECTOR_PLAINTEXT_SECRETS = "true";
        };

        preStart = ''
          set -eo pipefail

          # create the config file
          ${lib.getExe cfg.package} data-file
          touch /tmp/data.json.tmp
          chmod 600 /tmp/data.json{,.tmp}

          ${lib.getExe cfg.package} config server ${cfg.domain}

          # now login to set credentials
          export BW_CLIENTID="$(< ${lib.escapeShellArg cfg.secrets.bitwarden.client_path_id})"
          export BW_CLIENTSECRET="$(< ${lib.escapeShellArg cfg.secrets.bitwarden.client_path_secret})"
          ${lib.getExe cfg.package} login

          jq '.authenticatedAccounts[0] as $account
            | .[$account].directoryConfigurations.ldap |= $ldap_data
            | .[$account].directorySettings.organizationId |= $orgID
            | .[$account].directorySettings.sync |= $sync_data' \
            --argjson ldap_data ${lib.escapeShellArg cfg.ldap.finalJSON} \
            --arg orgID "''${BW_CLIENTID//organization.}" \
            --argjson sync_data ${lib.escapeShellArg cfg.sync.finalJSON} \
            /tmp/data.json \
            > /tmp/data.json.tmp

          mv -f /tmp/data.json.tmp /tmp/data.json

          # final config
          ${lib.getExe cfg.package} config directory 0
          ${lib.getExe cfg.package} config ldap.password --secretfile ${cfg.secrets.ldap}
        '';

        serviceConfig = {
          Type = "oneshot";
          User = "${cfg.user}";
          PrivateTmp = true;
          ExecStart = "${lib.getExe cfg.package} sync";
        };
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ Silver-Golden ];
}
