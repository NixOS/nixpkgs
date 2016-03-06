{ config, lib, pkgs, ... }: with lib;

# TODO
#
# monitoring
# logrotate aside from systemd journal?
# sys_kernel::iosched::readahead { '/var/lib/mysql': ra => 4096 }
# maintenance / consistency check
# listening on SRV interface

let
    cfg = config;
    root_password_file = "/etc/local/mysql/mysql.passwd";
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

        };

    };

    config = mkIf config.flyingcircus.roles.mysql.enable {

        services.mysql = {
          enable = true;
          package = pkgs.mysql55;
          rootPassword = root_password_file;
          dataDir = "/srv/mysql";
          extraOptions = ''
            character-set-server        = utf8
            user                        = mysql
            log-error                   = /var/log/mysql/mysqld.err
            slow_query_log              = 1
            slow_query_log_file         = /var/log/mysql/mysql.slow
            long-query-time             = 10
            skip-external-locking
            key_buffer_size             = 16M
            max_allowed_packet          = 1M
            table_open_cache            = 64
            sort_buffer_size            = 512K
            net_buffer_length           = 8K
            read_buffer_size            = 256K
            read_rnd_buffer_size        = 512K
            myisam_sort_buffer_size     = 8M
            lc_messages_dir             = /usr/share/mysql
            lc_messages                 = en_US

            bind-address                = 127.0.0.1;

            log-bin
            server-id                     = 1

            tmpdir                         = /tmp/

            innodb_buffer_pool_size = 16M
            innodb_additional_mem_pool_size = 2M
            innodb_data_file_path = ibdata1:10M:autoextend:max:128M
            innodb_log_file_size = 5M
            innodb_log_buffer_size = 8M
            innodb_log_files_in_group=2
            innodb_flush_log_at_trx_commit = 1
            innodb_lock_wait_timeout = 50
            innodb_file_per_table

            # 10MiB query cache
            query_cache_size = 10485760

            [client]
            port                        = 3306
            socket                        = /run/mysqld/mysqld.sock

            [mysql]
            character-sets-dir=/usr/share/mysql/charsets
            default-character-set=utf8

            [mysqladmin]
            character-sets-dir=/usr/share/mysql/charsets
            default-character-set=utf8

            [mysqlcheck]
            character-sets-dir=/usr/share/mysql/charsets
            default-character-set=utf8

            [mysqldump]
            character-sets-dir=/usr/share/mysql/charsets
            default-character-set=utf8

            [mysqlimport]
            character-sets-dir=/usr/share/mysql/charsets
            default-character-set=utf8

            [mysqlshow]
            character-sets-dir=/usr/share/mysql/charsets
            default-character-set=utf8

            [myisamchk]
            character-sets-dir=/usr/share/mysql/charsets

            [myisampack]
            character-sets-dir=/usr/share/mysql/charsets

            # use [safe_mysqld] with mysql-3
            [mysqld_safe]
            err-log                        = /var/log/mysql/mysql.err

            [mysqldump]
            quick
            max_allowed_packet             = 16M

            [mysql]
            # uncomment the next directive if you are not familiar with SQL
            #safe-updates

            [isamchk]
            key_buffer_size                = 20M
            sort_buffer_size               = 20M
            read_buffer                    = 2M
            write_buffer                   = 2M

            [myisamchk]
            key_buffer_size                = 20M
            sort_buffer_size               = 20M
            read_buffer_size               = 2M
            write_buffer_size              = 2M

            [mysqlhotcopy]
            interactive-timeout

            ${localConfig}
            '';
        };

        system.activationScripts.fcio-mysql-init = let
            mysql = cfg.services.mysql.package;
          in
          stringAfter [ "users" "groups" ] ''
            # Configure initial root password for mysql.
            # * set password
            # * write password to /etc/mysql/mysql.passwd
            # * create initial /root/.my.cnf if none exists
            install -d -o mysql -g service /etc/local/mysql/

            umask 0066
            if [[ ! -f ${root_password_file} ]]; then
                pw=$(${pkgs.apg}/bin/apg -a 1 -M lnc -n 1 -m 12)
                echo "''${pw}" > ${root_password_file}
            fi

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

          path = with pkgs; [ cfg.services.mysql.package ];

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

    };

}
