{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.wallabag;

  poolName = "wallabag";

  phpfpmSocketName = "/var/run/phpfpm/${poolName}.sock";

  configFile = pkgs.writeTextFile {
    name = "wallabag-config";
    text = cfg.conf;
    destination = "/config/parameters.yml";
  };

  appDir = pkgs.buildEnv {
    name = "wallabag-app-dir";
    ignoreCollisions = true;
    checkCollisionContents = false;
    paths = [ configFile "${cfg.package}/app" ];
  };

in {
  options = {
    services.wallabag = {
      enable = mkEnableOption "wallabag";

      user = mkOption {
        type = types.str;
        default = "nginx";
        description = ''
          User account under which both the update daemon and the web-application run.
        '';
      };

      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/wallabag";
        description = ''
          Data directory.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.wallabag;
        description = ''
          Wallabag package to use.
        '';
      };

      hostName = mkOption {
        type = types.str;
        description = ''
          Name of the nginx virtualhost to use and setup.
        '';
      };

      poolConfig = mkOption {
        type = types.lines;
        default = ''
          pm = dynamic
          pm.max_children = 75
          pm.start_servers = 1
          pm.min_spare_servers = 1
          pm.max_spare_servers = 20
          pm.max_requests = 500
          catch_workers_output = 1
        '';
        description = ''
          Options for wallabag's PHP pool. See the documentation on <literal>php-fpm.conf</literal> for details on configuration directives.
        '';
      };

      conf = mkOption {
        type = types.str;
        description = ''
          Contents of the wallabag configuration file (parameters.yml)
        '';
      };
    };
  };


  config = mkIf cfg.enable {

    services.phpfpm.poolConfigs = {
      "${poolName}" = ''
        listen = "${phpfpmSocketName}";
        listen.owner = nginx
        listen.group = nginx
        listen.mode = 0600
        user = ${cfg.user}
        group = nginx
        env[WALLABAG_DATA] = ${cfg.dataDir}
        ${cfg.poolConfig}
      '';
    };
    services.phpfpm.phpOptions = ''
      max_execution_time = 120
    '';

    services.nginx.enable = mkDefault true;

    services.nginx.virtualHosts."${cfg.hostName}" = {
      root = "${cfg.package}/web";

      extraConfig = ''
        add_header X-Frame-Options SAMEORIGIN;
        add_header X-Content-Type-Options nosniff;
        add_header X-XSS-Protection "1; mode=block";
      '';

      locations."/" = {
        extraConfig = ''
          try_files $uri /app.php$is_args$args;
        '';
      };

      locations."/assets".root = "${cfg.dataDir}/web";

      locations."~ ^/app\\.php(/|$)" = {
        extraConfig = ''
          fastcgi_pass unix:${phpfpmSocketName};
          fastcgi_split_path_info ^(.+\.php)(/.*)$;
          include ${pkgs.nginx}/conf/fastcgi_params;

          fastcgi_param SCRIPT_FILENAME ${cfg.package}/web/$fastcgi_script_name;
          fastcgi_param DOCUMENT_ROOT ${cfg.package}/web;
          fastcgi_read_timeout 120;

          internal;
        '';
      };

      locations."~ /(?!app)\\.php$" = {
        extraConfig = ''
          return 404;
        '';
      };
    };

    systemd.services.wallabag-install = {
      description = "Wallabag install service";
      wantedBy = [ "multi-user.target" ];
      before = [ "phpfpm-wallabag.service" ];
      after = [ "mysql.service" "postgresql.service" ];
      path = with pkgs; [ coreutils php phpPackages.composer ];

      serviceConfig = {
        User = cfg.user;
        Type = "oneshot";
        RemainAfterExit = "yes";
        PermissionsStartOnly = true;
      };

      preStart = ''
        mkdir -p "${cfg.dataDir}"
        chown ${cfg.user}:nginx "${cfg.dataDir}"
      '';

      script = ''
        echo "Setting up wallabag files in ${cfg.dataDir} ..."
        cd "${cfg.dataDir}"

        rm -rf var/cache/*
        rm -f app
        ln -sf ${appDir} app
        ln -sf ${cfg.package}/composer.{json,lock} .

        export WALLABAG_DATA="${cfg.dataDir}"
        if [ ! -f installed ]; then
          php ${cfg.package}/bin/console --env=prod doctrine:database:create --if-not-exists --no-interaction
          php ${cfg.package}/bin/console --env=prod doctrine:migrations:migrate --no-interaction
          # Until https://github.com/wallabag/wallabag/issues/3662 is fixed
          yes no | php ${cfg.package}/bin/console --env=prod wallabag:install
          touch installed
        else
          php ${cfg.package}/bin/console --env=prod doctrine:migrations:migrate --no-interaction
        fi
        php ${cfg.package}/bin/console --env=prod cache:clear
      '';
    };
  };

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ nadrieril ];
  };
}
