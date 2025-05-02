{ config, pkgs, lib, ... }:

with lib;

let

  cfg = config.services.piler;
  user = "piler";
  webserver = config.services.caddy;

  mkPhpValue = v: let
    isHasAttr = s: isAttrs v && hasAttr s v;
  in
    if isString v then escapeShellArg v
    # NOTE: If any value contains a , (comma) this will not get escaped
    else if isList v && any lib.strings.isCoercibleToString v then escapeShellArg (concatMapStringsSep "," toString v)
    else if isInt v then toString v
    else if isBool v then boolToString v
    else if isHasAttr "_file" then "trim(file_get_contents(${lib.escapeShellArg v._file}))"
    else if isHasAttr "_raw" then v._raw
    else abort "The Wordpress config value ${lib.generators.toPretty {} v} can not be encoded."
  ;

  pkg = pkgs.stdenv.mkDerivation rec {
    pname = "piler-${cfg.hostName}";
    version = src.version;
    src = pkgs.piler;

    installPhase = ''
      mkdir -p $out
      cp -r * $out/
    '';
  };

in {

  meta.maintainers = with pkgs.lib.maintainers; [ onny ];

  options = {
    services.piler = {

      enable = mkEnableOption "Piler mail archiving daemon";

      hostName = mkOption {
        type = types.str;
        default = "localhost";
        description = "FQDN for the nextcloud instance.";
      };

      stateDir = mkOption {
        type = types.path;
        default = "/var/lib/piler";
        description = lib.mdDoc ''
          This directory is used for uploads of attachements and cache.
          The directory passed here is automatically created and permissions
          adjusted as required.
        '';
      };

      database = {
        host = mkOption {
          type = types.str;
          default = "localhost";
          description = lib.mdDoc "Database host address.";
        };

        port = mkOption {
          type = types.port;
          default = 3306;
          description = lib.mdDoc "Database host port.";
        };

        name = mkOption {
          type = types.str;
          default = "piler";
          description = lib.mdDoc "Database name.";
        };

        tableprefix = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = lib.mdDoc "Database table prefix.";
        };

        user = mkOption {
          type = types.str;
          default = "piler";
          description = lib.mdDoc "Database user.";
        };

        passwordFile = mkOption {
          type = types.nullOr types.path;
          default = null;
          example = "/run/keys/piler-dbpassword";
          description = lib.mdDoc ''
            A file containing the password corresponding to
            {option}`database.user`.
          '';
        };

        createLocally = mkOption {
          type = types.bool;
          default = true;
          description = lib.mdDoc "Create the database and database user locally.";
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
          Options for the Piler PHP pool. See the documentation on `php-fpm.conf`
          for details on configuration directives.
        '';
      };

      settings = mkOption {
        type = types.attrsOf types.anything;
        default = {};
        description = ''
          Structural Piler configuration. Refer to
          <https://github.com/jsuto/piler/blob/master/config.php.in>
          for details and supported values.
        '';
        example = literalExpression ''
          {
            SETUP_COMPLETED = true;
            DISABLE_SETUP = true;
            IP_URL = "https://invoice.example.com";
          }
        '';
      };

    };

  };

  config = mkIf cfg.enable {

    assertions = [
      { assertion = cfg.database.createLocally -> cfg.database.user == user;
        message = ''services.piler.database.user must be ${user} if the database is to be automatically provisioned'';
      }
      { assertion = cfg.database.createLocally -> cfg.database.passwordFile == null;
          message = ''services.piler.database.passwordFile cannot be specified if services.piler.database.createLocally is set to true.'';
      }
    ];

    services.piler.settings = {
      DB_PREFIX = cfg.database.tableprefix;
      DB_HOSTNAME = cfg.database.host;
      DB_USERNAME = cfg.database.user;
      DB_PASSWORD = if (cfg.database.passwordFile != null) then { _file = cfg.database.passwordFile; } else "";
      DB_DATABASE = cfg.database.name;
    };

    services.manticore.enable = true;

    services.mysql = mkIf cfg.database.createLocally {
      enable = true;
      package = mkDefault pkgs.mariadb;
      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [{
        name = cfg.database.user;
        ensurePermissions = { "${cfg.database.name}.*" = "ALL PRIVILEGES"; };
      }];
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
      phpPackage = pkgs.php83;
      pools."piler-${cfg.hostName}" = {
        inherit user;
        group = webserver.group;
        settings = {
          "listen.owner" = webserver.user;
          "listen.group" = webserver.group;
        } // cfg.poolConfig;
      };
    };

    users.users.${user} = {
      group = webserver.group;
      isSystemUser = true;
    };

  };

}
