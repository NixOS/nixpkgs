{ lib
, config
, pkgs
, ...
}:

with lib;

let
  cfg = config.services.netbox;
  package = pkgs.netbox.override {
    configFile = configFile;
  };

  gunicornConfigFile = pkgs.writeText "netbox-gunicorn.py" ''
    # The IP address (typically localhost) and port that the Netbox WSGI process should listen on
    bind = 'unix:/run/netbox/netbox.sock'

    # Number of gunicorn workers to spawn. This should typically be 2n+1, where
    # n is the number of CPU cores present.
    workers = 5

    # Number of threads per worker process
    threads = 3

    # Timeout (in seconds) for a request to complete
    timeout = 120

    # The maximum number of requests a worker can handle before being respawned
    max_requests = 5000
    max_requests_jitter = 500
  '';

  configFile = pkgs.writeText "netbox-configuration.py" ''
    #########################
    #                       #
    #   Required settings   #
    #                       #
    #########################

    # This is a list of valid fully-qualified domain names (FQDNs) for the NetBox server. NetBox will not permit write
    # access to the server via any other hostnames. The first FQDN in the list will be treated as the preferred name.
    #
    # Example: ALLOWED_HOSTS = ['netbox.example.com', 'netbox.internal.local']
    ALLOWED_HOSTS = ["${cfg.hostname}"]

    # PostgreSQL database configuration. See the Django documentation for a complete list of available parameters:
    #   https://docs.djangoproject.com/en/stable/ref/settings/#databases
    DATABASE = {
        'NAME': 'netbox',         # Database name
        'USER': 'netbox',         # PostgreSQL username
    }

    # Redis database settings. Redis is used for caching and for queuing background tasks such as webhook events. A separate
    # configuration exists for each. Full connection details are required in both sections, and it is strongly recommended
    # to use two separate database IDs.
    REDIS = {
        'tasks': {
            'HOST': 'localhost',
            'PORT': 6379,
            # Comment out `HOST` and `PORT` lines and uncomment the following if using Redis Sentinel
            # 'SENTINELS': [('mysentinel.redis.example.com', 6379)],
            # 'SENTINEL_SERVICE': 'netbox',
            'PASSWORD': "",
            'DATABASE': 0,
            'SSL': False,
            # Set this to True to skip TLS certificate verification
            # This can expose the connection to attacks, be careful
            # 'INSECURE_SKIP_TLS_VERIFY': False,
        },
        'caching': {
            'HOST': 'localhost',
            'PORT': 6379,
            # Comment out `HOST` and `PORT` lines and uncomment the following if using Redis Sentinel
            # 'SENTINELS': [('mysentinel.redis.example.com', 6379)],
            # 'SENTINEL_SERVICE': 'netbox',
            'PASSWORD': "",
            'DATABASE': 1,
            'SSL': False,
            # Set this to True to skip TLS certificate verification
            # This can expose the connection to attacks, be careful
            # 'INSECURE_SKIP_TLS_VERIFY': False,
        }
    }

    # This key is used for secure generation of random numbers and strings. It must never be exposed outside of this file.
    # For optimal security, SECRET_KEY should be at least 50 characters in length and contain a mix of letters, numbers, and
    # symbols. NetBox will not run without this defined. For more information, see
    # https://docs.djangoproject.com/en/stable/ref/settings/#std:setting-SECRET_KEY
    from os import environ, path
    SECRET_KEY = open(path.join(environ.get("CREDENTIALS_DIRECTORY"), "netbox.secret")).read()
  '';
in

{
  options.services.netbox = {
    enable = mkEnableOption "NetBox, an infrastructure resourece modelling application";

    hostname = mkOption {
      type = types.str;
      example = "netbox.example.com";
      description = ''
        Hostname under which to serve the NetBox instance.
      '';
    };

    secretFile = mkOption {
      type = types.path;
      default = "/var/lib/netbox/secret";
      example = /run/keys/netbox.secret;
      description = ''
        Path to the secret used for secure random number and string
        generation. It should be at least 50 characaster in length and
        consist of a mix of letters, nummbers and symbols.

        Will be auto-generated at the given path if it does not exist.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.redis.enable = true;

    services.postgresql = {
      enable = true;
      ensureDatabases = [
        "netbox"
      ];
      ensureUsers = [ {
        name = "netbox";
        ensurePermissions = {
          "DATABASE netbox" = "ALL PRIVILEGES";
        };
      } ];
    };

    services.nginx = {
      enable = true;
      recommendedProxySettings = true;
      virtualHosts."${cfg.hostname}" = {
        location."/static" = {
          alias = "${package}/opt/netbox/static";
        };
        location."/" = {
          proxyPass = "http://unix:/run/netbox/netbox.sock:/";
        };
      };
    };

    systemd.services = let
      commonUnitConfig = {
        documentation = "https://netbox.readthedocs.io/en/stable/";
        after = [
          "network-online.target"
        ];
        wants = [
          "network-online.target"
        ];

        environment = {
          PYTHONPATH = "${pkgs.netbox.pythonPath}:${pkgs.netbox}/opt/netbox";
        };
      };

      commonServiceConfig = {
        DynamicUser = true;
        User = "netbox";
        LoadCredential = "netbox.secret:${cfg.secretFile}";
        WorkingDirectory = "${pkgs.netbox}/opt/netbox";
        PrivateTmp = true;
        Restart = "on-failure";
        RestartSec = 30;
      };
    in
    {
      nginx.serviceConfig.SupplementaryGroups = [ "netbox" ];

      netbox-setup = {
        description = "NetBox setup service";
        before = [
          "netbox.service"
          "netbox-rq.service"
          "netbox-housekeeping.service"
        ];
        wantedBy = [
          "multi-user.target"
        ];
        unitConfig = {
          RequiresMountsFor = "${cfg.secretFile}";
        };
        script = ''
          if [ ! -f "${cfg.secretFile}" ]; then
            ./generate_secret_key.py > "${cfg.secretFile}"
          fi

          ./manage.py migrate
          ./manage.py trace_paths --no-input
          ./manage.py collectstatic --no-input
          ./manage.py remove_stale_contenttypes --no-input
          ./manage.py clearsessions

        '';
        serviceConfig = {
          DynamicUser = true;
          User = "netbox";
          WorkingDirectory = "${pkgs.netbox}/opt/netbox";
          UMask = "0077";
        };
      };

      netbox = {
        description = "NetBox WSGI service";
        wantedBy = [
          "multi-user.target"
        ];
        before = [
          # the dynamic group needs to be available before nginx can start
          "nginx.service"
        ];
        serviceConfig = {
          ExecStart = "${pkgs.gunicorn}/bin/gunicorn --config ${gunicornConfig} --pid /run/netbox/netbox.pid netbox.wsgi";
          PIDFile = "/run/netbox/netbox.pid";
          RuntimeDirectory = "netbox";
          RuntimeDirectoryMode = "0750";
        } // commongServiceConfig;
      } // commonUnitConfig;

      netbox-rq = {
        description = "NetBox Request Queue Worker";
        wantedBy = [
          "multi-user.target"
        ];

        serviceConfig = {
          ExecStart = "manage.py rqworker high default low";
        } // commonServieConfig;

      } // commonUnitConfig;

      netbox-housekeeping = {
        description = "NetBox Housekeeping service";
        startAt = "daily";
        serviceConfig = {
          ExecStart = "manage.py housekeeping";
        } // commonServiceConfig;
      } // commonUnitConfig;
    };
  };
}
