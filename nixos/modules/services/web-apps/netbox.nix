{ config, lib, pkgs, buildEnv, ... }:

with lib;

let
  cfg = config.services.netbox;
  staticDir = cfg.dataDir + "/static";
  configFile = pkgs.writeTextFile {
    name = "configuration.py";
    text = ''
      STATIC_ROOT = '${staticDir}'
      ALLOWED_HOSTS = ['*']
      DATABASE = {
        'NAME': 'netbox',
        'USER': 'netbox',
        'HOST': '/run/postgresql',
      }

      # Redis database settings. Redis is used for caching and for queuing background tasks such as webhook events. A separate
      # configuration exists for each. Full connection details are required in both sections, and it is strongly recommended
      # to use two separate database IDs.
      REDIS = {
          'tasks': {
              'URL': 'unix://${config.services.redis.servers.netbox.unixSocket}?db=0',
              'SSL': False,
          },
          'caching': {
              'URL': 'unix://${config.services.redis.servers.netbox.unixSocket}?db=1',
              'SSL': False,
          }
      }

      with open("${cfg.secretKeyFile}", "r") as file:
          SECRET_KEY = file.readline()

      ${optionalString cfg.enableLdap "REMOTE_AUTH_BACKEND = 'netbox.authentication.LDAPBackend'"}

      ${cfg.extraConfig}
    '';
  };
  pkg = (pkgs.netbox.overrideAttrs (old: {
    installPhase = old.installPhase + ''
      ln -s ${configFile} $out/opt/netbox/netbox/netbox/configuration.py
    '' + optionalString cfg.enableLdap ''
      ln -s ${ldapConfigPath} $out/opt/netbox/netbox/netbox/ldap_config.py
    '';
  })).override {
    plugins = ps: ((cfg.plugins ps)
      ++ optional cfg.enableLdap [ ps.django-auth-ldap ]);
  };
  netboxManageScript = with pkgs; (writeScriptBin "netbox-manage" ''
    #!${stdenv.shell}
    export PYTHONPATH=${pkg.pythonPath}
    sudo -u netbox ${pkg}/bin/netbox "$@"
  '');

in {
  options.services.netbox = {
    enable = mkOption {
      type = lib.types.bool;
      default = false;
      description = lib.mdDoc ''
        Enable Netbox.

        This module requires a reverse proxy that serves `/static` separately.
        See this [example](https://github.com/netbox-community/netbox/blob/develop/contrib/nginx.conf/) on how to configure this.
      '';
    };

    listenAddress = mkOption {
      type = types.str;
      default = "[::1]";
      description = lib.mdDoc ''
        Address the server will listen on.
      '';
    };

    port = mkOption {
      type = types.port;
      default = 8001;
      description = lib.mdDoc ''
        Port the server will listen on.
      '';
    };

    plugins = mkOption {
      type = types.functionTo (types.listOf types.package);
      default = _: [];
      defaultText = literalExpression ''
        python3Packages: with python3Packages; [];
      '';
      description = lib.mdDoc ''
        List of plugin packages to install.
      '';
    };

    dataDir = mkOption {
      type = types.str;
      default = "/var/lib/netbox";
      description = lib.mdDoc ''
        Storage path of netbox.
      '';
    };

    secretKeyFile = mkOption {
      type = types.path;
      description = lib.mdDoc ''
        Path to a file containing the secret key.
      '';
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = lib.mdDoc ''
        Additional lines of configuration appended to the `configuration.py`.
        See the [documentation](https://netbox.readthedocs.io/en/stable/configuration/optional-settings/) for more possible options.
      '';
    };

    enableLdap = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Enable LDAP-Authentication for Netbox.

        This requires a configuration file being pass through `ldapConfigPath`.
      '';
    };

    ldapConfigPath = mkOption {
      type = types.path;
      default = "";
      description = lib.mdDoc ''
        Path to the Configuration-File for LDAP-Authentification, will be loaded as `ldap_config.py`.
        See the [documentation](https://netbox.readthedocs.io/en/stable/installation/6-ldap/#configuration) for possible options.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.redis.servers.netbox.enable = true;

    services.postgresql = {
      enable = true;
      ensureDatabases = [ "netbox" ];
      ensureUsers = [
        {
          name = "netbox";
          ensurePermissions = {
            "DATABASE netbox" = "ALL PRIVILEGES";
          };
        }
      ];
    };

    environment.systemPackages = [ netboxManageScript ];

    systemd.targets.netbox = {
      description = "Target for all NetBox services";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" "redis-netbox.service" ];
    };

    systemd.services = let
      defaultServiceConfig = {
        WorkingDirectory = "${cfg.dataDir}";
        User = "netbox";
        Group = "netbox";
        StateDirectory = "netbox";
        StateDirectoryMode = "0750";
        Restart = "on-failure";
      };
    in {
      netbox-migration = {
        description = "NetBox migrations";
        wantedBy = [ "netbox.target" ];

        environment = {
          PYTHONPATH = pkg.pythonPath;
        };

        serviceConfig = defaultServiceConfig // {
          Type = "oneshot";
          ExecStart = ''
            ${pkg}/bin/netbox migrate
          '';
        };
      };

      netbox = {
        description = "NetBox WSGI Service";
        wantedBy = [ "netbox.target" ];
        after = [ "netbox-migration.service" ];

        preStart = ''
          ${pkg}/bin/netbox trace_paths --no-input
          ${pkg}/bin/netbox collectstatic --no-input
          ${pkg}/bin/netbox remove_stale_contenttypes --no-input
        '';

        environment = {
          PYTHONPATH = pkg.pythonPath;
        };

        serviceConfig = defaultServiceConfig // {
          ExecStart = ''
            ${pkgs.python3Packages.gunicorn}/bin/gunicorn netbox.wsgi \
              --bind ${cfg.listenAddress}:${toString cfg.port} \
              --pythonpath ${pkg}/opt/netbox/netbox
          '';
        };
      };

      netbox-rq = {
        description = "NetBox Request Queue Worker";
        wantedBy = [ "netbox.target" ];
        after = [ "netbox.service" ];

        environment = {
          PYTHONPATH = pkg.pythonPath;
        };

        serviceConfig = defaultServiceConfig // {
          ExecStart = ''
            ${pkg}/bin/netbox rqworker high default low
          '';
        };
      };

      netbox-housekeeping = {
        description = "NetBox housekeeping job";
        after = [ "netbox.service" ];

        environment = {
          PYTHONPATH = pkg.pythonPath;
        };

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
      wantedBy = [ "timers.target" ];

      timerConfig = {
        OnCalendar = "daily";
      };
    };

    users.users.netbox = {
      home = "${cfg.dataDir}";
      isSystemUser = true;
      group = "netbox";
    };
    users.groups.netbox = {};
    users.groups."${config.services.redis.servers.netbox.user}".members = [ "netbox" ];
  };
}
