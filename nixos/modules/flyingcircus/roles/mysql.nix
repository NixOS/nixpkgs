{ config, lib, pkgs, ... }: with lib;

# TODO
#
# monitoring
# logrotate aside from systemd journal?
# sys_kernel::iosched::readahead { '/var/lib/mysql': ra => 4096 }
# maintenance / consistency check
# listening on SRV interface

let
    cfg = config.flyingcircus.roles.mysql;

    root_password_file = "/etc/local/mysql/mysql.passwd";
    root_password_setter =
        if cfg.rootPassword == null
        then "$(${pkgs.apg}/bin/apg -a 1 -M lnc -n 1 -m 12)"
        else "\"${cfg.rootPassword}\"";

    localConfig = if pathExists /etc/local/mysql
                  then "!include ${/etc/local/mysql}"
                  else "";


in

{

    options = {

        flyingcircus.roles.mysql = {

            enable = mkOption {
                type = types.bool;
                default = false;
                description = "Enable the Flying Circus MySQL server role.";
            };

            rootPassword = mkOption {
                type = types.nullOr types.string;
                default = null;
                description = ''
                    The root password for mysql. If null, a random root
                    password will be set.
                '';
            };

            extraConfig = mkOption {
              type = types.lines;
              default = "";
              description =
                ''
                    Extra MySQL configuration to append at the end of the
                    configuration file. Do not assume this to be located
                    in any specific section.
                '';
            };


        };

    };

    config = mkIf cfg.enable {

        services.percona = {
          enable = true;
          package = pkgs.percona;
          rootPassword = root_password_file;
          dataDir = "/srv/mysql";
          extraOptions = ''
            [mysqld]
            default-storage-engine  = innodb
            skip-external-locking
            skip-name-resolve
            max_allowed_packet         = 512M
            bulk_insert_buffer_size    = 128M
            tmp_table_size             = 512M
            max_heap_table_size        = 512M
            lower-case-table-names     = 0
            max_connect_errors         = 20
            default_storage_engine     = InnoDB
            table_definition_cache     = 512
            open_files_limit           = 65535
            sysdate-is-now             = 1
            sql_mode                   = NO_ENGINE_SUBSTITUTION

            init-connect               = 'SET NAMES utf8 COLLATE utf8_unicode_ci'
            character-set-server       = utf8
            collation-server           = utf8_unicode_ci
            character_set_server       = utf8
            collation_server           = utf8_unicode_ci

            # Timeouteinstellung
            interactive_timeout        = 28800
            wait_timeout               = 28800
            connect_timeout            = 10

            bind-address               = 0.0.0.0
            max_connections            = 1000
            thread_cache_size          = 128
            myisam-recover-options     = FORCE
            key_buffer_size            = 64M
            table_open_cache           = 1000
            # myisam-recover           = FORCE
            thread_cache_size          = 8

            query_cache_type           = 1
            query_cache_min_res_unit   = 2k
            query_cache_size           = 80M

            # * InnoDB
            innodb-buffer-pool-size         = 7G
            innodb-log-buffer-size          = 64M
            innodb-file-per-table           = 1
            ## You may want to tune the below depending on number of cores and disk sub
            # alte werte waren 4 (laut empfhelung 4 x number of cores)
            innodb_read_io_threads          = 32
            innodb_write_io_threads         = 32
            innodb_change_buffer_max_size   = 50
            innodb-doublewrite              = 1
            innodb_log_file_size            = 512M
            innodb-log-files-in-group       = 4
            innodb-flush-method             = O_DSYNC
            innodb_open_files               = 800
            innodb_stats_on_metadata        = 0
            innodb_lock_wait_timeout        = 120

            [mysqldump]
            quick
            quote-names
            max_allowed_packet    = 512M

            [xtrabackup]
            target_dir                      = /opt/backup/xtrabackup
            compress-threads                = 4
            compress
            parallel            = 3

            [isamchk]
            key_buffer        = 16M

            # flyingcircus.roles.mysql.extraConfig
            ${cfg.extraConfig}

            # /etc/local/mysql/*
            ${localConfig}
            '';
        };

        system.activationScripts.fcio-mysql-init = let
            mysql = config.services.percona.package;
          in
          stringAfter [ "users" "groups" ] ''
            # Configure initial root password for mysql.
            # * set password
            # * write password to /etc/mysql/mysql.passwd
            # * create initial /root/.my.cnf if none exists
            install -d -o mysql -g service  -m 02775 /etc/local/mysql/

            umask 0066
            if [[ ! -f ${root_password_file} ]]; then
                pw=${root_password_setter}
                echo -n "''${pw}" > ${root_password_file}
            fi
            chown root:service ${root_password_file}
            chmod 640 ${root_password_file}

            if [[ ! -f /root/.my.cnf ]]; then
                touch /root/.my.cnf
                chmod 640 /root/.my.cnf
                pw=$(<${root_password_file})
                cat > /root/.my.cnf <<__EOT__
            # The following options will be passed to all MySQL clients
            [client]
            password = ''${pw}
            __EOT__
            fi
          '';

        systemd.services.mysql-maintenance = {
          description = "Timed MySQL maintenance tasks";
          after = [ "mysql.service" ];
          wants = [ "mysql-maintenance.timer" ];
          partOf = [ "mysql.service" ];

          path = with pkgs; [ config.services.percona.package ];

          serviceConfig = {
            Type = "oneshot";
            ExecStart = "${./mysql-maintenance.sh}";
          };

        };

        systemd.timers.mysql-maintenance = {
          description = "Timer for MySQL maintenance";
          partOf = [ "mysql.service" "mysql-maintenance.service" ];

          timerConfig = {
            onCalendar = "weekly";    # XXX Randomize!
          };
        };

        security.sudo.extraConfig = ''
            # MySQL sudo rules

            Cmnd_Alias      MYSQL_RESTART = /run/current-system/sw/bin/systemctl restart mysql
            %service        ALL=(root) MYSQL_RESTART
            %sudo-srv       ALL=(root) MYSQL_RESTART
        '';

        services.udev.extraRules = ''
          # increase readahead for mysql
          SUBSYSTEM=="block", ATTR{queue/rotational}=="1", ACTION=="add|change", KERNEL=="vd[a-z]", ATTR{bdi/read_ahead_kb}="1024", ATTR{queue/read_ahead_kb}="1024"
        '';

        environment.systemPackages = [
            pkgs.xtrabackup
        ];
    };
}
