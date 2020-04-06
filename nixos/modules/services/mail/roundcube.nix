{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.services.roundcube;
  fpm = config.services.phpfpm.pools.roundcube;
  localDB = cfg.database.host == "localhost";
  user = cfg.database.username;
in
{
  options.services.roundcube = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable roundcube.

        Also enables nginx virtual host management.
        Further nginx configuration can be done by adapting <literal>services.nginx.virtualHosts.&lt;name&gt;</literal>.
        See <xref linkend="opt-services.nginx.virtualHosts"/> for further information.
      '';
    };

    hostName = mkOption {
      type = types.str;
      example = "webmail.example.com";
      description = "Hostname to use for the nginx vhost";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.roundcube;

      example = literalExample ''
        roundcube.withPlugins (plugins: [ plugins.persistent_login ])
      '';

      description = ''
        The package which contains roundcube's sources. Can be overriden to create
        an environment which contains roundcube and third-party plugins.
      '';
    };

    database = {
      username = mkOption {
        type = types.str;
        default = "roundcube";
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
      password = mkOption {
        type = types.str;
        description = "Password for the postgresql connection. Do not use: the password will be stored world readable in the store; use <literal>passwordFile</literal> instead.";
        default = "";
      };
      passwordFile = mkOption {
        type = types.str;
        description = "Password file for the postgresql connection. Must be readable by user <literal>nginx</literal>. Ignored if <literal>database.host</literal> is set to <literal>localhost</literal>, as peer authentication will be used.";
      };
      dbname = mkOption {
        type = types.str;
        default = "roundcube";
        description = "Name of the postgresql database";
      };
    };

    plugins = mkOption {
      type = types.listOf types.str;
      default = [];
      description = ''
        List of roundcube plugins to enable. Currently, only those directly shipped with Roundcube are supported.
      '';
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Extra configuration for roundcube webmail instance";
    };
  };

  config = mkIf cfg.enable {
    # backward compatibility: if password is set but not passwordFile, make one.
    services.roundcube.database.passwordFile = mkIf (!localDB && cfg.database.password != "") (mkDefault ("${pkgs.writeText "roundcube-password" cfg.database.password}"));
    warnings = lib.optional (!localDB && cfg.database.password != "") "services.roundcube.database.password is deprecated and insecure; use services.roundcube.database.passwordFile instead";

    environment.etc."roundcube/config.inc.php".text = ''
      <?php

      ${lib.optionalString (!localDB) "$password = file_get_contents('${cfg.database.passwordFile}');"}

      $config = array();
      $config['db_dsnw'] = 'pgsql://${cfg.database.username}${lib.optionalString (!localDB) ":' . $password . '"}@${if localDB then "unix(/run/postgresql)" else cfg.database.host}/${cfg.database.dbname}';
      $config['log_driver'] = 'syslog';
      $config['max_message_size'] = '25M';
      $config['plugins'] = [${concatMapStringsSep "," (p: "'${p}'") cfg.plugins}];
      $config['des_key'] = file_get_contents('/var/lib/roundcube/des_key');
      $config['mime_types'] = '${pkgs.nginx}/conf/mime.types';
      ${cfg.extraConfig}
    '';

    services.nginx = {
      enable = true;
      virtualHosts = {
        ${cfg.hostName} = {
          forceSSL = mkDefault true;
          enableACME = mkDefault true;
          locations."/" = {
            root = cfg.package;
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

    services.phpfpm.pools.roundcube = {
      user = if localDB then user else "nginx";
      phpOptions = ''
        error_log = 'stderr'
        log_errors = on
        post_max_size = 25M
        upload_max_filesize = 25M
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
    systemd.services.phpfpm-roundcube.after = [ "roundcube-setup.service" ];

    systemd.services.roundcube-setup = mkMerge [
      (mkIf (cfg.database.host == "localhost") {
        requires = [ "postgresql.service" ];
        after = [ "postgresql.service" ];
        path = [ config.services.postgresql.package ];
      })
      {
        wantedBy = [ "multi-user.target" ];
        script = let
          psql = "${lib.optionalString (!localDB) "PGPASSFILE=${cfg.database.passwordFile}"} ${pkgs.postgresql}/bin/psql ${lib.optionalString (!localDB) "-h ${cfg.database.host} -U ${cfg.database.username} "} ${cfg.database.dbname}";
        in
        ''
          version="$(${psql} -t <<< "select value from system where name = 'roundcube-version';" || true)"
          if ! (grep -E '[a-zA-Z0-9]' <<< "$version"); then
            ${psql} -f ${cfg.package}/SQL/postgres.initial.sql
          fi

          if [ ! -f /var/lib/roundcube/des_key ]; then
            base64 /dev/urandom | head -c 24 > /var/lib/roundcube/des_key;
            # we need to log out everyone in case change the des_key
            # from the default when upgrading from nixos 19.09
            ${psql} <<< 'TRUNCATE TABLE session;'
          fi

          ${pkgs.php}/bin/php ${cfg.package}/bin/update.sh
        '';
        serviceConfig = {
          Type = "oneshot";
          StateDirectory = "roundcube";
          User = if localDB then user else "nginx";
          # so that the des_key is not world readable
          StateDirectoryMode = "0700";
        };
      }
    ];
  };
}
