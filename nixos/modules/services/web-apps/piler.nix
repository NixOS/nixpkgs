{
  config,
  pkgs,
  lib,
  ...
}:
let

  cfg = config.services.piler;
  user = "piler";
  webserver = config.services.caddy;

  mkPhpValue =
    v:
    let
      isHasAttr = s: lib.isAttrs v && lib.hasAttr s v;
    in
    if lib.isString v then
      lib.scapeShellArg v
    # NOTE: If any value contains a , (comma) this will not get escaped
    else if lib.isList v && lib.any lib.strings.isCoercibleToString v then
      lib.escapeShellArg (lib.concatMapStringsSep "," lib.toString v)
    else if lib.isInt v then
      lib.toString v
    else if lib.isBool v then
      lib.boolToString v
    else if lib.isHasAttr "_file" then
      "trim(file_get_contents(${lib.escapeShellArg v._file}))"
    else if lib.isHasAttr "_raw" then
      v._raw
    else
      abort "The Piler config value ${lib.generators.toPretty { } v} can not be encoded.";

  pkg = pkgs.stdenv.mkDerivation (finalAttrs: {
    pname = "piler-${cfg.hostName}";
    version = finalAttrs.src.version;
    src = pkgs.piler;

    installPhase = ''
      mkdir -p $out
      cp -r * $out/
    '';
  });

in
{

  meta.maintainers = with pkgs.lib.maintainers; [ onny ];

  options = {
    services.piler = {

      enable = lib.mkEnableOption "Piler mail archiving daemon";

      hostName = lib.mkOption {
        type = lib.types.str;
        default = "localhost";
        description = "FQDN for the nextcloud instance.";
      };

      stateDir = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/piler";
        description = ''
          This directory is used for uploads of attachements and cache.
          The directory passed here is automatically created and permissions
          adjusted as required.
        '';
      };

      database = {
        host = lib.mkOption {
          type = lib.types.str;
          default = "localhost";
          description = "Database host address.";
        };

        port = lib.mkOption {
          type = lib.types.port;
          default = 3306;
          description = "Database host port.";
        };

        name = lib.mkOption {
          type = lib.types.str;
          default = "piler";
          description = "Database name.";
        };

        tableprefix = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "Database table prefix.";
        };

        user = lib.mkOption {
          type = lib.types.str;
          default = "piler";
          description = "Database user.";
        };

        passwordFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          example = "/run/keys/piler-dbpassword";
          description = ''
            A file containing the password corresponding to
            {option}`database.user`.
          '';
        };

        createLocally = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Create the database and database user locally.";
        };
      };

      poolConfig = lib.mkOption {
        type =
          lib.types.attrsOf (lib.types.oneOf [
            lib.types.str
            lib.types.int
            lib.types.bool
          ]);
        default = {
          "pm" = "dynamic";
          "pm.max_children" = 32;
          "pm.start_servers" = 2;
          "pm.min_spare_servers" = 2;
          "pm.max_spare_servers" = 4;
          "pm.max_requests" = 500;
        };
        description = ''
          Options for the Piler PHP pool. See the documentation on `php-fpm.conf`
          for details on configuration directives.
        '';
      };

      settings = lib.mkOption {
        type = lib.types.attrsOf lib.types.anything;
        default = { };
        description = ''
          Structural Piler configuration. Refer to
          <https://github.com/jsuto/piler/blob/master/config.php.in>
          for details and supported values.
        '';
        example = lib.literalExpression ''
          {
            SETUP_COMPLETED = true;
            DISABLE_SETUP = true;
            IP_URL = "https://invoice.example.com";
          }
        '';
      };

    };

  };

  config = lib.mkIf cfg.enable {

    assertions = [
      {
        assertion = cfg.database.createLocally -> cfg.database.user == user;
        message = "services.piler.database.user must be ${user} if the database is to be automatically provisioned";
      }
      {
        assertion = cfg.database.createLocally -> cfg.database.passwordFile == null;
        message = "services.piler.database.passwordFile cannot be specified if services.piler.database.createLocally is set to true.";
      }
    ];

    services.piler.settings = {
      DB_PREFIX = cfg.database.tableprefix;
      DB_HOSTNAME = cfg.database.host;
      DB_USERNAME = cfg.database.user;
      DB_PASSWORD =
        if (cfg.database.passwordFile != null) then { _file = cfg.database.passwordFile; } else "";
      DB_DATABASE = cfg.database.name;
    };

    services.manticore.enable = true;

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

    services.caddy = {
      enable = true;
      virtualHosts."http://${cfg.hostName}" = {
        extraConfig = ''
          root * ${pkg}/var/piler/www
          file_server

          php_fastcgi unix/${config.services.phpfpm.pools."piler-${cfg.hostName}".socket}
        '';
      };
    };

    services.phpfpm = {
      # Check if we could update to php85
      phpPackage = pkgs.php83;
      pools."piler-${cfg.hostName}" = {
        inherit user;
        group = webserver.group;
        settings = {
          "listen.owner" = webserver.user;
          "listen.group" = webserver.group;
        }
        // cfg.poolConfig;
      };
    };

    users.users.${user} = {
      group = webserver.group;
      isSystemUser = true;
    };

  };

}
