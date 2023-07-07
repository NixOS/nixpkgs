{ config, lib, pkgs, modulesPath, ... }:

with lib;

let
  cfg = config.services.ixp-manager;
  package = cfg.package.override {
    dataDir = cfg.dataDir;
  };

  enqoute = x: "\"${x}\"";
  configFile = pkgs.writeText "ixp-manager-config" (lib.generators.toKeyValue
    {
      mkKeyValue = lib.generators.mkKeyValueDefault
        {
          mkValueString = enqoute;
        } "=";
    }
    settings);

  settings = {
    APP_DEBUG = "false";
    APP_TIMEZONE = "UTC";
    APP_LOG = "single";
    APP_LOG_LEVEL = "info";
    CACHE_DRIVER = "array";
    IXP_IRRDB_BGPQ3_PATH = "${pkgs.bgpq3}/bin/bgpq3";
    GRAPHER_CACHE_ENABLED = "true";
    GRAPHER_BACKENDS = if cfg.enableMRTG then "mrtg" else "dummy";
  } // cfg.settings;

  phpPackage = package.phpPackage.buildEnv {
    extensions = ({ enabled, all }: enabled ++ (with all; [
      snmp
    ] ++ optionals cfg.enableMRTG [
      rrd
    ]));
    extraConfig = ''
      log_errors = on
      post_max_size = 100M
      upload_max_filesize = 100M
      date.timezone = "${config.time.timeZone}"
    '';
  };

  artisanWrapper = pkgs.writeShellScriptBin "ixp-manager-artisan" ''
    cd ${package}
    sudo=exec
    if [[ "$USER" != ${cfg.user} ]]; then
      sudo='exec /run/wrappers/bin/sudo -u ${cfg.user}'
    fi
    $sudo ${phpPackage}/bin/php artisan $*
  '';
in
{
  options.services.ixp-manager = {
    enable = mkEnableOption "IXP-Manager";

    user = mkOption {
      type = types.str;
      default = "ixp-manager";
      description = mdDoc "Name of the IXP-Manager user.";
    };

    group = mkOption {
      type = types.str;
      default = "ixp-manager";
      description = mdDoc "Name of the IXP-Manager group.";
    };

    hostname = mkOption {
      type = types.str;
      default = config.networking.fqdnOrHostName;
      defaultText = lib.literalExpression "config.networking.fqdnOrHostName";
      description = mdDoc ''
        The hostname to serve IXP-Manager on.
      '';
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/ixp-manager";
      description = mdDoc "Path of the IXP-Manager state directory.";
    };

    environmentFile = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = mdDoc ''
        File containing env-vars to be substituted into the final config. Useful for secrets.
      '';
    };

    enableMRTG = mkOption {
      type = types.bool;
      default = false;
      description = mdDoc ''
        Enable MRTG and configure it with the IXP-Manager.
      '';
    };

    createDatabaseLocally = mkOption {
      type = types.bool;
      default = false;
      description = mdDoc ''
        Create the database and database user locally.
      '';
    };

    package = mkOption {
      default = pkgs.ixp-manager;
      defaultText = literalExpression "pkgs.ixp-manager";
      type = types.package;
      description = mdDoc "Package to use for the IXP-Manager.";
    };

    init = {
      adminUserName = mkOption {
        type = types.str;
        example = "admin";
        description = mdDoc "Name of the initial admin user.";
      };

      adminEmail = mkOption {
        type = types.str;
        example = "admin@example.com";
        description = mdDoc "Email-address of the initial admin user.";
      };

      adminPasswordFile = mkOption {
        type = types.path;
        description = mdDoc "Password to a file that contains the password of the initial user.";
      };

      adminDisplayName = mkOption {
        type = types.str;
        example = "Joe";
        description = mdDoc "Display name of the initial admin user.";
      };

      ixpName = mkOption {
        type = types.str;
        example = "SCIX";
        description = mdDoc "Name of the initial IXP.";
      };

      ixpShortName = mkOption {
        type = types.str;
        example = "SCIX";
        description = mdDoc "Short name of the initial IXP.";
      };

      ixpASN = mkOption {
        type = types.int;
        example = 65500;
        description = mdDoc "Short name of the initial IXP.";
      };

      ixpPeeringEmail = mkOption {
        type = types.str;
        example = "peering@example.com";
        description = mdDoc "Peering email-address of the initial IXP.";
      };

      ixpNocPhone = mkOption {
        type = types.str;
        description = mdDoc "NOC phone number of the initial IXP.";
      };

      ixpNocEmail = mkOption {
        type = types.str;
        example = "noc@example.com";
        description = mdDoc "NOC email-address of the initial IXP.";
      };

      ixpWebsite = mkOption {
        type = types.str;
        example = "https://example.com";
        description = mdDoc "Website URL of the initial IXP.";
      };
    };

    settings = mkOption {
      type = lib.types.submodule {
        freeformType = types.attrsOf types.str;
        options = {
          APP_URL = mkOption {
            type = types.str;
            example = "https://ixp.example.com";
            description = mdDoc "Web address where IXP Manager is accessed.";
          };

          VIEW_SKIN = mkOption {
            type = types.str;
            default = "custom";
            description = mdDoc ''
              Name of the skin used to override the style and some static pages.
              See the for more information about [skinning](https://docs.ixpmanager.org/features/skinning/) and [static content](https://docs.ixpmanager.org/features/static-content/).
              Files for the skin named `custom` can be placed in the `''${dataDir}/skin` directory.
              Custom config options for templating can be defined in `''${dataDir}/custom.php`.
            '';
          };

          DB_HOST = mkOption {
            type = types.str;
            default = "localhost";
            description = mdDoc ''
              Address of the MySQL server.

              **Note**: IXP-Manager is **not** compatible with MariaDB and needs a MySQL server.
              See the [manual](https://docs.ixpmanager.org/install/manually/#database-setup) for the setup of the database.
            '';
          };

          DB_DATABASE = mkOption {
            type = types.str;
            default = "ixpmanager";
            description = mdDoc "Name of the database.";
          };

          DB_USERNAME = mkOption {
            type = types.str;
            default = "ixpmanager";
            description = mdDoc "Name of the MySQL user.";
          };

          DB_PASSWORD = mkOption {
            type = types.str;
            description = mdDoc ''
              Password of the MySQL user. Use the `environmentFile` option to prevent the password from being written world-readable to the Nix-Store.
            '';
          };
        };
      };
      description = lib.mdDoc ''
        Attrset of the IXP-Manager environment configuration file.
        See the [example config](https://github.com/inex/IXP-Manager/blob/master/.env.example) for possible options.
      '';
      example = {
        IXP_RPKI_RTR1_HOST = "192.0.2.11";
        IXP_RPKI_RTR1_PORT = "3323";
      };
    };

    poolConfig = mkOption {
      type = with types; attrsOf (oneOf [ str int bool ]);
      default = {
        "pm" = "dynamic";
        "pm.max_children" = 32;
        "pm.start_servers" = 2;
        "pm.min_spare_servers" = 2;
        "pm.max_spare_servers" = 4;
        "pm.max_requests" = 500;
      };
      description = lib.mdDoc ''
        Options for the IXP-Manager PHP pool. See the documentation on `php-fpm.conf`
        for details on configuration directives.
      '';
    };

    nginx = mkOption {
      type = types.submodule (
        recursiveUpdate
          (import ../web-servers/nginx/vhost-options.nix { inherit config lib; }) { }
      );
      default = { };
      example = literalExpression ''
        {
          serverAliases = [
            "ixp.''${config.networking.domain}"
          ];
          # To enable encryption and let let's encrypt take care of certificate
          forceSSL = true;
          enableACME = true;
          # To set the IXP-Manager virtualHost as the default virtualHost
          default = true;
        }
      '';
      description = mdDoc ''
        With this option, you can customize the nginx virtualHost settings.
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.createDatabaseLocally -> cfg.settings.DB_HOST == "localhost";
        message = "The database host must be \"localhost\" if services.ixp-manager.createDatabaseLocally is set to true.";
      }
    ];

    services.ixp-manager.settings = mkIf cfg.enableMRTG {
      GRAPHER_BACKEND_MRTG_DBTYPE = "rrd";
      GRAPHER_BACKEND_MRTG_WORKDIR = "/var/lib/mrtg";
      GRAPHER_BACKEND_MRTG_LOGDIR = "/var/lib/mrtg";
    };

    users.users.${cfg.user} = {
      group = "${cfg.group}";
      isSystemUser = true;
    };

    users.groups.${cfg.group} = { };

    environment.systemPackages = [ artisanWrapper ];

    services.nginx = {
      enable = true;
      virtualHosts."${cfg.hostname}" = mkMerge [
        cfg.nginx
        {
          root = mkForce "${package}/public";
          locations."/" = {
            index = "index.php";
            tryFiles = "$uri $uri/ /index.php?$query_string";
          };
          locations."~ .php$".extraConfig = ''
            fastcgi_pass unix:${config.services.phpfpm.pools."ixp-manager".socket};
            fastcgi_split_path_info ^(.+\.php)(/.+)$;
          '';
        }
      ];
    };

    services.phpfpm.pools.ixp-manager = {
      user = cfg.user;
      group = cfg.group;
      phpPackage = phpPackage;
      settings = {
        "listen.mode" = "0660";
        "listen.owner" = config.services.nginx.user;
        "listen.group" = config.services.nginx.group;
      } // cfg.poolConfig;
    };

    services.mysql = mkIf cfg.createDatabaseLocally {
      enable = true;
      package = pkgs.mysql80;
      settings.mysqld.log_bin_trust_function_creators = 1;
      ensureDatabases = [ cfg.settings.DB_DATABASE ];
      ensureUsers = [
        {
          name = cfg.settings.DB_USERNAME;
          ensurePermissions = { "${cfg.settings.DB_DATABASE}.*" = "ALL PRIVILEGES"; };
        }
      ];
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir}                              0750 ${cfg.user} ${cfg.group} - -"
      "f ${cfg.dataDir}/.env                         0600 ${cfg.user} ${cfg.group} - -"
      "f ${cfg.dataDir}/.env.appkey                  0600 ${cfg.user} ${cfg.group} - -"
      "f ${cfg.dataDir}/.env.generated               0600 ${cfg.user} ${cfg.group} - -"
      "f ${cfg.dataDir}/version                      0600 ${cfg.user} ${cfg.group} - -"
      "f ${cfg.dataDir}/custom.php                   0600 ${cfg.user} ${cfg.group} - -"
      "d ${cfg.dataDir}/storage                      0700 ${cfg.user} ${cfg.group} - -"
      "d ${cfg.dataDir}/storage/app                  0700 ${cfg.user} ${cfg.group} - -"
      "d ${cfg.dataDir}/storage/debugbar             0700 ${cfg.user} ${cfg.group} - -"
      "d ${cfg.dataDir}/storage/framework            0700 ${cfg.user} ${cfg.group} - -"
      "d ${cfg.dataDir}/storage/framework/cache      0700 ${cfg.user} ${cfg.group} - -"
      "d ${cfg.dataDir}/storage/framework/sessions   0700 ${cfg.user} ${cfg.group} - -"
      "d ${cfg.dataDir}/storage/framework/views      0700 ${cfg.user} ${cfg.group} - -"
      "d ${cfg.dataDir}/storage/logs                 0700 ${cfg.user} ${cfg.group} - -"
      "d ${cfg.dataDir}/cache                        0700 ${cfg.user} ${cfg.group} - -"
      "d ${cfg.dataDir}/skin                         0700 ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.ixp-manager-scheduler = {
      description = "IXP-Manager Scheduler";
      serviceConfig = {
        Type = "oneshot";
        WorkingDirectory = package;
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${artisanWrapper}/bin/ixp-manager-artisan schedule:run";
      };
    };

    systemd.timers.ixp-manager-scheduler = {
      description = "IXP-Manager Scheduler";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "minutely";
        AccuracySec = "1second";
      };
    };

    systemd.services.ixp-manager-setup = {
      description = "Preparation tasks for IXP-Manager";
      before = [ "phpfpm-ixp-manager.service" ];
      after = [ "systemd-tmpfiles-setup.service" ]
        ++ (optional (cfg.settings.DB_HOST == "localhost") "mysql.service");
      wantedBy = [ "multi-user.target" ];
      restartTriggers = [ package configFile cfg.environmentFile ];
      path = [ pkgs.mysql80 pkgs.gnused pkgs.gnugrep pkgs.openssl ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        EnvironmentFile = mkIf (cfg.environmentFile != null) [ cfg.environmentFile ];
        User = cfg.user;
        Group = cfg.group;
        ExecStartPre = mkIf cfg.createDatabaseLocally [ "!${pkgs.writeShellScript "librenms-db-init" ''
          DB_PASSWORD=$(${pkgs.envsubst}/bin/envsubst -i ${configFile} | grep DB_PASSWORD | sed s/DB_PASSWORD=//g | sed s/\"//g)
          echo "ALTER USER ${cfg.settings.DB_USERNAME}@localhost IDENTIFIED WITH caching_sha2_password BY '$DB_PASSWORD';" | ${pkgs.mysql80}/bin/mysql -u root
        ''}"];
      };
      script = ''
        set -e

        # config setup
        ${pkgs.envsubst}/bin/envsubst -i ${configFile} -o ${cfg.dataDir}/.env.generated

        # init custom config options
        if [[ ! -s ${cfg.dataDir}/custom.php ]]; then
          cat ${package}/config/custom.php.dist > ${cfg.dataDir}/custom.php
        fi

        # init .env file if it is empty
        if [[ ! -s ${cfg.dataDir}/.env ]]; then
          echo "APP_KEY=" > ${cfg.dataDir}/.env
          ${artisanWrapper}/bin/ixp-manager-artisan key:generate --ansi
          echo "" >> ${cfg.dataDir}/.env

          # save the generated app key
          cp ${cfg.dataDir}/.env ${cfg.dataDir}/.env.appkey
        fi

        # merge the generated config with the app key
        cat ${cfg.dataDir}/.env.appkey > ${cfg.dataDir}/.env
        cat ${cfg.dataDir}/.env.generated >> ${cfg.dataDir}/.env

        OLD_VERSION=$(cat ${cfg.dataDir}/version)
        if [[ $OLD_VERSION != "${package.version}" ]]; then
          # NixOS definitions might have been replaced by envsubst --> extract them from the final config
          DB_HOST=$(cat ${cfg.dataDir}/.env | grep DB_HOST | sed s/DB_HOST=//g | sed s/\"//g)
          DB_DATABASE=$(cat ${cfg.dataDir}/.env | grep DB_DATABASE | sed s/DB_DATABASE=//g | sed s/\"//g)
          DB_USERNAME=$(cat ${cfg.dataDir}/.env | grep DB_USERNAME | sed s/DB_USERNAME=//g | sed s/\"//g)
          DB_PASSWORD=$(cat ${cfg.dataDir}/.env | grep DB_PASSWORD | sed s/DB_PASSWORD=//g | sed s/\"//g)

          # migrate db (twice according to the manual)
          ${artisanWrapper}/bin/ixp-manager-artisan migrate --force
          ${artisanWrapper}/bin/ixp-manager-artisan migrate --force

          # regenerate views
          mysql -h $DB_HOST -u $DB_USERNAME -p$DB_PASSWORD $DB_DATABASE < ${package}/tools/sql/views.sql

          # version file empty --> initial installation
          if [[ ! -s ${cfg.dataDir}/version ]]; then
            # read initial admin password
            IXPM_ADMIN_PW=$(cat ${cfg.init.adminPasswordFile})

            # password hash generation snippet from https://docs.ixpmanager.org/install/manually/
            ADMIN_PW_SALT=$(openssl rand -hex 16)
            HASH_PW=$( ${phpPackage}/bin/php -r "echo escapeshellarg( crypt( '$IXPM_ADMIN_PW', sprintf( '\$2a\$%02d\$%s', 10, substr( '$ADMIN_PW_SALT', 0, 22 ) ) ) );" )

            # snippet from https://docs.ixpmanager.org/install/manually/
            mysql -h $DB_HOST -u $DB_USERNAME "-p$DB_PASSWORD" $DB_DATABASE <<END_SQL
              INSERT INTO infrastructure ( name, shortname, isPrimary, created_at, updated_at )
                  VALUES ( 'Infrastructure #1', '#1', 1, NOW(), NOW() );
              SET @infraid = LAST_INSERT_ID();

              INSERT INTO company_registration_detail ( registeredName, created_at, updated_at ) VALUES ( '${cfg.init.ixpName}', NOW(), NOW() );
              SET @crdid = LAST_INSERT_ID();

              INSERT INTO company_billing_detail ( billingContactName, invoiceMethod, billingFrequency, created_at, updated_at )
                  VALUES ( '${cfg.init.adminDisplayName}', 'EMAIL', 'NOBILLING', NOW(), NOW() );
              SET @cbdid = LAST_INSERT_ID();

              INSERT INTO cust ( name, shortname, type, abbreviatedName, autsys, maxprefixes, peeringemail, nocphone, noc24hphone,
                      nocemail, nochours, nocwww, peeringpolicy, corpwww, datejoin, status, activepeeringmatrix, isReseller,
                      company_registered_detail_id, company_billing_details_id, created_at, updated_at )
                  VALUES ( '${cfg.init.ixpName}', '${cfg.init.ixpShortName}', 3, '${cfg.init.ixpShortName}', '${toString cfg.init.ixpASN}', 100, '${cfg.init.ixpPeeringEmail}', '${cfg.init.ixpNocPhone}',
                      '${cfg.init.ixpNocPhone}', '${cfg.init.ixpNocEmail}', '24x7', '${cfg.init.ixpWebsite}', 'mandatory', '${cfg.init.ixpWebsite}', NOW(), 1, 1, 0, @crdid, @cbdid, NOW(), NOW() );
              SET @custid = LAST_INSERT_ID();

              INSERT INTO user ( custid, name, username, password, email, privs, disabled, created_at, updated_at )
                  VALUES ( @custid, '${cfg.init.adminDisplayName}', '${cfg.init.adminUserName}', $HASH_PW, '${cfg.init.adminEmail}', 3, 0, NOW(), NOW() );
              SET @userid = LAST_INSERT_ID();

              INSERT INTO customer_to_users ( customer_id, user_id, privs, created_at, updated_at )
                  VALUES ( @custid, @userid, 3, NOW(), NOW() );

              INSERT INTO contact ( custid, name, email, created_at, updated_at )
                  VALUES ( @custid, '${cfg.init.adminDisplayName}', '${cfg.init.adminEmail}', NOW(), NOW() );
END_SQL

            ${artisanWrapper}/bin/ixp-manager-artisan db:seed --force --class=IRRDBs
            ${artisanWrapper}/bin/ixp-manager-artisan db:seed --force --class=Vendors
            ${artisanWrapper}/bin/ixp-manager-artisan db:seed --force --class=ContactGroups
          fi

          # clear cache after update
          rm -r ${cfg.dataDir}/cache/*
          echo "${package.version}" > ${cfg.dataDir}/version
        fi
      '';
    };

    systemd.services.mrtg = mkIf cfg.enableMRTG {
      description = "Multi-router Traffic Grapher";
      after = [ "ixp-manager-setup.service" ];
      environment.LANG = "C";
      path = [ pkgs.rrdtool ];
      startAt = "*:0/5";
      preStart = ''
        ${artisanWrapper}/bin/ixp-manager-artisan grapher:generate-configuration -B mrtg -O /var/lib/mrtg/ixpmanager.cfg
        sed -i '/RunAsDaemon/d' /var/lib/mrtg/ixpmanager.cfg
        echo "LibAdd: ${pkgs.rrdtool}/lib/perl5/site_perl" >> /var/lib/mrtg/ixpmanager.cfg
      '';
      serviceConfig = {
        Type = "simple";
        RuntimeDirectory = "mrtg";
        StateDirectory = "mrtg";
        ExecStart = "${pkgs.mrtg}/bin/mrtg /var/lib/mrtg/ixpmanager.cfg --lock-file=/run/mrtg/mrtg.lock --confcache-file=/var/lib/mrtg/mrtg.ok --debug=\"base\"";
        User = config.services.ixp-manager.user;
        Group = config.services.ixp-manager.group;
      };
    };
  };
}
