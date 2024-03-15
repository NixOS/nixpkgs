{ config, pkgs, lib, ... }:

with lib;

let
  userCfg = config.services.kimai;
  kimaiDrv = pkgs.kimai.override {
      consoleCmd = userCfg.consoleCmd;
      databaseUrl = userCfg.databaseUrl;
      mailerFrom = userCfg.mailerFrom;
      mailerUrl = userCfg.mailerUrl;
      appSecret = userCfg.appSecret;
      corsAllowOrigin = userCfg.corsAllowOrigin;
    };
  kimaiName = "kimai";
  kimaiDataDir = "${kimaiDrv}/public";
in
{
  options.services.kimai = {
    enable = mkEnableOption (lib.mdDoc "Kimai web client");
    consoleCmd = mkOption {
      type = types.str;
      default = "kimai-console";
      description = lib.mdDoc ''
        The name of the binary for Kimai. This would be the binary that can be called
        for the Kimai commands, usually shown as `/bin/console` in the docs, but renamed in
        this package to `kimai-console` for clarity.

        - https://www.kimai.org/documentation/commands.html

        This value becomes the name of the file, so don't use an invalid file name.
      '';
    };
    enableDatabase = mkOption {
      type = types.bool;
      default = true;
      description =  lib.mdDoc ''
        Whether to configure mysql database for you, or not.
        If you disabled this option then you will need to adjust the `databaseUrl` option
        to fit your needs.
      '';
    };
    mysqlPackage = mkPackageOptionMD pkgs "mysql80" {
      extraDescription =  lib.mdDoc ''
          Mysql package to use.
          Note: changing this may require changing the `databaseUrl` option too.
        '';
      };
    databaseUrl = mkOption {
      type = types.str;
      default = "mysql://kimai:@127.0.0.1:3306/kimai_db?charset=utf8mb4&serverVersion=8.0.34";
      description = lib.mdDoc ''
        The DATABASE_URL env var from KIMAI:
        https://github.com/kimai/kimai/blob/main/.env.dist#L22C1-L22C13
      '';
    };
    mailerFrom = mkOption {
      type = types.str;
      default = "kimai@example.com";
      description = lib.mdDoc ''
        The MAILER_FROM env var from KIMAI:
        https://github.com/kimai/kimai/blob/main/.env.dist#L28
      '';
    };
    mailerUrl = mkOption {
      type = types.str;
      default = "null://null";
      description = lib.mdDoc ''
        The MAILER_URL env var from KIMAI:
        https://github.com/kimai/kimai/blob/main/.env.dist#L30
      '';
    };
    appSecret = mkOption {
      type = types.str;
      default = "change_this_to_something_unique";
      description = lib.mdDoc ''
        The APP_SECRET env var from KIMAI:
        https://github.com/kimai/kimai/blob/main/.env.dist#L38
      '';
    };
    corsAllowOrigin = mkOption {
      type = types.str;
      default = "^https?://localhost(:[0-9]+)?$";
      description = lib.mdDoc ''
        The CORS_ALLOW_ORIGIN env var from KIMAI:
        https://github.com/kimai/kimai/blob/main/.env.dist#L47

        Unlikely, that you need to change this one
      '';
    };
    nginxProxy = {
      enable = mkEnableOption (lib.mdDoc "VirtualHost for Kimai");
      vHost = mkOption {
        type = types.str;
        description = lib.mdDoc ''
          The virtual host to be used with kimai.
          This correspondes to the value in services.nginx.virtualHosts.<vHost>
          Example: "kimai.domain.tld"
        '';
      };
      useACMEHost = mkOption {
        type = types.str;
        description = lib.mdDoc ''
          The ACME host to use for the nginx virtualHost, for example if you have
          the following in your configuration:
          ```
            security.acme.certs.<domain-with-cert> = {
              group = "nginx";
              extraDomainNames = [ kimaiSubdomain.domain.tld ]
            };
          ```
          then you would use `<domain-with-cert>` here as the value.
          Make sure to set the `onlySSL` option too.
        '';
      };
      onlySSL = mkOption {
        type = types.bool;
        description = lib.mdDoc ''
          `onlySSL` option for nginx virtualHosts.
          Make sure to set the `useACMEHost` option.
        '';
      };
    };
  };

  config = mkIf userCfg.enable {
    users.users.${kimaiName} = {
      description = "The Kimai service user";
      isSystemUser = true;
      group = kimaiName;
    };
    users.groups.${kimaiName} = {};

    services.nginx = mkIf userCfg.nginxProxy.enable {
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      virtualHosts = {
        ${userCfg.nginxProxy.vHost} = {
          onlySSL = userCfg.nginxProxy.onlySSL;
          useACMEHost = userCfg.nginxProxy.useACMEHost;
          root = "${kimaiDataDir}";
          extraConfig = "index index.php;";
          locations."~ /\.ht" = {
            extraConfig = ''
              deny all;
            '';
          };
          locations."/" = {
            tryFiles = "$uri /index.php$is_args$args";
          };
          locations."~ ^/index\.php(/|$)" = {
            extraConfig = ''
              fastcgi_pass unix:${config.services.phpfpm.pools.${kimaiName}.socket};
              fastcgi_split_path_info ^(.+\.php)(/.+)$;
              include ${pkgs.nginx}/conf/fastcgi.conf;
            '';
          };
        };
      };
    };

    # this is the service that runs our kimai server
    services.phpfpm.pools.${kimaiName} = {
      user = kimaiName;
      group = kimaiName;
      settings = {
        "listen.owner" = mkIf userCfg.nginxProxy.enable config.services.nginx.user;
        "pm" = "dynamic";
        "pm.max_children" = 32;
        "pm.max_requests" = 500;
        "pm.start_servers" = 2;
        "pm.min_spare_servers" = 2;
        "pm.max_spare_servers" = 5;
        "php_admin_value[error_log]" = "stderr";
        "php_admin_flag[log_errors]" = true;
        "catch_workers_output" = true;
      };
      phpEnv."PATH" = lib.makeBinPath [ pkgs.php ];
    };

    services.mysql = mkIf userCfg.enableDatabase {
      enable = true;
      package = userCfg.mysqlPackage;
      ensureUsers = [
        {
          name = kimaiName;
          ensurePermissions = {
            "kimai_db.*" = "ALL PRIVILEGES";
          };
        }
      ];
      ensureDatabases = [ "kimai_db" ];
      #  Requires changing the auth for the kimai to work properly,
      #  because kimai does not use socket_auth,
      #  which mysql package uses for new users.
      initialScript = builtins.toFile "mysql_initial.sql" "alter user kimai@localhost identified with mysql_native_password by ''";
    };

    systemd.services.phpfpm-kimai = {
      restartTriggers = [ kimaiDrv ];
      # these preStart scripts run as root
      preStart = ''
        mkdir -p /var/lib/kimai/var/log
        mkdir -p /var/lib/kimai/var/cache
        mkdir -p /var/lib/kimai/var/data
        mkdir -p /var/lib/kimai/var/plugins
        # `cache:clear` is necessary to clear previous references to store derivation.
        # `cache:clear` must run before the chown, otherwise
        # the cache is created only for root user inside /var/lib/kimai/var/cache
        ${kimaiDrv}/bin/${userCfg.consoleCmd} cache:clear
        chown -R kimai:kimai /var/lib/kimai
      '';
    };

    environment.systemPackages = [ kimaiDrv ];
  };
}
