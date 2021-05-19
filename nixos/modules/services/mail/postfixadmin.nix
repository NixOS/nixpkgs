{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.services.postfixadmin;
  fpm = config.services.phpfpm.pools.postfixadmin;
  localDB = cfg.database.host == "localhost";
  user = if localDB then cfg.database.username else "nginx";
in
{
  options.services.postfixadmin = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable postfixadmin.

        Also enables nginx virtual host management.
        Further nginx configuration can be done by adapting <literal>services.nginx.virtualHosts.&lt;name&gt;</literal>.
        See <xref linkend="opt-services.nginx.virtualHosts"/> for further information.
      '';
    };

    hostName = mkOption {
      type = types.str;
      example = "postfixadmin.example.com";
      description = "Hostname to use for the nginx vhost";
    };

    adminEmail = mkOption {
      type = types.str;
      example = "postfixadmin.example.com";
      description = ''
        Define the Site Admin's email address below.
        This will be used to send emails from to create mailboxes and
        from Send Email / Broadcast message pages.
      '';
    };

    setupPasswordFile = mkOption {
      type = types.path;
      description = ''
        Password file for the admin.
        Generate with <literal>php -r "echo password_hash('some password here', PASSWORD_DEFAULT);"</literal>
      '';
    };

    database = {
      username = mkOption {
        type = types.str;
        default = "postfixadmin";
        description = ''
          Username for the postgresql connection.
          If <literal>database.host</literal> is set to <literal>localhost</literal>, a unix user and group of the same name will be created as well.
        '';
      };
      host = mkOption {
        type = types.str;
        default = "localhost";
        description = ''
          Host of the postgresql server. If this is not set to
          <literal>localhost</literal>, you have to create the
          postgresql user and database yourself, with appropriate
          permissions.
        '';
      };
      passwordFile = mkOption {
        type = types.path;
        description = "Password file for the postgresql connection. Must be readable by user <literal>nginx</literal>.";
      };
      dbname = mkOption {
        type = types.str;
        default = "postfixadmin";
        description = "Name of the postgresql database";
      };
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Extra configuration for the postfixadmin instance, see postfixadmin's config.inc.php for available options.";
    };
  };

  config = mkIf cfg.enable {
    environment.etc."postfixadmin/config.local.php".text = ''
      <?php

      $CONF['setup_password'] = file_get_contents('${cfg.setupPasswordFile}');

      $CONF['database_type'] = 'pgsql';
      $CONF['database_host'] = ${if localDB then "null" else "'${cfg.database.host}'"};
      ${optionalString localDB "$CONF['database_user'] = '${cfg.database.username}';"}
      $CONF['database_password'] = ${if localDB then "'dummy'" else "file_get_contents('${cfg.database.passwordFile}')"};
      $CONF['database_name'] = '${cfg.database.dbname}';
      $CONF['configured'] = true;

      ${cfg.extraConfig}
    '';

    systemd.tmpfiles.rules = [ "d /var/cache/postfixadmin/templates_c 700 ${user} ${user}" ];

    services.nginx = {
      enable = true;
      virtualHosts = {
        ${cfg.hostName} = {
          forceSSL = mkDefault true;
          enableACME = mkDefault true;
          locations."/" = {
            root = "${pkgs.postfixadmin}/public";
            index = "index.php";
            extraConfig = ''
              location ~* \.php$ {
                fastcgi_split_path_info ^(.+\.php)(/.+)$;
                fastcgi_pass unix:${fpm.socket};
                include ${pkgs.nginx}/conf/fastcgi_params;
                include ${pkgs.nginx}/conf/fastcgi.conf;
              }
            '';
          };
        };
      };
    };

    services.postgresql = mkIf localDB {
      enable = true;
      ensureDatabases = [ cfg.database.dbname ];
      ensureUsers = [ {
        name = cfg.database.username;
        ensurePermissions = {
          "DATABASE ${cfg.database.username}" = "ALL PRIVILEGES";
        };
      } ];
    };

    users.users.${user} = mkIf localDB {
      group = user;
      isSystemUser = true;
      createHome = false;
    };
    users.groups.${user} = mkIf localDB {};

    services.phpfpm.pools.postfixadmin = {
      user = user;
      phpOptions = ''
        error_log = 'stderr'
        log_errors = on
      '';
      settings = mapAttrs (name: mkDefault) {
        "listen.owner" = "nginx";
        "listen.group" = "nginx";
        "listen.mode" = "0660";
        "pm" = "dynamic";
        "pm.max_children" = 75;
        "pm.start_servers" = 2;
        "pm.min_spare_servers" = 1;
        "pm.max_spare_servers" = 20;
        "pm.max_requests" = 500;
        "catch_workers_output" = true;
      };
    };
  };
}
