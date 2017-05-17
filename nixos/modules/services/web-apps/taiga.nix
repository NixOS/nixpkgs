# TODO ADD enableCircus-option (process- and socket-monitoring using mozilla circus)
# TODO ADD expose email-configuration
# TODO ADD expose integrations (gitlab wooh)
# TODO FIX local postgres
# TODO FIX sample-data
#
# TODO IDEA nixify python-dict-as-config-files (like builtins.fromJSON/toJSON)
# TODO IDEA support alternative WSGI packages (eg uWSGI)
# TODO IDEA support alternative webserver

{ config, pkgs, lib, ... }:

with lib;

let

  cfg = config.services.taiga;

  taiga-back = pkgs.pythonPackages.taiga-back;
  taiga-front = pkgs.taiga-front-dist;
  taiga-events = pkgs.nodePackages.TaigaIO-Events-undefined;

  useLocalDatabase = (cfg.database.host == "127.0.0.1"); 

  amqpUrl = "amqp://${cfg.amqp.user}:${cfg.amqp.password}@localhost:5672/${cfg.amqp.vhost}";

  httpScheme = ''${if cfg.urls.enableSSL then "https" else "http"}'';
  wsScheme = ''${if cfg.urls.enableSSL then "wss" else "ws"}'';

  taigaBackConfigFile = pkgs.writeText "taiga-back-config-raw.py" ''
    from .common import *

    DATABASES = {
      'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': '${cfg.database.name}',
        'USER': '${cfg.database.user}',
        ${optionalString (!useLocalDatabase) "'HOST': '${cfg.database.host}',"}
        ${optionalString (!useLocalDatabase) "'PORT': '${toString cfg.database.port}',"}
        ${optionalString (!useLocalDatabase) "'PASSWORD': '${cfg.database.password}',"}
      }
    }
    MEDIA_ROOT = "${cfg.statePath}/media"
    STATIC_ROOT = "${cfg.statePath}/static"

    MEDIA_URL = "${httpScheme}://${cfg.urls.media}/"
    STATIC_URL = "${httpScheme}://${cfg.urls.static}/"

    SITES["front"]["scheme"] = "${httpScheme}"
    SITES["front"]["domain"] = "${cfg.urls.front}"

    PUBLIC_REGISTER_ENABLED = ${if cfg.enablePublicRegistration then "True" else "False"}

    SECRET_KEY = "${cfg.djangoSecret}"
    DEBUG = ${if cfg.enableDebug then "True" else "False"}

    ${optionalString cfg.enableWebsockets ''
      EVENTS_PUSH_BACKEND = "taiga.events.backends.rabbitmq.EventsPushBackend"
      EVENTS_PUSH_BACKEND_OPTIONS = {"url": "${amqpUrl}"}
    ''}
  '';

  taigaBackConfigPkg = pkgs.stdenv.mkDerivation rec {
    name = "taiga-back-config-package";
    buildCommand = ''
      mkdir -p $out/settings
      ln -s ${taiga-back}/lib/python3.5/site-packages/settings/*.py $out/settings/
      ln -s ${taigaBackConfigFile} $out/settings/local.py
    '';
  };

  defaultFrontConfig = builtins.fromJSON (readFile "${taiga-front}/dist/conf.example.json");

  taigaFrontConfig = foldl recursiveUpdate defaultFrontConfig [
    { api =                   "${httpScheme}://${cfg.urls.api}";
      eventsUrl =             "${wsScheme}://${cfg.urls.events}";
      debug =                 cfg.enableDebug;
      publicRegisterEnabled = cfg.enablePublicRegistration;
      feedbackEnabled =       cfg.enableFeedback;
    }
    cfg.extraFrontConfig
  ];

  taigaFrontConfigFile = pkgs.writeText "taiga-front-config-raw.json" (builtins.toJSON taigaFrontConfig);

  defaultEventsConfig = builtins.fromJSON (readFile "${taiga-events}/lib/node_modules/TaigaIO-Events/config.example.json");

  taigaEventsConfig = foldl recursiveUpdate defaultEventsConfig [ {
    url = amqpUrl;
    secret = cfg.djangoSecret;
    webSocketServer = { port = 8888; };
  } ];

  taigaEventsConfigFile = pkgs.writeText "taiga-events-config-raw.json" (builtins.toJSON taigaEventsConfig);

in

{
  options = {
    services.taiga = {
      enable = mkEnableOption "Taiga project management platform";

      enableDebug = mkOption {
        type = types.bool;
        default = false;
        description = "Enable debugging.";
      };

      enablePublicRegistration = mkOption {
        type = types.bool;
        default = false;
        description = "Enable public registration.";
      };

      enableFeedback = mkOption {
        type = types.bool;
        default = false;
        description = ""; # TODO check what this does
      };

      enableDjangoAdmin = mkOption {
        type = types.bool;
        default = false;
        description = "Enable django admin interface.";
      };

      enableWebsockets = mkOption {
        type = types.bool;
        default = true;
        description = "Enable Websockets-Support.";
      };

      enableWsgi = mkOption {
        type = types.bool;
        default = true;
        description = "Enable WSGI-Support.";
      };

      wsgiWorkers = mkOption {
        type = types.int;
        default = 3;
        description = "Number of WSGI workers.";
      };

      statePath = mkOption {
        type = types.str;
        default = "/var/lib/taiga";
        description = "Taiga working directory.";
      };

      user = mkOption {
        type = types.str;
        default = "taigauser";
        description = "User which runs the Taiga service.";
      };

      group = mkOption {
        type = types.str;
        default = "taigagroup";
        description = "Group which runs the Taiga service.";
      };

      database = {
        host = mkOption {
          type = types.str;
          default = "127.0.0.1";
          description = "Taiga database hostname.";
        };
        port = mkOption {
          type = types.int;
          default = 5432;
          description = "Taiga database port.";
        };
        name = mkOption {
          type = types.str;
          default = "taigadb";
          description = "Taiga database name.";
        };
        user = mkOption {
          type = types.str;
          default = "taigapguser";
          description = "Taiga database username.";
        };
        password = mkOption {
          type = types.str;
        # FIXME this shouldn't have a default-value
          default = "taigapgsecret";
          description = "Taiga database user password.";
        };
      };

      # FIXME this whole url-set doesn't feel sane
      urls = {
        enableSSL = mkOption {
          type = types.bool;
          default = true;
          description = "";
        };
        front = mkOption {
          type = types.string;
          default = "example.com";
          description = "Frontend URL";
        };
        api = mkOption {
          type = types.string;
          default = "example.com/api/v1/";
          description = "API URL";
        };
        events = mkOption {
          type = types.str;
          default = "example.com/events";
          description = "Events URL";
        };
        static = mkOption {
          type = types.str;
          default = "example.com/static";
          description = "Static-Content URL";
        };
        media = mkOption {
          type = types.str;
          default = "example.com/media";
          description = "Media URL";
        };
      };

      extraFrontConfig = mkOption {
        type = types.attrs;
        default = { };
        description = ''
          Addtional configuration options as Nix attribute set in conf.json schema.
        '';
      };

      djangoSecret = mkOption {
        type = types.str;
        # FIXME this shouldn't have a default-value
        default = "theveryultratopsecretkey";
        description = "Secret key for Django.";
      };

      amqp = {
        user = mkOption {
          type = types.str;
          default = "taiga";
          description = "AMQP user (used for Websockets-support).";
        };
        password = mkOption {
          type = types.str;
          # FIXME this shouldn't have a default-value
          default = "PASSWORD";
          description = "AMQP password.";
        };
        vhost = mkOption {
          type = types.str;
          default = "taiga";
          description = "AMQP vhost.";
        };
      };
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      users.extraUsers.${cfg.user} =  {
        name = cfg.user;
        group = cfg.group;
        uid = config.ids.uids.taiga;
        home = cfg.statePath;
      };

      users.extraGroups.${cfg.group} = {
        name = cfg.group;
        gid = config.ids.gids.taiga;
      };

      services.postgresql = mkIf useLocalDatabase {
      	enable = true;

        authentication = ''
          local ${cfg.database.name} ${cfg.database.user} trust
#          local all all trust
        '';
      };

      system.activationScripts.taiga = ''
        mkdir -p ${cfg.statePath}
      '';

      systemd.services.taiga-back = {
        description = "Taiga Platform Server (Backend)";

        wantedBy = [ "multi-user.target" ];
        requires = [ "network-online.target" ] ++ optional useLocalDatabase "postgresql.service";
        after = [ "network-online.target" ] ++ optional useLocalDatabase "postgresql.service";
        before = [ "nginx.service" ];

        environment = let
            python = pkgs.python3;
            penv = python.buildEnv.override {
              extraLibs = [
                taiga-back
                pkgs.python3Packages.gunicorn
                pkgs.python3Packages.gevent
              ];
            };
          in {
            PYTHONPATH = "${taigaBackConfigPkg}:${penv}/${python.sitePackages}/";
          };

        serviceConfig = {
          User = cfg.user;
          Group = cfg.group;
          WorkingDirectory = cfg.statePath;
          ExecStart = if cfg.enableWsgi then ''
            ${pkgs.python3Packages.gunicorn}/bin/gunicorn taiga.wsgi \
              -u ${cfg.user} \
              -g ${cfg.group} \
              -k gevent \
              --name gunicorn-taiga \
              --log-level ${if cfg.enableDebug then "debug" else "info"} \
              --workers ${toString cfg.wsgiWorkers} \
              --pid ${cfg.statePath}/gunicorn-taiga.pid \
              --bind 127.0.0.1:8000
          '' else ''
              ${taiga-back}/bin/manage.py runserver --nostatic "127.0.0.1:8000"
          '';
          Restart = "always";
          PermissionsStartOnly = true;
          PrivateDevices = true;
          PrivateTmp = mkIf (!useLocalDatabase) true;
          JoinsNamespaceOf = mkIf useLocalDatabase "postgresql.service";
          TimeoutSec = 300; # initial ./manage.py migrate can take a while
        };

        preStart = ''
          set -x
          # BACK
          if ! [ -e ${cfg.statePath}/.back-initialized ]; then
            cd ${taiga-back}/lib/python3.5/site-packages/
            ${taiga-back}/bin/manage.py compilemessages
            ${taiga-back}/bin/manage.py collectstatic --noinput
            touch ${cfg.statePath}/.back-initialized
          fi
          ${optionalString useLocalDatabase ''
          # LOCAL DATABASE
            if ! [ -e ${cfg.statePath}/.db-created ]; then
              ${config.services.postgresql.package}/bin/createuser ${cfg.database.user}
              ${config.services.postgresql.package}/bin/createdb ${cfg.database.name} -O ${cfg.database.user}
              touch ${cfg.statePath}/.db-created
            fi
          ''}
          # SEED DATABASE
          if ! [ -e ${cfg.statePath}/.db-seeded ]; then
            cd ${taiga-back}/lib/python3.5/site-packages/
            ${taiga-back}/bin/manage.py migrate --noinput
            ${taiga-back}/bin/manage.py loaddata initial_user
            ${taiga-back}/bin/manage.py loaddata initial_project_templates
#            if ! [ -e ${cfg.statePath}/.db-sampledata ]; then
#              ${taiga-back}/bin/manage.py sample_data
#              touch ${cfg.statePath}/.db-sampledata
#            fi
            touch ${cfg.statePath}/.db-seeded
          fi
          chown ${cfg.user}:${cfg.group} -R ${cfg.statePath}
          chmod u+rw,g+r,o-rwx -R ${cfg.statePath} 
        '';
      };

      services.rabbitmq.enable = mkIf cfg.enableWebsockets true;

      systemd.services.taiga-events = mkIf cfg.enableWebsockets {
        description = "Taiga Platform Server (Events)";

        wantedBy = [ "multi-user.target" ];
        requires = [ "network-online.target" "rabbitmq.service" "taiga-back.service" ];
        after = [ "network-online.target" "rabbitmq.service" "taiga-back.service" ];

        environment.NODE_PATH = "${taiga-events}/lib/node_modules/TaigaIO-Events/";
        serviceConfig = {
          User = cfg.user;
          Group = cfg.group;
          WorkingDirectory = cfg.statePath;
          ExecStart = ''
            ${pkgs.nodePackages.coffee-script}/lib/node_modules/coffee-script/bin/coffee \
            ${taiga-events}/lib/node_modules/TaigaIO-Events/index.coffee \
            ${taigaEventsConfigFile}
          '';

          Restart = "always";
          PermissionsStartOnly = true;
          PrivateDevices = true;
          PrivateTmp = true;
          TimeoutSec = 180;
        };

        preStart = ''
          set -x
          if ! [ -e ${cfg.statePath}/.rabbitmq-init ]; then
            ${pkgs.sudo}/bin/sudo -u rabbitmq ${pkgs.rabbitmq_server}/bin/rabbitmqctl \
              add_user ${cfg.amqp.user} ${cfg.amqp.password}
            ${pkgs.sudo}/bin/sudo -u rabbitmq ${pkgs.rabbitmq_server}/bin/rabbitmqctl \
              add_vhost ${cfg.amqp.vhost}
            ${pkgs.sudo}/bin/sudo -u rabbitmq ${pkgs.rabbitmq_server}/bin/rabbitmqctl \
              set_permissions -p ${cfg.amqp.vhost} ${cfg.amqp.user} ".*" ".*" ".*"
            touch ${cfg.statePath}/.rabbitmq-init
          fi
        '';
      };

      services.nginx = {
        enable = true;
        user = cfg.user;
        group = cfg.group;
      
        clientMaxBodySize = "50m";

        recommendedProxySettings = true;

        virtualHosts."_" = {
          extraConfig = ''
            large_client_header_buffers 4 32k;
            charset utf-8;
          '';
          locations = {
            "/" = {
              root = "${taiga-front}/dist";
              tryFiles = "$uri $uri/ /index.html";
            };
            "/conf.json" = {
              alias = "${taigaFrontConfigFile}";
            };
            "/static" = {
              alias = "${cfg.statePath}/static";
            };
            "/media" = {
              alias = "${cfg.statePath}/media";
            };
            "/api" = {
              proxyPass = "http://127.0.0.1:8000/api";
            };
            "/admin" = mkIf cfg.enableDjangoAdmin {
              proxyPass = "http://127.0.0.1:8000$request_uri";
            };
            "/events" = mkIf cfg.enableWebsockets {
              proxyPass = "http://127.0.0.1:8888/events";
              extraConfig = ''
                proxy_http_version 1.1;
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection "upgrade";
              '';
            };
          };
        };
      };
    })

  ];
}


