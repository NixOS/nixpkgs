{ config, lib, pkgs, ... }:

let

  inherit (lib) mkDefault mkEnableOption mkForce mkIf mkMerge mkOption types;
  inherit (lib) literalExample mapAttrs optionalString;

  cfg = config.services.zabbixWeb;
  fpm = config.services.phpfpm.pools.zabbix;

  user = "zabbix";
  group = "zabbix";
  stateDir = "/var/lib/zabbix";

  zabbixConfig = pkgs.writeText "zabbix.conf.php" ''
    <?php
    // Zabbix GUI configuration file.
    global $DB;
    $DB['TYPE'] = '${ { mysql = "MYSQL"; pgsql = "POSTGRESQL"; oracle = "ORACLE"; }.${cfg.database.type} }';
    $DB['SERVER'] = '${cfg.database.host}';
    $DB['PORT'] = '${toString cfg.database.port}';
    $DB['DATABASE'] = '${cfg.database.name}';
    $DB['USER'] = '${cfg.database.user}';
    $DB['PASSWORD'] = ${if cfg.database.passwordFile != null then "file_get_contents('${cfg.database.passwordFile}')" else "''"};
    // Schema name. Used for IBM DB2 and PostgreSQL.
    $DB['SCHEMA'] = ''';
    $ZBX_SERVER = '${cfg.server.address}';
    $ZBX_SERVER_PORT = '${toString cfg.server.port}';
    $ZBX_SERVER_NAME = ''';
    $IMAGE_FORMAT_DEFAULT = IMAGE_FORMAT_PNG;
  '';

in
{
  # interface

  options.services = {
    zabbixWeb = {
      enable = mkEnableOption "the Zabbix web interface";

      package = mkOption {
        type = types.package;
        default = pkgs.zabbix.web;
        defaultText = "zabbix.web";
        description = "Which Zabbix package to use.";
      };

      server = {
        port = mkOption {
          type = types.int;
          description = "The port of the Zabbix server to connect to.";
          default = 10051;
        };

        address = mkOption {
          type = types.str;
          description = "The IP address or hostname of the Zabbix server to connect to.";
          default = "localhost";
        };
      };

      database = {
        type = mkOption {
          type = types.enum [ "mysql" "pgsql" "oracle" ];
          example = "mysql";
          default = "pgsql";
          description = "Database engine to use.";
        };

        host = mkOption {
          type = types.str;
          default = "";
          description = "Database host address.";
        };

        port = mkOption {
          type = types.int;
          default =
            if cfg.database.type == "mysql" then config.services.mysql.port
            else if cfg.database.type == "pgsql" then config.services.postgresql.port
            else 1521;
          description = "Database host port.";
        };

        name = mkOption {
          type = types.str;
          default = "zabbix";
          description = "Database name.";
        };

        user = mkOption {
          type = types.str;
          default = "zabbix";
          description = "Database user.";
        };

        passwordFile = mkOption {
          type = types.nullOr types.path;
          default = null;
          example = "/run/keys/zabbix-dbpassword";
          description = ''
            A file containing the password corresponding to
            <option>database.user</option>.
          '';
        };

        socket = mkOption {
          type = types.nullOr types.path;
          default = null;
          example = "/run/postgresql";
          description = "Path to the unix socket file to use for authentication.";
        };
      };

      virtualHost = mkOption {
        type = types.submodule (import ../web-servers/apache-httpd/per-server-options.nix);
        example = literalExample ''
          {
            hostName = "zabbix.example.org";
            adminAddr = "webmaster@example.org";
            forceSSL = true;
            enableACME = true;
          }
        '';
        description = ''
          Apache configuration can be done by adapting <literal>services.httpd.virtualHosts.&lt;name&gt;</literal>.
          See <xref linkend="opt-services.httpd.virtualHosts"/> for further information.
        '';
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
        description = ''
          Options for the Zabbix PHP pool. See the documentation on <literal>php-fpm.conf</literal> for details on configuration directives.
        '';
      };

    };
  };

  # implementation

  config = mkIf cfg.enable {

    systemd.tmpfiles.rules = [
      "d '${stateDir}' 0750 ${user} ${group} - -"
      "d '${stateDir}/session' 0750 ${user} ${config.services.httpd.group} - -"
    ];

    services.phpfpm.pools.zabbix = {
      inherit user;
      group = config.services.httpd.group;
      phpOptions = ''
        # https://www.zabbix.com/documentation/current/manual/installation/install
        memory_limit = 128M
        post_max_size = 16M
        upload_max_filesize = 2M
        max_execution_time = 300
        max_input_time = 300
        session.auto_start = 0
        mbstring.func_overload = 0
        always_populate_raw_post_data = -1
        # https://bbs.archlinux.org/viewtopic.php?pid=1745214#p1745214
        session.save_path = ${stateDir}/session
      '' + optionalString (config.time.timeZone != null) ''
        date.timezone = "${config.time.timeZone}"
      '' + optionalString (cfg.database.type == "oracle") ''
        extension=${pkgs.phpPackages.oci8}/lib/php/extensions/oci8.so
      '';
      phpEnv.ZABBIX_CONFIG = "${zabbixConfig}";
      settings = {
        "listen.owner" = config.services.httpd.user;
        "listen.group" = config.services.httpd.group;
      } // cfg.poolConfig;
    };

    services.httpd = {
      enable = true;
      adminAddr = mkDefault cfg.virtualHost.adminAddr;
      extraModules = [ "proxy_fcgi" ];
      virtualHosts.${cfg.virtualHost.hostName} = mkMerge [ cfg.virtualHost {
        documentRoot = mkForce "${cfg.package}/share/zabbix";
        extraConfig = ''
          <Directory "${cfg.package}/share/zabbix">
            <FilesMatch "\.php$">
              <If "-f %{REQUEST_FILENAME}">
                SetHandler "proxy:unix:${fpm.socket}|fcgi://localhost/"
              </If>
            </FilesMatch>
            AllowOverride all
            Options -Indexes
            DirectoryIndex index.php
          </Directory>
        '';
      } ];
    };

    users.users.${user} = mapAttrs (name: mkDefault) {
      description = "Zabbix daemon user";
      uid = config.ids.uids.zabbix;
      inherit group;
    };

    users.groups.${group} = mapAttrs (name: mkDefault) {
      gid = config.ids.gids.zabbix;
    };

  };
}
