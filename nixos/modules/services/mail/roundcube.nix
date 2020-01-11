{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.services.roundcube;
  fpm = config.services.phpfpm.pools.roundcube;
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
        description = "Username for the postgresql connection";
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
        description = "Password for the postgresql connection";
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
    environment.etc."roundcube/config.inc.php".text = ''
      <?php

      $config = array();
      $config['db_dsnw'] = 'pgsql://${cfg.database.username}:${cfg.database.password}@${cfg.database.host}/${cfg.database.dbname}';
      $config['log_driver'] = 'syslog';
      $config['max_message_size'] = '25M';
      $config['plugins'] = [${concatMapStringsSep "," (p: "'${p}'") cfg.plugins}];
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

    services.postgresql = mkIf (cfg.database.host == "localhost") {
      enable = true;
    };

    services.phpfpm.pools.roundcube = {
      user = "nginx";
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

    systemd.services.roundcube-setup = let
      pgSuperUser = config.services.postgresql.superUser;
    in mkMerge [
      (mkIf (cfg.database.host == "localhost") {
        requires = [ "postgresql.service" ];
        after = [ "postgresql.service" ];
        path = [ config.services.postgresql.package ];
      })
      {
        wantedBy = [ "multi-user.target" ];
        script = ''
          mkdir -p /var/lib/roundcube
          if [ ! -f /var/lib/roundcube/db-created ]; then
            if [ "${cfg.database.host}" = "localhost" ]; then
              ${pkgs.sudo}/bin/sudo -u ${pgSuperUser} psql postgres -c "create role ${cfg.database.username} with login password '${cfg.database.password}'";
              ${pkgs.sudo}/bin/sudo -u ${pgSuperUser} psql postgres -c "create database ${cfg.database.dbname} with owner ${cfg.database.username}";
            fi
            PGPASSWORD="${cfg.database.password}" ${pkgs.postgresql}/bin/psql -U ${cfg.database.username} \
              -f ${cfg.package}/SQL/postgres.initial.sql \
              -h ${cfg.database.host} ${cfg.database.dbname}
            touch /var/lib/roundcube/db-created
          fi

          ${pkgs.php}/bin/php ${cfg.package}/bin/update.sh
        '';
        serviceConfig.Type = "oneshot";
      }
    ];
  };
}
