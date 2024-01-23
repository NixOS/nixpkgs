{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.piler;
  eachSite = cfg.sites;
  user = "piler";
  webserver = config.services.${cfg.webserver};

  pkg = hostName: cfg: pkgs.stdenv.mkDerivation rec {
    pname = "piler-${hostName}";
    version = src.version;
    src = pkgs.piler;

    installPhase = ''
      mkdir -p $out
      cp -r var/piler/www $out/
      cp -r etc $out/
      sed -i "214i\$config['DIR_BASE'] = '${placeholder "out"}/www/';" $out/www/config.php

      # Configure MySQL database in the Manticore settings and correct state directory path
      sed "s/MYSQL_HOSTNAME/${cfg.database.host}/g; s/MYSQL_DATABASE/${cfg.database.name}/g; s/MYSQL_USERNAME/${cfg.database.user}/g; s/MYSQL_PASSWORD/${if cfg.database.passwordFile == null then "" else "trim(file_get_contents('${cfg.database.passwordFile}'), \"\\r\\n\")"}/g; s/piler\/manticore/piler\/${hostName}\/manticore/g;" $out/etc/piler/manticore.conf.dist > $out/etc/piler/manticore.conf
    '';
  };

  siteOpts = { lib, name, ... }:
    {
      options = {

        enable = mkEnableOption (lib.mdDoc "Piler web application");

        stateDir = mkOption {
          type = types.path;
          default = "/var/lib/piler/${name}";
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

      };

    };
in
{
  # interface
  options = {
    services.piler = mkOption {
      type = types.submodule {

        options.sites = mkOption {
          type = types.attrsOf (types.submodule siteOpts);
          default = {};
          description = lib.mdDoc "Specification of one or more Piler sites to serve";
        };

        options.webserver = mkOption {
          type = types.enum [ "caddy" ];
          default = "caddy";
          description = lib.mdDoc ''
            Which webserver to use for virtual host management. Currently only
            caddy is supported.
          '';
        };
      };
      default = {};
      description = lib.mdDoc "Piler configuration.";
    };

  };

  # implementation
  config = mkIf (eachSite != {}) (mkMerge [{

    assertions = flatten (mapAttrsToList (hostName: cfg:
      [{ assertion = cfg.database.createLocally -> cfg.database.user == user;
        message = ''services.piler.sites."${hostName}".database.user must be ${user} if the database is to be automatically provisioned'';
      }
      { assertion = cfg.database.createLocally -> cfg.database.passwordFile == null;
        message = ''services.piler.sites."${hostName}".database.passwordFile cannot be specified if services.invoiceplane.sites."${hostName}".database.createLocally is set to true.'';
      }]
    ) eachSite);

    services.mysql = mkIf (any (v: v.database.createLocally) (attrValues eachSite)) {
      enable = true;
      package = mkDefault pkgs.mariadb;
      # FIXME
      #ensureDatabases = mapAttrsToList (hostName: cfg: cfg.database.name) eachSite;
      ensureUsers = mapAttrsToList (hostName: cfg:
        { name = cfg.database.user;
          ensurePermissions = { "${cfg.database.name}.*" = "ALL PRIVILEGES"; };
        }
      ) eachSite;
    };

    # FIXMES
    services.manticore.enable = true;
    environment.systemPackages = with pkgs; [ piler manticoresearch ];

    services.phpfpm = {
      phpPackage = pkgs.php81;
      pools = mapAttrs' (hostName: cfg: (
        nameValuePair "piler-${hostName}" {
          inherit user;
          group = webserver.group;
          settings = {
            "listen.owner" = webserver.user;
            "listen.group" = webserver.group;
          } // cfg.poolConfig;
        }
      )) eachSite;
    };

  }

  {
    systemd.tmpfiles.rules = flatten (mapAttrsToList (hostName: cfg: [
      "d ${cfg.stateDir} 0750 ${user} ${webserver.group} - -"
      "d ${cfg.stateDir}/manticore 0750 ${user} ${webserver.group} - -"
      "d /var/run/piler/${hostName} 0750 ${user} ${webserver.group} - -"
    ]) eachSite);

    users.users.${user} = {
      group = webserver.group;
      isSystemUser = true;
    };
  }

  (mkIf (cfg.webserver == "caddy") {
    services.caddy = {
      enable = true;
      virtualHosts = mapAttrs' (hostName: cfg: (
        nameValuePair "http://${hostName}" {
          extraConfig = ''
            root    * ${pkg hostName cfg}/www
            file_server

            php_fastcgi unix/${config.services.phpfpm.pools."piler-${hostName}".socket}
          '';
        }
      )) eachSite;
    };
  })


  ]);
}
