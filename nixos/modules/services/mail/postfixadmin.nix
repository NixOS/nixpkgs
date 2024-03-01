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
      description = lib.mdDoc ''
        Whether to enable postfixadmin.

        Also enables nginx virtual host management.
        Further nginx configuration can be done by adapting `services.nginx.virtualHosts.<name>`.
        See [](#opt-services.nginx.virtualHosts) for further information.
      '';
    };

    hostName = mkOption {
      type = types.str;
      example = "postfixadmin.example.com";
      description = lib.mdDoc "Hostname to use for the nginx vhost";
    };

    adminEmail = mkOption {
      type = types.str;
      example = "postmaster@example.com";
      description = lib.mdDoc ''
        Defines the Site Admin's email address.
        This will be used to send emails from to create mailboxes and
        from Send Email / Broadcast message pages.
      '';
    };

    setupPasswordFile = mkOption {
      type = types.path;
      description = lib.mdDoc ''
        Password file for the admin.
        Generate with `php -r "echo password_hash('some password here', PASSWORD_DEFAULT);"`
      '';
    };

    database = {
      username = mkOption {
        type = types.str;
        default = "postfixadmin";
        description = lib.mdDoc ''
          Username for the postgresql connection.
          If `database.host` is set to `localhost`, a unix user and group of the same name will be created as well.
        '';
      };
      host = mkOption {
        type = types.str;
        default = "localhost";
        description = lib.mdDoc ''
          Host of the postgresql server. If this is not set to
          `localhost`, you have to create the
          postgresql user and database yourself, with appropriate
          permissions.
        '';
      };
      passwordFile = mkOption {
        type = types.path;
        description = lib.mdDoc "Password file for the postgresql connection. Must be readable by user `nginx`.";
      };
      dbname = mkOption {
        type = types.str;
        default = "postfixadmin";
        description = lib.mdDoc "Name of the postgresql database";
      };
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = lib.mdDoc "Extra configuration for the postfixadmin instance, see postfixadmin's config.inc.php for available options.";
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

    systemd.tmpfiles.settings."10-postfixadmin"."/var/cache/postfixadmin/templates_c".d = {
      inherit user;
      group = user;
      mode = "700";
    };

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
                include ${config.services.nginx.package}/conf/fastcgi_params;
                include ${pkgs.nginx}/conf/fastcgi.conf;
              }
            '';
          };
        };
      };
    };

    services.postgresql = mkIf localDB {
      enable = true;
      ensureUsers = [ {
        name = cfg.database.username;
      } ];
    };
    # The postgresql module doesn't currently support concepts like
    # objects owners and extensions; for now we tack on what's needed
    # here.
    systemd.services.postfixadmin-postgres = let pgsql = config.services.postgresql; in mkIf localDB {
      after = [ "postgresql.service" ];
      bindsTo = [ "postgresql.service" ];
      wantedBy = [ "multi-user.target" ];
      path = [
        pgsql.package
        pkgs.util-linux
      ];
      script = ''
        set -eu

        PSQL() {
            psql --port=${toString pgsql.port} "$@"
        }

        PSQL -tAc "SELECT 1 FROM pg_database WHERE datname = '${cfg.database.dbname}'" | grep -q 1 || PSQL -tAc 'CREATE DATABASE "${cfg.database.dbname}" OWNER "${cfg.database.username}"'
        current_owner=$(PSQL -tAc "SELECT pg_catalog.pg_get_userbyid(datdba) FROM pg_catalog.pg_database WHERE datname = '${cfg.database.dbname}'")
        if [[ "$current_owner" != "${cfg.database.username}" ]]; then
            PSQL -tAc 'ALTER DATABASE "${cfg.database.dbname}" OWNER TO "${cfg.database.username}"'
            if [[ -e "${config.services.postgresql.dataDir}/.reassigning_${cfg.database.dbname}" ]]; then
                echo "Reassigning ownership of database ${cfg.database.dbname} to user ${cfg.database.username} failed on last boot. Failing..."
                exit 1
            fi
            touch "${config.services.postgresql.dataDir}/.reassigning_${cfg.database.dbname}"
            PSQL "${cfg.database.dbname}" -tAc "REASSIGN OWNED BY \"$current_owner\" TO \"${cfg.database.username}\""
            rm "${config.services.postgresql.dataDir}/.reassigning_${cfg.database.dbname}"
        fi
      '';

      serviceConfig = {
        User = pgsql.superUser;
        Type = "oneshot";
        RemainAfterExit = true;
      };
    };

    users.users.${user} = mkIf localDB {
      group = user;
      isSystemUser = true;
      createHome = false;
    };
    users.groups.${user} = mkIf localDB {};

    services.phpfpm.pools.postfixadmin = {
      user = user;
      phpPackage = pkgs.php81;
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
