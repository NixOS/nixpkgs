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

    phpPackage = mkPackageOption pkgs "php" { } // {
      apply =
        pkg:
        pkg.buildEnv {
          extraConfig = ''
            memory_limit = 256M;
          '';
        };
    };

    enableNginx = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to enable nginx or not. If enabled, an nginx virtual host will
        be created for access to part-db. If not enabled, then you may use
        `''${config.services.part-db.package}/public` as your document root in
        whichever webserver you wish to setup.
      '';
    };

    enablePostgresql = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to configure the postgresql database for part-db. If enabled,
        a database and user will be created for part-db.
      '';
    };

    virtualHost = mkOption {
      type = types.str;
      default = "localhost";
      description = ''
        The virtualHost at which you wish part-db to be served.
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
        Options for the PartDB PHP pool. See the documentation on <literal>php-fpm.conf</literal>
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
          DATABASE_URL = "postgresql://db_user@localhost/db_name?serverVersion=16.6&charset=utf8&host=/var/run/postgresql";
        }
      '';
      type = lib.types.submodule {
        freeformType = lib.types.attrsOf (
          with lib.types;
          oneOf [
            str
            int
            bool
          ]
        );
        options = {
          DATABASE_URL = lib.mkOption {
            type = lib.types.str;
            default = "postgresql://part-db@localhost/part-db?serverVersion=${config.services.postgresql.package.version}&host=/run/postgresql";
            defaultText = "postgresql://part-db@localhost/part-db?serverVersion=\${config.services.postgresql.package.version}&host=/run/postgresql";
            description = ''
              The postgresql database server to connect to.
              Defauls to local postgresql unix socket
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
        phpPackage = cfg.phpPackage;
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
        }
        // cfg.poolConfig;
      };

      postgresql = mkIf cfg.enablePostgresql {
        enable = true;
        ensureUsers = [
          {
            name = "part-db";
            ensureDBOwnership = true;
          }
        ];
        ensureDatabases = [ "part-db" ];
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
              tryFiles = "$uri $uri/ /index.php";
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

    systemd = {
      services = {
        part-db-migrate = {
          before = [ "phpfpm-part-db.service" ];
          after = [ "postgresql.target" ];
          requires = [ "postgresql.target" ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            User = "part-db";
          };
          restartTriggers = [
            cfg.package
          ];
          script = ''
            set -euo pipefail
            ${lib.getExe cfg.phpPackage} ${lib.getExe' cfg.package "console"} doctrine:migrations:migrate --no-interaction
          '';
        };

        phpfpm-part-db = {
          after = [ "part-db-migrate.service" ];
          requires = [
            "part-db-migrate.service"
            "postgresql.target"
          ];
          # ensure nginx can access the php-fpm socket
          postStart = ''
            ${lib.getExe' pkgs.acl "setfacl"} -m 'u:${config.services.nginx.user}:rw' ${config.services.phpfpm.pools.part-db.socket}
          '';
        };
      };

      tmpfiles.settings."part-db" = {
        "/var/cache/part-db/".d = {
          mode = "0750";
          user = "part-db";
          group = "part-db";
        };
        "/var/lib/part-db/env.local"."L+" = {
          argument = "${pkgs.writeText "part-db-env" (
            lib.concatStringsSep "\n" (lib.mapAttrsToList (key: value: "${key}=\"${value}\"") cfg.settings)
          )}";
        };
        "/var/log/part-db/".d = {
          mode = "0750";
          user = "part-db";
          group = "part-db";
        };
      };
    };
  };
}
