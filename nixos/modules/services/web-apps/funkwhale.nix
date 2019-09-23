{config, lib, pkgs, ...}:

with lib;

let
  pythonEnv = (pkgs.python3.override {
    packageOverrides = self: super: rec {
      django = self.django_2_2;
    };
  }).withPackages (ps: [
    ps.aioredis
    ps.aiohttp
    ps.autobahn
    ps.av
    ps.boto3
    ps.celery
    ps.channels
    ps.channels-redis
    ps.django
    ps.django-allauth
    ps.django-auth-ldap
    ps.django-oauth-toolkit
    ps.django-cleanup
    ps.django-cors-headers
    ps.django-dynamic-preferences
    ps.django_environ
    ps.django-filter
    ps.django_redis
    ps.django-rest-auth
    ps.djangorestframework
    ps.djangorestframework-jwt
    ps.django-storages
    ps.django_taggit
    ps.django-versatileimagefield
    ps.gunicorn
    ps.kombu
    ps.ldap
    ps.mutagen
    ps.musicbrainzngs
    ps.pillow
    ps.pendulum
    ps.persisting-theory
    ps.psycopg2
    ps.pyacoustid
    ps.pydub
    ps.PyLD
    ps.pymemoize
    ps.pyopenssl
    ps.python_magic
    ps.redis
    ps.requests
    ps.requests-http-signature
    ps.service-identity
    ps.unidecode
    ps.unicode-slugify
    ps.uvicorn
  ]);
  cfg              = config.services.funkwhale;
  databasePassword = if (cfg.database.passwordFile != null) 
    then builtins.readFile cfg.database.passwordFile
    else cfg.database.password;
  databaseUrl = if (cfg.database.createLocally && cfg.database.socket != null) 
    then "postgresql:///${cfg.database.name}?host=${cfg.database.socket}" 
    else "postgresql://${cfg.database.user}:${databasePassword}@${cfg.database.host}:${toString cfg.database.port}/${cfg.database.name}";

  funkwhaleEnvironment = [
    "FUNKWHALE_URL=${cfg.hostname}"
    "FUNKWHALE_HOSTNAME=${cfg.hostname}"
    "FUNKWHALE_PROTOCOL=${cfg.protocol}"
    "EMAIL_CONFIG=${cfg.emailConfig}"
    "DEFAULT_FROM_EMAIL=${cfg.defaultFromEmail}"
    "REVERSE_PROXY_TYPE=nginx"
    "DATABASE_URL=${databaseUrl}"
    "CACHE_URL=redis://localhost:${toString config.services.redis.port}/0"
    "MEDIA_ROOT=${cfg.api.mediaRoot}"
    "STATIC_ROOT=${cfg.api.staticRoot}"
    "DJANGO_SECRET_KEY=${cfg.api.djangoSecretKey}"
    "RAVEN_ENABLED=${boolToString cfg.enableRaven}"
    "RAVEN_DSN=${cfg.ravenDsn}"
    "MUSIC_DIRECTORY_PATH=${cfg.musicDirectoryPath}"
    "MUSIC_DIRECTORY_SERVE_PATH=${cfg.musicDirectoryPath}"
    "FUNKWHALE_FRONTEND_PATH=${cfg.dataDir}/front/dist"
  ];
  funkwhaleEnvFileData = builtins.concatStringsSep "\n" funkwhaleEnvironment;
  funkwhaleEnvScriptData = builtins.concatStringsSep " " funkwhaleEnvironment;

  funkwhaleEnvFile = pkgs.writeText "funkwhale.env" funkwhaleEnvFileData;
  funkwhaleEnv = {
    ENV_FILE = "${funkwhaleEnvFile}";
  };
in 
  {

    options = {
      services.funkwhale = {
        enable = mkEnableOption "funkwhale";

        user = mkOption {
          type = types.str;
          default = "funkwhale";
          description = "User under which Funkwhale is ran.";
        };

        group = mkOption {
          type = types.str;
          default = "funkwhale";
          description = "Group under which Funkwhale is ran.";
        };

        database = {
          host = mkOption {
            type = types.str;
            default = "localhost";
            description = "Database host address.";
          };

          port = mkOption {
            type = types.int;
            default = 5432;
            defaultText = "5432";
            description = "Database host port.";
          };

          name = mkOption {
            type = types.str;
            default = "funkwhale";
            description = "Database name.";
          };

          user = mkOption {
            type = types.str;
            default = "funkwhale";
            description = "Database user.";
          };

          password = mkOption {
            type = types.str;
            default = "";
            description = ''
              The password corresponding to <option>database.user</option>.
              Warning: this is stored in cleartext in the Nix store!
              Use <option>database.passwordFile</option> instead.
            '';
          };

          passwordFile = mkOption {
            type = types.nullOr types.path;
            default = null;
            example = "/run/keys/funkwhale-dbpassword";
            description = ''
              A file containing the password corresponding to
              <option>database.user</option>.
            '';
          };

          socket = mkOption {
            type = types.nullOr types.path;
            default = "/run/postgresql";
            defaultText = "/run/postgresql";
            example = "/run/postgresql";
            description = "Path to the unix socket file to use for authentication for local connections.";
          };

          createLocally = mkOption {
            type = types.bool;
            default = true;
            description = "Create the database and database user locally.";
          };
        };

        dataDir = mkOption {
          type = types.str;
          default = "/srv/funkwhale";
          description = ''
            Where to keep the funkwhale data.
          '';
        };

        apiIp = mkOption {
          type = types.str;
          default = "127.0.0.1";
          description = ''
            Funkwhale API IP.
          '';
        };

        webWorkers = mkOption {
          type = types.int;
          default = 1;
          description = ''
            Funkwhale number of web workers.
          '';
        };

        apiPort = mkOption {
          type = types.port;
          default = 5000;
          description = ''
            Funkwhale API Port.
          '';
        };

        hostname = mkOption {
          type = types.str;
          description = ''
            The definitive, public domain you will use for your instance.
          '';
          example = "funkwhale.yourdomain.net";
        };

        protocol = mkOption {
          type = types.enum [ "http" "https" ];
          default = "https";
          description = ''
            Web server protocol.
          '';
        };

        emailConfig = mkOption {
          type = types.str;
          default = "consolemail://";
          description = ''
            Configure email sending. By default, it outputs emails to console instead of sending them. See https://docs.funkwhale.audio/configuration.html#email-config for details.
          '';
          example = "smtp+ssl://user@:password@youremail.host:465";
        };

        defaultFromEmail = mkOption {
          type = types.str;
          description = ''
            The email address to use to send system emails.
          '';
          example = "funkwhale@yourdomain.net";
        };

        api = {
          mediaRoot = mkOption {
            type = types.str;
            default = "/srv/funkwhale/media";
            description = ''
              Where media files (such as album covers or audio tracks) should be stored on your system ? Ensure this directory actually exists.
            '';
          };

          staticRoot = mkOption {
            type = types.str;
            default = "/srv/funkwhale/static";
            description = ''
              Where static files (such as API css or icons) should be compiled on your system ? Ensure this directory actually exists.
            '';
          };

          djangoSecretKey = mkOption {
            type = types.str;
            description = ''
              Django secret key. Generate one using `openssl rand -base64 45` for example.
            '';
            example = "6VhAWVKlqu/dJSdz6TVgEJn/cbbAidwsFvg9ddOwuPRssEs0OtzAhJxLcLVC";
          };
        };

        musicDirectoryPath = mkOption {
          type = types.str;
          default = "/srv/funkwhale/music";
          description = ''
            In-place import settings.
          '';
        };

        enableRaven = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Sentry/Raven error reporting (server side).
            Enable Raven if you want to help improve funkwhale by
            automatically sending error reports to the funkwhale developers Sentry instance.
            This will help them detect and correct bugs.
          '';
        };

        ravenDsn = mkOption {
          type = types.str;
          default = "https://44332e9fdd3d42879c7d35bf8562c6a4:0062dc16a22b41679cd5765e5342f716@sentry.eliotberriot.com/5";
          description = ''
            Sentry/Raven DSN.
            The default is the Funkwhale developers instance DSN.
          '';
        };

      };
    };

    config = mkIf cfg.enable {
      assertions = [
        { assertion = cfg.database.passwordFile != null || cfg.database.password != "" || cfg.database.socket != null;
          message = "one of services.funkwhale.database.socket, services.funkwhale.database.passwordFile, or services.funkwhale.database.password must be set";
        }
        { assertion = cfg.database.createLocally -> cfg.database.user == cfg.user;
          message = "services.funkwhale.database.user must be set to ${cfg.user} if services.funkwhale.database.createLocally is set true";
        }
        { assertion = cfg.database.createLocally -> cfg.database.socket != null;
          message = "services.funkwhale.database.socket must be set if services.funkwhale.database.createLocally is set to true";
        }
        { assertion = cfg.database.createLocally -> cfg.database.host == "localhost";
          message = "services.funkwhale.database.host must be set to localhost if services.funkwhale.database.createLocally is set to true";
        }
      ];

      users.users = optionalAttrs (cfg.user == "funkwhale") (singleton
        { name = "funkwhale";
          group = cfg.group;
        });

      users.groups = optionalAttrs (cfg.group == "funkwhale") (singleton { name = "funkwhale"; });

      services.postgresql = mkIf cfg.database.createLocally {
        enable = true;
        ensureDatabases = [ cfg.database.name ];
        ensureUsers = [
          { name = cfg.database.user;
            ensurePermissions = { "DATABASE ${cfg.database.name}" = "ALL PRIVILEGES"; };
          }
        ];
      };

      services.redis.enable =  true;

      services.nginx = {
        enable = true;
        appendHttpConfig = ''
          upstream funkwhale-api {
          server ${cfg.apiIp}:${toString cfg.apiPort};
          }
        '';
        virtualHosts = 
        let proxyConfig = ''
          # global proxy conf
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_set_header X-Forwarded-Host $host:$server_port;
          proxy_set_header X-Forwarded-Port $server_port;
          proxy_redirect off;

          # websocket support
          proxy_http_version 1.1;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection $connection_upgrade;
        '';
        withSSL = cfg.protocol == "https";
        in {
          "${cfg.hostname}" = {
            enableACME = withSSL;
            forceSSL = withSSL;
            root = "${pkgs.funkwhale}/front";
          # gzip config is nixos nginx recommendedGzipSettings with gzip_types from funkwhale doc (https://docs.funkwhale.audio/changelog.html#id5)
            extraConfig = ''
              add_header Content-Security-Policy "default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline'; img-src 'self' data:; font-src 'self' data:; object-src 'none'; media-src 'self' data:";
              add_header Referrer-Policy "strict-origin-when-cross-origin";

              gzip on;
              gzip_disable "msie6";
              gzip_proxied any;
              gzip_comp_level 5;
              gzip_types
              application/javascript
              application/vnd.geo+json
              application/vnd.ms-fontobject
              application/x-font-ttf
              application/x-web-app-manifest+json
              font/opentype
              image/bmp
              image/svg+xml
              image/x-icon
              text/cache-manifest
              text/css
              text/plain
              text/vcard
              text/vnd.rim.location.xloc
              text/vtt
              text/x-component
              text/x-cross-domain-policy;
              gzip_vary on;
            '';
            locations = {
              "/" = { 
                extraConfig = proxyConfig;
                proxyPass = "http://funkwhale-api/";
              };
              "/front/" = {
                alias = "${pkgs.funkwhale}/front/";
                extraConfig = ''
                  add_header Content-Security-Policy "default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline'; img-src 'self' data:; font-src 'self' data:; object-src 'none'; media-src 'self' data:";
                  add_header Referrer-Policy "strict-origin-when-cross-origin";
                  expires 30d;
                  add_header Pragma public;
                  add_header Cache-Control "public, must-revalidate, proxy-revalidate";
                '';
              };
              "= /front/embed.html" = {
                alias = "${pkgs.funkwhale}/front/embed.html";
                extraConfig = ''
                  add_header Content-Security-Policy "default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline'; img-src 'self' data:; font-src 'self' data:; object-src 'none'; media-src 'self' data:";
                  add_header Referrer-Policy "strict-origin-when-cross-origin";
                  add_header X-Frame-Options "ALLOW";
                  expires 30d;
                  add_header Pragma public;
                  add_header Cache-Control "public, must-revalidate, proxy-revalidate";
                '';
              };
              "/federation/" = { 
                extraConfig = proxyConfig;
                proxyPass = "http://funkwhale-api/federation/";
              };
              "/rest/" = { 
                extraConfig = proxyConfig;
                proxyPass = "http://funkwhale-api/api/subsonic/rest/";
              };
              "/.well-known/" = { 
                extraConfig = proxyConfig;
                proxyPass = "http://funkwhale-api/.well-known/";
              };
              "/media/".alias = "${cfg.api.mediaRoot}/";
              "/_protected/media/" = {
                extraConfig = ''
                  internal;
                '';
                alias = "${cfg.api.mediaRoot}/";
              };
              "/_protected/music/" = {
                extraConfig = ''
                  internal;
                '';
                alias = "${cfg.musicDirectoryPath}/";
              };
              "/staticfiles/".alias = "${cfg.api.staticRoot}/";
            };
          };
        };
      };

      systemd.tmpfiles.rules = [
        "d ${cfg.dataDir} 0755 ${cfg.user} ${cfg.group} - -"
        "d ${cfg.api.mediaRoot} 0755 ${cfg.user} ${cfg.group} - -"
        "d ${cfg.api.staticRoot} 0755 ${cfg.user} ${cfg.group} - -"
        "d ${cfg.musicDirectoryPath} 0755 ${cfg.user} ${cfg.group} - -"
      ];

      systemd.targets.funkwhale = {
        description = "Funkwhale";
        wants = ["funkwhale-server.service" "funkwhale-worker.service" "funkwhale-beat.service"];
      }; 
      systemd.services = 
      let serviceConfig = {
        User = "${cfg.user}";
        WorkingDirectory = "${pkgs.funkwhale}";
        EnvironmentFile =  "${funkwhaleEnvFile}";
      };
      in {
        funkwhale-psql-init = mkIf cfg.database.createLocally {
          description = "Funkwhale database preparation";
          after = [ "redis.service" "postgresql.service" ];
          wantedBy = [ "funkwhale-init.service" ];
          before   = [ "funkwhale-init.service" ];
          serviceConfig = {
            User = "postgres";
            ExecStart = '' ${config.services.postgresql.package}/bin/psql -d ${cfg.database.name}  -c 'CREATE EXTENSION IF NOT EXISTS "unaccent";CREATE EXTENSION IF NOT EXISTS "citext";' '';
          };
        };
        funkwhale-init = {
          description = "Funkwhale initialization";
          wantedBy = [ "funkwhale-server.service" "funkwhale-worker.service" "funkwhale-beat.service" ];
          before   = [ "funkwhale-server.service" "funkwhale-worker.service" "funkwhale-beat.service" ];
          environment = funkwhaleEnv;
          serviceConfig = {
            User = "${cfg.user}";
            Group = "${cfg.group}";
          };
          script = ''
            ${pythonEnv}/bin/python ${pkgs.funkwhale}/manage.py migrate
            ${pythonEnv}/bin/python ${pkgs.funkwhale}/manage.py collectstatic --no-input
            if ! test -e ${cfg.dataDir}/createSuperUser.sh; then
              echo "#!/bin/sh

              ${funkwhaleEnvScriptData} ${pythonEnv}/bin/python ${pkgs.funkwhale}/manage.py createsuperuser" > ${cfg.dataDir}/createSuperUser.sh
              chmod u+x ${cfg.dataDir}/createSuperUser.sh
              chown -R ${cfg.user}.${cfg.group} ${cfg.dataDir}
            fi
            if ! test -e ${cfg.dataDir}/config; then
              mkdir -p ${cfg.dataDir}/config
              ln -s ${funkwhaleEnvFile} ${cfg.dataDir}/config/.env
              ln -s ${funkwhaleEnvFile} ${cfg.dataDir}/.env
            fi
          '';
        };

        funkwhale-server = {
          description = "Funkwhale application server";
          partOf = [ "funkwhale.target" ];

          serviceConfig = serviceConfig // { 
            ExecStart = "${pythonEnv}/bin/gunicorn config.asgi:application -w ${toString cfg.webWorkers} -k uvicorn.workers.UvicornWorker -b ${cfg.apiIp}:${toString cfg.apiPort}";
          };
          environment = funkwhaleEnv;

          wantedBy = [ "multi-user.target" ];
        };

        funkwhale-worker = {
          description = "Funkwhale celery worker";
          partOf = [ "funkwhale.target" ];

          serviceConfig = serviceConfig // { 
            RuntimeDirectory = "funkwhaleworker"; 
            ExecStart = "${pythonEnv}/bin/celery -A funkwhale_api.taskapp worker -l INFO";
          };
          environment = funkwhaleEnv;

          wantedBy = [ "multi-user.target" ];
        };

        funkwhale-beat = {
          description = "Funkwhale celery beat process";
          partOf = [ "funkwhale.target" ];

          serviceConfig = serviceConfig // { 
            RuntimeDirectory = "funkwhalebeat"; 
            ExecStart = '' ${pythonEnv}/bin/celery -A funkwhale_api.taskapp beat -l INFO --schedule="/run/funkwhalebeat/celerybeat-schedule.db"  --pidfile="/run/funkwhalebeat/celerybeat.pid" '';
          };
          environment = funkwhaleEnv;

          wantedBy = [ "multi-user.target" ];
        };

      };

    };

    meta = {
      maintainers = with lib.maintainers; [ mmai ];
    };
  }
