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
    mkOption
    mkRemovedOptionModule
    mkRenamedOptionModule
    optionalString
    types
    ;

  cfg = config.services.netbox;
  pythonVars = pkgs.formats.pythonVars { };

  settingsFile = pythonVars.generate "netbox-settings.py" cfg.settings;
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
    '';
  };

  enableLDAP = cfg.ldapConfigFile != null;

  finalPackage =
    (cfg.package.overrideAttrs (prev: {
      installPhase =
        prev.installPhase
        + ''
          ln -s ${configFile} $out/opt/netbox/netbox/netbox/configuration.py
        ''
        + lib.optionalString enableLDAP ''
          ln -s ${cfg.ldapConfigFile} $out/opt/netbox/netbox/netbox/ldap_config.py
        '';
    })).override
      {
        inherit (cfg) plugins;
      };

  netboxManageScript = (
    pkgs.writeShellScriptBin "netbox-manage" ''
      ${lib.concatMapStringsSep "\n" (envFile: ''
        . "${envFile}"
      '') cfg.environmentFiles}
      export PYTHONPATH=${finalPackage.pythonPath}
      case "$(whoami)" in
        "root")
          ${lib.getExe' pkgs.util-linux "runuser"} ${
            lib.cli.toCommandLineShellGNU { } {
              preserve-environment = true;
              user = "netbox";
            }
          } -- ${finalPackage}/bin/netbox "$@";;
        "netbox")
          exec ${finalPackage}/bin/netbox "$@";;
        *)
          echo "This must be run by either the root or the 'netbox' user." >&2
          exit 1
      esac
    ''
  );

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
    (mkRemovedOptionModule [ "services" "netbox" "listenAddress" ] ''
      Use `services.netbox.bind` with <ip>:<port> format instead.
    '')
    (mkRemovedOptionModule [ "services" "netbox" "port" ] ''
      Use `services.netbox.bind` with <ip>:<port> format instead.
    '')
    (mkRemovedOptionModule [ "services" "netbox" "unixSocket" ] ''
      Use `services.netbox.bind` with unix:<path> format instead.
    '')
    (mkRemovedOptionModule [ "services" "netbox" "keycloakClientSecret" ] ''
      Too much granularity hurts maintainability. Please configure secret key loading via `services.netbox.extraConfig` instead.
    '')
    (mkRemovedOptionModule [ "services" "netbox" "enableLdap" ] ''
      LDAP support is automatically enabled when `services.netbox.ldapConfigFile` is configured.
    '')
    (mkRenamedOptionModule
      [ "services" "netbox" "ldapConfigPath" ]
      [ "services" "netbox" "ldapConfigFile" ]
    )
    (mkRemovedOptionModule [ "services" "nginx" "gunicornArgs" ] ''
      Removed in favor of `services.netbox.gunicorn.extraArgs`, an attribute set passed to `lib.cli.toCommandLineGNU`.
    '')
  ];

  options.services.netbox = {
    enable = lib.mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable Netbox, a DCIM and IPAM source of truth.

        This module requires setting up a reverse proxy. The NetBox project has
        example configurations for [nginx] and the [Apache httpd] server.

        The important change to make is to serve `/static` from
        `''${config.services.netbox.settings.STATIC_ROOT}`.

        [nginx]: https://github.com/netbox-community/netbox/blob/main/contrib/nginx.conf
        [Apache httpd]: https://github.com/netbox-community/netbox/blob/main/contrib/apache.conf
      '';
    };

    environmentFiles = mkOption {
      type = with types; listOf path;
      default = [ ];
      description = ''
        Environment files loaded into all NetBox services and consumable in
        {option}`services.netbox.extraConfig`.
      '';
    };

    settings = lib.mkOption {
      description = ''
        The main {file}`configuration.py` to set up NetBox.

        Can be used to define flat and nested key-value pairs. Check the \
        [NetBox documentation] for possible options.

        ::: {.tip}
        Use {option}`services.netbox.extraConfig` to extend this file with Python code.
        :::

        [NetBox documentation]: https://netboxlabs.com/docs/netbox/configuration/#configuration-file
      '';
      default = { };
      type = types.submodule {
        freeformType = pythonVars.type;
        options = {
          ALLOWED_HOSTS = lib.mkOption {
            type = with types; listOf str;
            default = [ "*" ];
            description = ''
              A list of valid fully-qualified domain names (FQDNs) and/or IP
              addresses that can be used to reach the NetBox service.
            '';
          };

          STATIC_ROOT = mkOption {
            type = types.path;
            readOnly = true;
            default = "${cfg.dataDir}/static/";
            defaultText = lib.literalExpression "$${config.services.netbox.dataDir}/static/";
            description = ''
              Path to the collected static assets, served below `/static/`.
            '';
          };

          MEDIA_ROOT = mkOption {
            type = types.path;
            readOnly = true;
            default = "${cfg.dataDir}/media/";
            defaultText = lib.literalExpression "$${config.services.netbox.dataDir}/media";
            description = ''
              Path where uploaded media is stored.
            '';
          };

          REPORTS_ROOT = mkOption {
            type = types.path;
            readOnly = true;
            default = "${cfg.dataDir}/reports/";
            defaultText = lib.literalExpression "$${config.services.netbox.dataDir}/reports";
            description = ''
              Path where generated reports are stored.
            '';
          };

          SCRIPTS_ROOT = mkOption {
            type = types.path;
            readOnly = true;
            default = "${cfg.dataDir}/scripts/";
            defaultText = lib.literalExpression "$${config.services.netbox.dataDir}/scripts";
            description = ''
              Path where scripts are stored.
            '';
          };

          DATABASES = mkOption {
            type = with types; attrsOf (attrsOf str);
            default = {
              "default" = {
                NAME = "netbox";
                USER = "netbox";
                HOST = "/run/postgresql";
              };
            };
            description = ''
              Configuration for one or multiple [database] backends.

              At least one database named `default` must be defined.

              [database]: https://netbox.readthedocs.io/en/stable/configuration/required-parameters/#database
            '';
          };

          # Redis database settings. Redis is used for caching and for queuing
          # background tasks such as webhook events. A separate configuration
          # exists for each. Full connection details are required in both
          # sections, and it is strongly recommended to use two separate database
          # IDs.
          REDIS = {
            tasks = {
              URL = mkOption {
                type = types.str;
                default = "unix://${config.services.redis.servers.netbox.unixSocket}?db=0";
                defaultText = lib.literalExpression "unix://$${config.services.redis.servers.netbox.unixSocket}?db=0";
                description = ''
                  Redis database connection for queuing background tasks.

                  > It is highly recommended to keep the task and cache
                  > databases separate. Using the same database number on the
                  > same Redis instance for both may result in queued background
                  > tasks being lost during cache flushing events.

                  <https://netboxlabs.com/docs/netbox/configuration/required-parameters/#redis>
                '';
              };
            };
            caching = {
              URL = mkOption {
                type = types.str;
                default = "unix://${config.services.redis.servers.netbox.unixSocket}?db=1";
                defaultText = "unix://$${config.services.redis.servers.netbox.unixSocket}?db=0";
                description = ''
                  Redis database connection for caching.

                  > It is highly recommended to keep the task and cache
                  > databases separate. Using the same database number on the
                  > same Redis instance for both may result in queued background
                  > tasks being lost during cache flushing events.

                  <https://netboxlabs.com/docs/netbox/configuration/required-parameters/#redis>
                '';
              };
            };
          };

          REMOTE_AUTH_BACKEND = mkOption {
            type =
              with types;
              oneOf [
                str
                (listOf str)
              ];
            default =
              if enableLDAP then
                "netbox.authentication.LDAPBackend"
              else
                "netbox.authentication.RemoteUserBackend";
            defaultText = lib.literalExpression ''
              if config.services.netbox.ldapConfigFile != null then
                "netbox.authentication.LDAPBackend"
              else
                "netbox.authentication.RemoteUserBackend"
            '';
            description = ''
              One or multiple [backends] used for authenticating external users.

              When multiple backends are specified, they are tried in order.

              [backends]: https://netbox.readthedocs.io/en/stable/configuration/remote-authentication/#remote_auth_backend
            '';
          };

          LOGGING = mkOption {
            type = pythonVars.type;
            default = {
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
            description = ''
              [Logging configuration] based on the Python [`logging.config`] module.

              [`logging.config`]: https://docs.python.org/3/library/logging.config.html
              [Logging configuration]: https://netboxlabs.com/docs/netbox/configuration/system/#logging
            '';
          };
        };
      };
    };

    extraConfig = lib.mkOption {
      type = types.lines;
      default = "";
      example = ''
        from os import environ

        # https://python-social-auth.readthedocs.io/en/latest/backends/oidc.html
        # From the environment:
        SOCIAL_AUTH_OIDC_SECRET = environ.get("OIDC_CLIENT_SECRET")

        # From a file:
        with open("/run/keys/oidc-client-secret") as fd:
          SOCIAL_AUTH_OIDC_SECRET = fd.read().strip()
      '';
      description = ''
        Additional lines that are appended to {file}`configuration.py`.

        This option supports native Python code and can be used for reading
        secrets from files or the environment into configuration variables:

        Possible options can be found in the [NetBox documentation] or, for
        authentication purposes, in the [Python Social Auth] documentation.

        [NetBox documentation]: https://netboxlabs.com/docs/netbox/configuration/
        [Python Social Auth]: https://python-social-auth.readthedocs.io/en/latest/backends/index.html#
      '';
    };

    bind = lib.mkOption {
      type = types.str;
      default = "unix:/run/netbox/netbox.sock";
      example = "[::1]:8001";
      description = ''
        IP and port or Unix domain socket path to bind the HTTP socket to.

        ::: {.tip}
        This setting will be passed to gunicorn's [--bind] flag.
        :::

        [--bind]: https://gunicorn.org/reference/settings/#bind
      '';
    };

    gunicorn.extraArgs = lib.mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = ''
        Extra arguments passed the Gunicorn process that runs NetBox.

        See <https://gunicorn.org/reference/settings/> for possible flags.
      '';
      example = lib.literalExpression ''
        {
          workers = 9;
        ];
      '';
    };

    package = lib.mkOption {
      type = types.package;
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

    plugins = lib.mkOption {
      type = with types; functionTo (listOf package);
      default = _: [ ];
      defaultText = lib.literalExpression ''
        python3Packages: with python3Packages; [];
      '';
      description = ''
        List of plugin packages to install.
      '';
    };

    dataDir = lib.mkOption {
      type = types.str;
      default = "/var/lib/netbox";
      description = ''
        Storage path of netbox.
      '';
    };

    secretKeyFile = lib.mkOption {
      type =
        with types;
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
        with types;
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

    ldapConfigFile = lib.mkOption {
      type = with types; nullOr path;
      default = null;
      description = ''
        Path to the [LDAP configuration] file, also known as {file}`ldap_config.py`.

        When set, will automatically load the `django-auth-ldap` plugin and
        configure {option}`services.netbox.settings.REMOTE_AUTH_BACKEND`.

        [LDAP configuration]: https://netbox.readthedocs.io/en/stable/installation/6-ldap/#configuration
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
  };

  config = lib.mkIf cfg.enable {
    services.netbox.plugins = lib.mkIf enableLDAP (ps: [ ps.django-auth-ldap ]);

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

    systemd.slices.system-netbox = {
      description = "Netbox DCIM/IPAM";
    };

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
        defaultUnitConfig = {
          documentation = [ "https://netboxlabs.com/docs/netbox/" ];
          environment.PYTHONPATH = finalPackage.pythonPath;
        };
        defaultServiceConfig = {
          WorkingDirectory = "${cfg.dataDir}";
          User = "netbox";
          Group = "netbox";
          StateDirectory = "netbox";
          StateDirectoryMode = "0750";
          Restart = "on-failure";
          RestartSec = 30;
          Slice = "system-netbox.slice";
          EnvironmentFile = cfg.environmentFiles;
        };
      in
      {
        netbox = defaultUnitConfig // {
          description = "NetBox WSGI Service";

          wantedBy = [ "netbox.target" ];

          after = [ "network-online.target" ];
          wants = [ "network-online.target" ];

          preStart = ''
            # Generate random default secrets, if the user didn't supply any.
            ${optionalString (cfg.secretKeyFile == null) ''
              if [ ! -e "${secretKeyFile}" ]; then
                ${finalPackage}/opt/netbox/netbox/generate_secret_key.py > "${secretKeyFile}"
              fi
            ''}
            ${optionalString
              (any (path: path == "${cfg.dataDir}/pepper.1") (attrValues cfg.apiTokenPepperFiles))
              ''
                if [ ! -e "${cfg.dataDir}/pepper.1" ]; then
                  ${finalPackage}/opt/netbox/netbox/generate_secret_key.py > "${cfg.dataDir}/pepper.1"
                fi
              ''
            }

            # On the first run, or on upgrade / downgrade, run migrations and related.
            # This mostly correspond to upstream NetBox's 'upgrade.sh' script.
            versionFile="${cfg.dataDir}/version"

            if [[ -h "$versionFile" && "$(readlink -- "$versionFile")" == "${cfg.package}" ]]; then
              exit 0
            fi

            ${lib.getExe finalPackage} migrate
            ${lib.getExe finalPackage} trace_paths --no-input
            ${lib.getExe finalPackage} collectstatic --clear --no-input
            ${lib.getExe finalPackage} remove_stale_contenttypes --no-input
            ${lib.getExe finalPackage} reindex --lazy
            ${lib.getExe finalPackage} clearsessions

            ln -sfn "${cfg.package}" "$versionFile"
          '';

          serviceConfig = defaultServiceConfig // {
            ExecStart = toString (
              [
                (lib.getExe finalPackage.gunicorn)
                "netbox.wsgi"
              ]
              ++ lib.cli.toCommandLineGNU { } (
                {
                  inherit (cfg) bind;
                  pythonpath = "${finalPackage}/opt/netbox/netbox";
                }
                // cfg.gunicorn.extraArgs
              )
            );
            PrivateTmp = true;
            RuntimeDirectory = "netbox";
            TimeoutStartSec = lib.mkDefault "10min";
          };
        };

        netbox-rq = defaultUnitConfig // {
          description = "NetBox Request Queue Worker";

          wantedBy = [ "netbox.target" ];
          after = [ "netbox.service" ];

          serviceConfig = defaultServiceConfig // {
            ExecStart = toString [
              (lib.getExe finalPackage)
              "rqworker"
              "high"
              "default"
              "low"
            ];
            PrivateTmp = true;
          };
        };

        netbox-housekeeping = defaultUnitConfig // {
          description = "NetBox housekeeping job";

          wantedBy = [ "multi-user.target" ];

          after = [
            "network-online.target"
            "netbox.service"
          ];
          wants = [ "network-online.target" ];

          serviceConfig = defaultServiceConfig // {
            Type = "oneshot";
            ExecStart = toString [
              (lib.getExe finalPackage)
              "housekeeping"
            ];
          };
        };
      };

    systemd.timers.netbox-housekeeping = {
      description = "Run NetBox housekeeping job";
      documentation = [ "https://netboxlabs.com/docs/netbox/" ];

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
