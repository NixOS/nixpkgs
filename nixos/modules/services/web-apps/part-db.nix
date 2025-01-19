{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.services.part-db;
  pkg = cfg.package;

  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkOption
    types
    mkIf
    ;
in
{
  meta.maintainers = with lib.maintainers; [ felbinger ];

  options.services.part-db = {

    enable = mkEnableOption "PartDB";

    package = mkPackageOption pkgs "part-db" { };

    enableNginx = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable nginx or not. If enabled, an nginx virtual host will
        be created for access to part-db. If not enabled, then you may use
        `''${config.services.part-db.package}/public` as your document root in
        whichever webserver you wish to setup.
      '';
    };

    virtualHost = mkOption {
      type = types.str;
      default = "localhost";
      description = ''
        The hostname at which you wish part-db to be served. If you have
        enabled nginx using `services.part-db.enableNginx` then this will
        be used.
      '';
    };

    poolConfig = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.oneOf [
          lib.types.str
          lib.types.int
          lib.types.bool
        ]
      );
      default = { };
      defaultText = ''
        {
          "pm" = "dynamic";
          "pm.max_children" = 32;
          "pm.start_servers" = 2;
          "pm.min_spare_servers" = 2;
          "pm.max_spare_servers" = 4;
          "pm.max_requests" = 500;
        }
      '';
      description = ''
        Options for the Firefly III PHP pool. See the documentation on <literal>php-fpm.conf</literal>
        for details on configuration directives.
      '';
    };

    settings = lib.mkOption {
      default = { };
      description = ''
        Options for part-db configuration. Refer to
        <https://github.com/Part-DB/Part-DB-server/blob/master/.env> for
        details on supported values. All <option>_FILE values supported by
        upstream are supported here.
      '';
      example = lib.literalExpression ''
        {
          APP_ENV = "prod";
          DB_CONNECTION = "mysql";
          DB_HOST = "db";
          DB_PORT = 3306;
          DB_DATABASE = "part-db";
          DB_USERNAME = "part-db";
          DB_PASSWORD_FILE = "/var/secrets/firefly-iii-mysql-password.txt;
        }
      '';
      type = lib.types.submodule {
        freeformType = lib.types.attrsOf (
          lib.types.oneOf [
            lib.types.str
            lib.types.int
            lib.types.bool
          ]
        );
        options = {
          APP_ENV = lib.mkOption {
            type = lib.types.enum [
              "prod"
            ];
            default = "prod";
            example = "prod";
            description = ''
              The app environment. It is recommended to keep this at "prod".
              Possible values are "prod"
            '';
          };
          DB_CONNECTION = lib.mkOption {
            type = lib.types.enum [
              "sqlite"
              "mysql"
            ];
            default = "sqlite";
            example = "mysql";
            description = ''
              The type of database you wish to use. Can be one of "sqlite"
              or "mysql".
            '';
          };
          DB_PORT = lib.mkOption {
            type = lib.types.nullOr lib.types.int;
            default = if cfg.settings.DB_CONNECTION == "mysql" then 3306 else null;
            defaultText = ''
              `null` if DB_CONNECTION is "sqlite", `3306` if "mysql"
            '';
            description = ''
              The port your database is listening at. sqlite does not require
              this value to be filled.
            '';
          };
          DB_HOST = lib.mkOption {
            type = lib.types.str;
            default = "localhost";
            defaultText = ''
              "localhost" if DB_CONNECTION is "sqlite" or "mysql".
            '';
            description = ''
              The machine which hosts your database. This is left at the
              default value for "mysql" because we use the "DB_SOCKET" option
              to connect to a unix socket instead. "pgsql" requires that the
              unix socket location be specified here instead of at "DB_SOCKET".
              This option does not affect "sqlite".
            '';
          };
        };
      };
    };
  };

  config = mkIf cfg.enable {

    users.groups.part-db = { };
    users.users.part-db = {
      group = "part-db";
      isSystemUser = true;
    };

    services = {
      phpfpm.pools.part-db = {
        user = "part-db";
        group = "part-db";
        phpPackage = cfg.package.phpPackage;
        phpOptions = ''
          log_errors = on
        '';
        settings = {
          "listen.mode" = lib.mkDefault "0660";
          "listen.owner" = lib.mkDefault "part-db";
          "listen.group" = lib.mkDefault "part-db";
          "pm" = lib.mkDefault "dynamic";
          "pm.max_children" = lib.mkDefault 32;
          "pm.start_servers" = lib.mkDefault 2;
          "pm.min_spare_servers" = lib.mkDefault 2;
          "pm.max_spare_servers" = lib.mkDefault 4;
          "pm.max_requests" = lib.mkDefault 500;
        } // cfg.poolConfig;
      };

      nginx = mkIf cfg.enableNginx {
        enable = true;
        recommendedTlsSettings = lib.mkDefault true;
        recommendedOptimisation = lib.mkDefault true;
        recommendedGzipSettings = lib.mkDefault true;
        virtualHosts.${cfg.virtualHost} = {
          root = "${pkg}/public";
          locations = {
            "/" = {
              tryFiles = "$uri $uri/";
              index = "index.php";
              extraConfig = ''
                sendfile off;
              '';
            };
            "~ \.php$" = {
              extraConfig = ''
                include ${config.services.nginx.package}/conf/fastcgi_params ;
                fastcgi_param SCRIPT_FILENAME $request_filename;
                fastcgi_param modHeadersAvailable true; #Avoid sending the security headers twice
                fastcgi_pass unix:${config.services.phpfpm.pools.part-db.socket};
              '';
            };
          };
        };
      };
    };

    # TODO postgres if enabled (otherwise sqlite)
  };
}
