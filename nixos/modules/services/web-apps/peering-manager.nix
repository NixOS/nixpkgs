{ config, lib, pkgs, buildEnv, ... }:

let
  cfg = config.services.peering-manager;

  pythonFmt = pkgs.formats.pythonVars {};
  settingsFile = pythonFmt.generate "peering-manager-settings.py" cfg.settings;
  extraConfigFile = pkgs.writeTextFile {
    name = "peering-manager-extraConfig.py";
    text = cfg.extraConfig;
  };
  configFile = pkgs.concatText "configuration.py" [ settingsFile extraConfigFile ];

  pkg = (pkgs.peering-manager.overrideAttrs (old: {
    postInstall = ''
      ln -s ${configFile} $out/opt/peering-manager/peering_manager/configuration.py
    '' + lib.optionalString cfg.enableLdap ''
      ln -s ${cfg.ldapConfigPath} $out/opt/peering-manager/peering_manager/ldap_config.py
    '';
  })).override {
    inherit (cfg) plugins;
  };
  peeringManagerManageScript = pkgs.writeScriptBin "peering-manager-manage" ''
    #!${pkgs.stdenv.shell}
    export PYTHONPATH=${pkg.pythonPath}
    sudo -u peering-manager ${pkg}/bin/peering-manager "$@"
  '';

in {
  options.services.peering-manager = with lib; {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = mdDoc ''
        Enable Peering Manager.

        This module requires a reverse proxy that serves `/static` separately.
        See this [example](https://github.com/peering-manager-community/peering-manager/blob/develop/contrib/nginx.conf/) on how to configure this.
      '';
    };

    listenAddress = mkOption {
      type = types.str;
      default = "[::1]";
      description = mdDoc ''
        Address the server will listen on.
      '';
    };

    port = mkOption {
      type = types.port;
      default = 8001;
      description = mdDoc ''
        Port the server will listen on.
      '';
    };

    plugins = mkOption {
      type = types.functionTo (types.listOf types.package);
      default = _: [];
      defaultText = literalExpression ''
        python3Packages: with python3Packages; [];
      '';
      description = mdDoc ''
        List of plugin packages to install.
      '';
    };

    secretKeyFile = mkOption {
      type = types.path;
      description = mdDoc ''
        Path to a file containing the secret key.
      '';
    };

    peeringdbApiKeyFile = mkOption {
      type = with types; nullOr path;
      default = null;
      description = mdDoc ''
        Path to a file containing the PeeringDB API key.
      '';
    };

    settings = lib.mkOption {
      description = lib.mdDoc ''
        Configuration options to set in `configuration.py`.
        See the [documentation](https://peering-manager.readthedocs.io/en/stable/configuration/optional-settings/) for more possible options.
      '';

      default = { };

      type = lib.types.submodule {
        freeformType = pythonFmt.type;

        options = {
          ALLOWED_HOSTS = lib.mkOption {
            type = with lib.types; listOf str;
            default = ["*"];
            description = lib.mdDoc ''
              A list of valid fully-qualified domain names (FQDNs) and/or IP
              addresses that can be used to reach the peering manager service.
            '';
          };
        };
      };
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = mdDoc ''
        Additional lines of configuration appended to the `configuration.py`.
        See the [documentation](https://peering-manager.readthedocs.io/en/stable/configuration/optional-settings/) for more possible options.
      '';
    };

    enableLdap = mkOption {
      type = types.bool;
      default = false;
      description = mdDoc ''
        Enable LDAP-Authentication for Peering Manager.

        This requires a configuration file being pass through `ldapConfigPath`.
      '';
    };

    ldapConfigPath = mkOption {
      type = types.path;
      description = mdDoc ''
        Path to the Configuration-File for LDAP-Authentication, will be loaded as `ldap_config.py`.
        See the [documentation](https://peering-manager.readthedocs.io/en/stable/setup/6-ldap/#configuration) for possible options.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.peering-manager = {
      settings = {
        DATABASE = {
          NAME = "peering-manager";
          USER = "peering-manager";
          HOST = "/run/postgresql";
        };

        # Redis database settings. Redis is used for caching and for queuing background tasks such as webhook events. A separate
        # configuration exists for each. Full connection details are required in both sections, and it is strongly recommended
        # to use two separate database IDs.
        REDIS = {
          tasks = {
            UNIX_SOCKET_PATH = config.services.redis.servers.peering-manager.unixSocket;
            DATABASE = 0;
          };
          caching = {
            UNIX_SOCKET_PATH = config.services.redis.servers.peering-manager.unixSocket;
            DATABASE = 1;
          };
        };
      };

      extraConfig = ''
        with open("${cfg.secretKeyFile}", "r") as file:
          SECRET_KEY = file.readline()
      '' + lib.optionalString (cfg.peeringdbApiKeyFile != null) ''
        with open("${cfg.peeringdbApiKeyFile}", "r") as file:
          PEERINGDB_API_KEY = file.readline()
      '';

      plugins = lib.mkIf cfg.enableLdap (ps: [ ps.django-auth-ldap ]);
    };

    system.build.peeringManagerPkg = pkg;

    services.redis.servers.peering-manager.enable = true;

    services.postgresql = {
      enable = true;
      ensureDatabases = [ "peering-manager" ];
      ensureUsers = [
        {
          name = "peering-manager";
          ensurePermissions = {
            "DATABASE \"peering-manager\"" = "ALL PRIVILEGES";
          };
        }
      ];
    };

    environment.systemPackages = [ peeringManagerManageScript ];

    systemd.targets.peering-manager = {
      description = "Target for all Peering Manager services";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" "redis-peering-manager.service" ];
    };

    systemd.services = let
      defaultServiceConfig = {
        WorkingDirectory = "/var/lib/peering-manager";
        User = "peering-manager";
        Group = "peering-manager";
        StateDirectory = "peering-manager";
        StateDirectoryMode = "0750";
        Restart = "on-failure";
      };
    in {
      peering-manager-migration = {
        description = "Peering Manager migrations";
        wantedBy = [ "peering-manager.target" ];

        environment = {
          PYTHONPATH = pkg.pythonPath;
        };

        serviceConfig = defaultServiceConfig // {
          Type = "oneshot";
          ExecStart = ''
            ${pkg}/bin/peering-manager migrate
          '';
        };
      };

      peering-manager = {
        description = "Peering Manager WSGI Service";
        wantedBy = [ "peering-manager.target" ];
        after = [ "peering-manager-migration.service" ];

        preStart = ''
          ${pkg}/bin/peering-manager remove_stale_contenttypes --no-input
        '';

        environment = {
          PYTHONPATH = pkg.pythonPath;
        };

        serviceConfig = defaultServiceConfig // {
          ExecStart = ''
            ${pkg.python.pkgs.gunicorn}/bin/gunicorn peering_manager.wsgi \
              --bind ${cfg.listenAddress}:${toString cfg.port} \
              --pythonpath ${pkg}/opt/peering-manager
          '';
        };
      };

      peering-manager-rq = {
        description = "Peering Manager Request Queue Worker";
        wantedBy = [ "peering-manager.target" ];
        after = [ "peering-manager.service" ];

        environment = {
          PYTHONPATH = pkg.pythonPath;
        };

        serviceConfig = defaultServiceConfig // {
          ExecStart = ''
            ${pkg}/bin/peering-manager rqworker high default low
          '';
        };
      };

      peering-manager-housekeeping = {
        description = "Peering Manager housekeeping job";
        after = [ "peering-manager.service" ];

        environment = {
          PYTHONPATH = pkg.pythonPath;
        };

        serviceConfig = defaultServiceConfig // {
          Type = "oneshot";
          ExecStart = ''
            ${pkg}/bin/peering-manager housekeeping
          '';
        };
      };
    };

    systemd.timers.peering-manager-housekeeping = {
      description = "Run Peering Manager housekeeping job";
      wantedBy = [ "timers.target" ];

      timerConfig = {
        OnCalendar = "daily";
      };
    };

    users.users.peering-manager = {
      home = "/var/lib/peering-manager";
      isSystemUser = true;
      group = "peering-manager";
    };
    users.groups.peering-manager = {};
    users.groups."${config.services.redis.servers.peering-manager.user}".members = [ "peering-manager" ];
  };

  meta.maintainers = with lib.maintainers; [ yuka ];
}
