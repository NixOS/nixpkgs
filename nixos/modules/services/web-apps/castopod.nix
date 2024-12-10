{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.castopod;
  fpm = config.services.phpfpm.pools.castopod;

  user = "castopod";

  # https://docs.castopod.org/getting-started/install.html#requirements
  phpPackage = pkgs.php.withExtensions (
    { enabled, all }:
    with all;
    [
      intl
      curl
      mbstring
      gd
      exif
      mysqlnd
    ]
    ++ enabled
  );
in
{
  meta.doc = ./castopod.md;
  meta.maintainers = with lib.maintainers; [ alexoundos ];

  options.services = {
    castopod = {
      enable = lib.mkEnableOption "Castopod, a hosting platform for podcasters";
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.castopod;
        defaultText = lib.literalMD "pkgs.castopod";
        description = "Which Castopod package to use.";
      };
      dataDir = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/castopod";
        description = ''
          The path where castopod stores all data. This path must be in sync
          with the castopod package (where it is hardcoded during the build in
          accordance with its own `dataDir` argument).
        '';
      };
      database = {
        createLocally = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = ''
            Create the database and database user locally.
          '';
        };
        hostname = lib.mkOption {
          type = lib.types.str;
          default = "localhost";
          description = "Database hostname.";
        };
        name = lib.mkOption {
          type = lib.types.str;
          default = "castopod";
          description = "Database name.";
        };
        user = lib.mkOption {
          type = lib.types.str;
          default = user;
          description = "Database user.";
        };
        passwordFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          example = "/run/keys/castopod-dbpassword";
          description = ''
            A file containing the password corresponding to
            [](#opt-services.castopod.database.user).

            This file is loaded using systemd LoadCredentials.
          '';
        };
      };
      settings = lib.mkOption {
        type =
          with lib.types;
          attrsOf (oneOf [
            str
            int
            bool
          ]);
        default = { };
        example = {
          "email.protocol" = "smtp";
          "email.SMTPHost" = "localhost";
          "email.SMTPUser" = "myuser";
          "email.fromEmail" = "castopod@example.com";
        };
        description = ''
          Environment variables used for Castopod.
          See [](https://code.castopod.org/adaures/castopod/-/blob/main/.env.example)
          for available environment variables.
        '';
      };
      environmentFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = "/run/keys/castopod-env";
        description = ''
          Environment file to inject e.g. secrets into the configuration.
          See [](https://code.castopod.org/adaures/castopod/-/blob/main/.env.example)
          for available environment variables.

          This file is loaded using systemd LoadCredentials.
        '';
      };
      configureNginx = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Configure nginx as a reverse proxy for CastoPod.";
      };
      localDomain = lib.mkOption {
        type = lib.types.str;
        example = "castopod.example.org";
        description = "The domain serving your CastoPod instance.";
      };
      poolSettings = lib.mkOption {
        type =
          with lib.types;
          attrsOf (oneOf [
            str
            int
            bool
          ]);
        default = {
          "pm" = "dynamic";
          "pm.max_children" = "32";
          "pm.start_servers" = "2";
          "pm.min_spare_servers" = "2";
          "pm.max_spare_servers" = "4";
          "pm.max_requests" = "500";
        };
        description = ''
          Options for Castopod's PHP pool. See the documentation on `php-fpm.conf` for details on configuration directives.
        '';
      };
      maxUploadSize = lib.mkOption {
        type = lib.types.str;
        default = "512M";
        description = ''
          Maximum supported size for a file upload in. Maximum HTTP body
          size is set to this value for nginx and PHP (because castopod doesn't
          support chunked uploads yet:
          https://code.castopod.org/adaures/castopod/-/issues/330).

          Note, that practical upload size limit is smaller. For example, with
          512 MiB setting - around 500 MiB is possible.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.castopod.settings =
      let
        sslEnabled =
          with config.services.nginx.virtualHosts.${cfg.localDomain};
          addSSL || forceSSL || onlySSL || enableACME || useACMEHost != null;
        baseURL = "http${lib.optionalString sslEnabled "s"}://${cfg.localDomain}";
      in
      lib.mapAttrs (_: lib.mkDefault) {
        "app.forceGlobalSecureRequests" = sslEnabled;
        "app.baseURL" = baseURL;

        "media.baseURL" = baseURL;
        "media.root" = "media";
        "media.storage" = cfg.dataDir;

        "admin.gateway" = "admin";
        "auth.gateway" = "auth";

        "database.default.hostname" = cfg.database.hostname;
        "database.default.database" = cfg.database.name;
        "database.default.username" = cfg.database.user;
        "database.default.DBPrefix" = "cp_";

        "cache.handler" = "file";
      };

    services.phpfpm.pools.castopod = {
      inherit user;
      group = config.services.nginx.group;
      inherit phpPackage;
      phpOptions = ''
        # https://code.castopod.org/adaures/castopod/-/blob/develop/docker/production/common/uploads.template.ini
        file_uploads = On
        memory_limit = 512M
        upload_max_filesize = ${cfg.maxUploadSize}
        post_max_size = ${cfg.maxUploadSize}
        max_execution_time = 300
        max_input_time = 300
      '';
      settings = {
        "listen.owner" = config.services.nginx.user;
        "listen.group" = config.services.nginx.group;
      } // cfg.poolSettings;
    };

    systemd.services.castopod-setup = {
      after = lib.optional config.services.mysql.enable "mysql.service";
      requires = lib.optional config.services.mysql.enable "mysql.service";
      wantedBy = [ "multi-user.target" ];
      path = [
        pkgs.openssl
        phpPackage
      ];
      script =
        let
          envFile = "${cfg.dataDir}/.env";
          media = "${cfg.settings."media.storage"}/${cfg.settings."media.root"}";
        in
        ''
          mkdir -p ${cfg.dataDir}/writable/{cache,logs,session,temp,uploads}

          if [ ! -d ${lib.escapeShellArg media} ]; then
            cp --no-preserve=mode,ownership -r ${cfg.package}/share/castopod/public/media ${lib.escapeShellArg media}
          fi

          if [ ! -f ${cfg.dataDir}/salt ]; then
            openssl rand -base64 33 > ${cfg.dataDir}/salt
          fi

          cat <<'EOF' > ${envFile}
          ${lib.generators.toKeyValue { } cfg.settings}
          EOF

          echo "analytics.salt=$(cat ${cfg.dataDir}/salt)" >> ${envFile}

          ${
            if (cfg.database.passwordFile != null) then
              ''
                echo "database.default.password=$(cat "$CREDENTIALS_DIRECTORY/dbpasswordfile)" >> ${envFile}
              ''
            else
              ''
                echo "database.default.password=" >> ${envFile}
              ''
          }

          ${lib.optionalString (cfg.environmentFile != null) ''
            cat "$CREDENTIALS_DIRECTORY/envfile" >> ${envFile}
          ''}

          php ${cfg.package}/share/castopod/spark castopod:database-update
        '';
      serviceConfig = {
        StateDirectory = "castopod";
        LoadCredential =
          lib.optional (cfg.environmentFile != null) "envfile:${cfg.environmentFile}"
          ++ (lib.optional (cfg.database.passwordFile != null) "dbpasswordfile:${cfg.database.passwordFile}");
        WorkingDirectory = "${cfg.package}/share/castopod";
        Type = "oneshot";
        RemainAfterExit = true;
        User = user;
        Group = config.services.nginx.group;
        ReadWritePaths = cfg.dataDir;
      };
    };

    systemd.services.castopod-scheduled = {
      after = [ "castopod-setup.service" ];
      wantedBy = [ "multi-user.target" ];
      path = [ phpPackage ];
      script = ''
        php ${cfg.package}/share/castopod/spark tasks:run
      '';
      serviceConfig = {
        StateDirectory = "castopod";
        WorkingDirectory = "${cfg.package}/share/castopod";
        Type = "oneshot";
        User = user;
        Group = config.services.nginx.group;
        ReadWritePaths = cfg.dataDir;
        LogLevelMax = "notice"; # otherwise periodic tasks flood the journal
      };
    };

    systemd.timers.castopod-scheduled = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "*-*-* *:*:00";
        Unit = "castopod-scheduled.service";
      };
    };

    services.mysql = lib.mkIf cfg.database.createLocally {
      enable = true;
      package = lib.mkDefault pkgs.mariadb;
      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [
        {
          name = cfg.database.user;
          ensurePermissions = {
            "${cfg.database.name}.*" = "ALL PRIVILEGES";
          };
        }
      ];
    };

    services.nginx = lib.mkIf cfg.configureNginx {
      enable = true;
      virtualHosts."${cfg.localDomain}" = {
        root = lib.mkForce "${cfg.package}/share/castopod/public";

        extraConfig = ''
          try_files $uri $uri/ /index.php?$args;
          index index.php index.html;
          client_max_body_size ${cfg.maxUploadSize};
        '';

        locations."^~ /${cfg.settings."media.root"}/" = {
          root = cfg.settings."media.storage";
          extraConfig = ''
            add_header Access-Control-Allow-Origin "*";
            expires max;
            access_log off;
          '';
        };

        locations."~ \.php$" = {
          fastcgiParams = {
            SERVER_NAME = "$host";
          };
          extraConfig = ''
            fastcgi_intercept_errors on;
            fastcgi_index index.php;
            fastcgi_pass unix:${fpm.socket};
            try_files $uri =404;
            fastcgi_read_timeout 3600;
            fastcgi_send_timeout 3600;
          '';
        };
      };
    };

    users.users.${user} = lib.mapAttrs (_: lib.mkDefault) {
      description = "Castopod user";
      isSystemUser = true;
      group = config.services.nginx.group;
    };
  };
}
