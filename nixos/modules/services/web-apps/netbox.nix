{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    any
    attrValues
    mkChangedOptionModule
    optionalString
    ;

  cfg = config.services.netbox;
  pythonFmt = pkgs.formats.pythonVars { };
  staticDir = cfg.dataDir + "/static";

  settingsFile = pythonFmt.generate "netbox-settings.py" cfg.settings;
  extraConfigFile = pkgs.writeTextFile {
    name = "netbox-extraConfig.py";
    text = cfg.extraConfig;
  };
  configFile = pkgs.concatText "configuration.py" [
    nixosOptionsConfig
    settingsFile
    extraConfigFile
  ];
  secretKeyFile =
    if cfg.secretKeyFile != null then cfg.secretKeyFile else "${cfg.dataDir}/secret.key";

  nixosOptionsConfig = pkgs.writeTextFile {
    name = "netbox-nixos-options.py";
    text = ''
      with open("${secretKeyFile}", "r") as file:
          SECRET_KEY = file.readline()

      API_TOKEN_PEPPERS = {
        ${lib.concatStringsSep "\n" (
          lib.mapAttrsToList (id: file: ''
            ${id}: open("${file}", "r").read().strip(),
          '') cfg.apiTokenPepperFiles
        )}
      }
    ''
    + (lib.optionalString (cfg.keycloakClientSecret != null) ''
      with open("${cfg.keycloakClientSecret}", "r") as file:
          SOCIAL_AUTH_KEYCLOAK_SECRET = file.readline()
    '');
  };

  pkg =
    (cfg.package.overrideAttrs (old: {
      installPhase =
        old.installPhase
        + ''
          ln -s ${configFile} $out/opt/netbox/netbox/netbox/configuration.py
        ''
        + lib.optionalString cfg.enableLdap ''
          ln -s ${cfg.ldapConfigPath} $out/opt/netbox/netbox/netbox/ldap_config.py
        '';
    })).override
      {
        inherit (cfg) plugins;
      };
  netboxManageScript =
    with pkgs;
    (writeScriptBin "netbox-manage" ''
      #!${stdenv.shell}
      export PYTHONPATH=${pkg.pythonPath}
      case "$(whoami)" in
      "root")
        ${util-linux}/bin/runuser -u netbox -- ${pkg}/bin/netbox "$@";;
      "netbox")
        ${pkg}/bin/netbox "$@";;
      *)
        echo "This must be run by either by root 'netbox' user"
      esac
    '');

in
{
  imports = [
    (mkChangedOptionModule
      [ "services" "netbox" "apiTokenPeppersFile" ]
      [ "services" "netbox" "apiTokenPepperFiles" ]
      (config: {
        "1" = config.services.netbox.apiTokenPeppersFile;
      })
    )
  ];

  options.services.netbox = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Enable Netbox.

        This module requires a reverse proxy that serves `/static` separately.
        See this [example](https://github.com/netbox-community/netbox/blob/develop/contrib/nginx.conf/) on how to configure this.
      '';
    };

    settings = lib.mkOption {
      description = ''
        Configuration options to set in `configuration.py`.
        See the [documentation](https://docs.netbox.dev/en/stable/configuration/) for more possible options.
      '';

      default = { };

      type = lib.types.submodule {
        freeformType = pythonFmt.type;

        options = {
          ALLOWED_HOSTS = lib.mkOption {
            type = with lib.types; listOf str;
            default = [ "*" ];
            description = ''
              A list of valid fully-qualified domain names (FQDNs) and/or IP
              addresses that can be used to reach the NetBox service.
            '';
          };
        };
      };
    };

    listenAddress = lib.mkOption {
      type = lib.types.str;
      default = "[::1]";
      description = ''
        Address the server will listen on.
        Ignored if `unixSocket` is set.
      '';
    };

    unixSocket = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        Enable Unix Socket for the server to listen on.
        `listenAddress` and `port` will be ignored.
      '';
      example = "/run/netbox/netbox.sock";
    };

    gunicornArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "extra args for gunicorn when serving netbox";
      example = [
        "--workers"
        "9"
      ];
    };

    package = lib.mkOption {
      type = lib.types.package;
      default =
        if lib.versionAtLeast config.system.stateVersion "26.05" then pkgs.netbox_4_5 else pkgs.netbox_4_4;
      defaultText = lib.literalExpression ''
        if lib.versionAtLeast config.system.stateVersion "26.05"
        then pkgs.netbox_4_5
        else pkgs.netbox_4_4;
      '';
      description = ''
        NetBox package to use.
      '';
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8001;
      description = ''
        Port the server will listen on.
        Ignored if `unixSocket` is set.
      '';
    };

    plugins = lib.mkOption {
      type = with lib.types; functionTo (listOf package);
      default = _: [ ];
      defaultText = lib.literalExpression ''
        python3Packages: with python3Packages; [];
      '';
      description = ''
        List of plugin packages to install.
      '';
    };

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/netbox";
      description = ''
        Storage path of netbox.
      '';
    };

    secretKeyFile = lib.mkOption {
      type =
        with lib.types;
        nullOr (pathWith {
          inStore = false;
        });
      default = null;
      description = ''
        Path to a file containing the [secret key].

        The secret key is used for hashing passwords and signing HTTP cookies.
        It can be rotated without data loss; however all existing user sessions
        will be invalidated.

        ::: {.note}
        If unset, a random secret will be created automatically at
        `/var/lib/netbox/secret.key`.
        :::

        [secret key]: https://netboxlabs.com/docs/netbox/configuration/required-parameters/#secret_key
      '';
    };

    apiTokenPepperFiles = lib.mkOption {
      type =
        with lib.types;
        attrsOf (pathWith {
          inStore = false;
        });
      default = {
        "1" = "${cfg.dataDir}/pepper.1";
      };
      defaultText = lib.literalExpression ''
        {
          "1" = "''${config.services.netbox.dataDir}/pepper.1";
        }
      '';
      example = {
        "1" = "/run/keys/netbox-pepper-old";
        "2" = "/run/keys/netbox-pepper-current";
      };
      description = ''
        Mapping of cryptographic pepper IDs to files containing the pepper values.

        Peppers provide an additional secret input in hashing operations. They
        are required for v2 API tokens (NetBox 4.5+).

        ::: {.note}
        By default a random pepper will be created automatically at
        `/var/lib/netbox/pepper.1` and configured with pepper ID 1.
        :::

        [cryptographic peppers]: https://netboxlabs.com/docs/netbox/configuration/required-parameters/#api_token_peppers
      '';
    };

    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = ''
        Additional lines of configuration appended to the `configuration.py`.
        See the [documentation](https://docs.netbox.dev/en/stable/configuration/) for more possible options.
      '';
    };

    enableLdap = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Enable LDAP-Authentication for Netbox.

        This requires a configuration file being pass through `ldapConfigPath`.
      '';
    };

    ldapConfigPath = lib.mkOption {
      type = lib.types.path;
      default = "";
      description = ''
        Path to the Configuration-File for LDAP-Authentication, will be loaded as `ldap_config.py`.
        See the [documentation](https://netbox.readthedocs.io/en/stable/installation/6-ldap/#configuration) for possible options.
      '';
      example = ''
        import ldap
        from django_auth_ldap.config import LDAPSearch, PosixGroupType

        AUTH_LDAP_SERVER_URI = "ldaps://ldap.example.com/"

        AUTH_LDAP_USER_SEARCH = LDAPSearch(
            "ou=accounts,ou=posix,dc=example,dc=com",
            ldap.SCOPE_SUBTREE,
            "(uid=%(user)s)",
        )

        AUTH_LDAP_GROUP_SEARCH = LDAPSearch(
            "ou=groups,ou=posix,dc=example,dc=com",
            ldap.SCOPE_SUBTREE,
            "(objectClass=posixGroup)",
        )
        AUTH_LDAP_GROUP_TYPE = PosixGroupType()

        # Mirror LDAP group assignments.
        AUTH_LDAP_MIRROR_GROUPS = True

        # For more granular permissions, we can map LDAP groups to Django groups.
        AUTH_LDAP_FIND_GROUP_PERMS = True
      '';
    };

    keycloakClientSecret = lib.mkOption {
      type = with lib.types; nullOr path;
      default = null;
      description = ''
        File that contains the keycloak client secret.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.netbox = {
      plugins = lib.mkIf cfg.enableLdap (ps: [ ps.django-auth-ldap ]);
      settings = {
        STATIC_ROOT = staticDir;
        MEDIA_ROOT = "${cfg.dataDir}/media";
        REPORTS_ROOT = "${cfg.dataDir}/reports";
        SCRIPTS_ROOT = "${cfg.dataDir}/scripts";

        GIT_PATH = "${pkgs.gitMinimal}/bin/git";

        DATABASES = {
          "default" = {
            NAME = "netbox";
            USER = "netbox";
            HOST = "/run/postgresql";
          };
        };

        # Redis database settings. Redis is used for caching and for queuing
        # background tasks such as webhook events. A separate configuration
        # exists for each. Full connection details are required in both
        # sections, and it is strongly recommended to use two separate database
        # IDs.
        REDIS = {
          tasks = {
            URL = "unix://${config.services.redis.servers.netbox.unixSocket}?db=0";
            SSL = false;
          };
          caching = {
            URL = "unix://${config.services.redis.servers.netbox.unixSocket}?db=1";
            SSL = false;
          };
        };

        REMOTE_AUTH_BACKEND = lib.mkIf cfg.enableLdap "netbox.authentication.LDAPBackend";

        LOGGING = lib.mkDefault {
          version = 1;

          formatters.precise.format = "[%(levelname)s@%(name)s] %(message)s";

          handlers.console = {
            class = "logging.StreamHandler";
            formatter = "precise";
          };

          # log to console/systemd instead of file
          root = {
            level = "INFO";
            handlers = [ "console" ];
          };
        };
      };
    };

    services.redis.servers.netbox.enable = true;

    services.postgresql = {
      enable = true;
      ensureDatabases = [ "netbox" ];
      ensureUsers = [
        {
          name = "netbox";
          ensureDBOwnership = true;
        }
      ];
    };

    environment.systemPackages = [ netboxManageScript ];

    systemd.targets.netbox = {
      description = "Target for all NetBox services";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [
        "network-online.target"
        "redis-netbox.service"
      ];
    };

    systemd.services =
      let
        defaultServiceConfig = {
          WorkingDirectory = "${cfg.dataDir}";
          User = "netbox";
          Group = "netbox";
          StateDirectory = "netbox";
          StateDirectoryMode = "0750";
          Restart = "on-failure";
          RestartSec = 30;
        };
      in
      {
        netbox = {
          description = "NetBox WSGI Service";
          documentation = [ "https://docs.netbox.dev/" ];

          wantedBy = [ "netbox.target" ];

          after = [ "network-online.target" ];
          wants = [ "network-online.target" ];

          environment.PYTHONPATH = pkg.pythonPath;

          preStart = ''
            # Generate random default secrets, if the user didn't supply any.
            ${optionalString (cfg.secretKeyFile == null) ''
              if [ ! -e "${secretKeyFile}" ]; then
                ${pkg}/opt/netbox/netbox/generate_secret_key.py > "${secretKeyFile}"
              fi
            ''}
            ${optionalString
              (any (path: path == "${cfg.dataDir}/pepper.1") (attrValues cfg.apiTokenPepperFiles))
              ''
                if [ ! -e "${cfg.dataDir}/pepper.1" ]; then
                  ${pkg}/opt/netbox/netbox/generate_secret_key.py > "${cfg.dataDir}/pepper.1"
                fi
              ''
            }

            # On the first run, or on upgrade / downgrade, run migrations and related.
            # This mostly correspond to upstream NetBox's 'upgrade.sh' script.
            versionFile="${cfg.dataDir}/version"

            if [[ -h "$versionFile" && "$(readlink -- "$versionFile")" == "${cfg.package}" ]]; then
              exit 0
            fi

            ${pkg}/bin/netbox migrate
            ${pkg}/bin/netbox trace_paths --no-input
            ${pkg}/bin/netbox collectstatic --clear --no-input
            ${pkg}/bin/netbox remove_stale_contenttypes --no-input
            ${pkg}/bin/netbox reindex --lazy
            ${pkg}/bin/netbox clearsessions
            ${lib.optionalString
              # The clearcache command was removed in 3.7.0:
              # https://github.com/netbox-community/netbox/issues/14458
              (lib.versionOlder cfg.package.version "3.7.0")
              "${pkg}/bin/netbox clearcache"
            }

            ln -sfn "${cfg.package}" "$versionFile"
          '';

          serviceConfig = defaultServiceConfig // {
            ExecStart = ''
              ${pkg.gunicorn}/bin/gunicorn netbox.wsgi \
                --bind ${
                  if (cfg.unixSocket != null) then
                    "unix:${cfg.unixSocket}"
                  else
                    "${cfg.listenAddress}:${toString cfg.port}"
                } \
                --pythonpath ${pkg}/opt/netbox/netbox \
                ${lib.concatStringsSep " " cfg.gunicornArgs}
            '';
            PrivateTmp = true;
            TimeoutStartSec = lib.mkDefault "10min";
          };
        };

        netbox-rq = {
          description = "NetBox Request Queue Worker";
          documentation = [ "https://docs.netbox.dev/" ];

          wantedBy = [ "netbox.target" ];
          after = [ "netbox.service" ];

          environment.PYTHONPATH = pkg.pythonPath;

          serviceConfig = defaultServiceConfig // {
            ExecStart = ''
              ${pkg}/bin/netbox rqworker high default low
            '';
            PrivateTmp = true;
          };
        };

        netbox-housekeeping = {
          description = "NetBox housekeeping job";
          documentation = [ "https://docs.netbox.dev/" ];

          wantedBy = [ "multi-user.target" ];

          after = [
            "network-online.target"
            "netbox.service"
          ];
          wants = [ "network-online.target" ];

          environment.PYTHONPATH = pkg.pythonPath;

          serviceConfig = defaultServiceConfig // {
            Type = "oneshot";
            ExecStart = ''
              ${pkg}/bin/netbox housekeeping
            '';
          };
        };
      };

    systemd.timers.netbox-housekeeping = {
      description = "Run NetBox housekeeping job";
      documentation = [ "https://docs.netbox.dev/" ];

      wantedBy = [ "multi-user.target" ];

      after = [
        "network-online.target"
        "netbox.service"
      ];
      wants = [ "network-online.target" ];

      timerConfig = {
        OnCalendar = "daily";
        AccuracySec = "1h";
        Persistent = true;
      };
    };

    users.users.netbox = {
      home = "${cfg.dataDir}";
      isSystemUser = true;
      group = "netbox";
    };
    users.groups.netbox = { };
    users.groups."${config.services.redis.servers.netbox.user}".members = [ "netbox" ];
  };
}
