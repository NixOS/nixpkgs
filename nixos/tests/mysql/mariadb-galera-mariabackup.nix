import ./../make-test-python.nix ({ pkgs, ...} :

let
  mysqlenv-common      = pkgs.buildEnv { name = "mysql-path-env-common";      pathsToLink = [ "/bin" ]; paths = with pkgs; [ bash gawk gnutar inetutils which ]; };
  mysqlenv-mariabackup = pkgs.buildEnv { name = "mysql-path-env-mariabackup"; pathsToLink = [ "/bin" ]; paths = with pkgs; [ gzip iproute2 netcat procps pv socat ]; };

in {
  name = "mariadb-galera-mariabackup";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ izorkin ];
  };

  # The test creates a Galera cluster with 3 nodes and is checking if mariabackup-based SST works. The cluster is tested by creating a DB and an empty table on one node,
  # and checking the table's presence on the other node.

  nodes = {
    galera_01 =
      { pkgs, ... }:
      {
      networking = {
        interfaces.eth1 = {
          ipv4.addresses = [
            { address = "192.168.1.1"; prefixLength = 24; }
          ];
        };
        extraHosts = ''
          192.168.1.1 galera_01
          192.168.1.2 galera_02
          192.168.1.3 galera_03
        '';
        firewall.allowedTCPPorts = [ 3306 4444 4567 4568 ];
        firewall.allowedUDPPorts = [ 4567 ];
      };
      users.users.testuser = { isSystemUser = true; };
      systemd.services.mysql = with pkgs; {
        path = [ mysqlenv-common mysqlenv-mariabackup ];
      };
      services.mysql = {
        enable = true;
        package = pkgs.mariadb;
        ensureDatabases = [ "testdb" ];
        ensureUsers = [{
          name = "testuser";
          ensurePermissions = {
            "testdb.*" = "ALL PRIVILEGES";
          };
        }];
        initialScript = pkgs.writeText "mariadb-init.sql" ''
          GRANT ALL PRIVILEGES ON *.* TO 'check_repl'@'localhost' IDENTIFIED BY 'check_pass' WITH GRANT OPTION;
          FLUSH PRIVILEGES;
        '';
        settings = {
          mysqld = {
            bind_address = "0.0.0.0";
          };
          galera = {
            wsrep_on = "ON";
            wsrep_debug = "NONE";
            wsrep_retry_autocommit = "3";
            wsrep_provider = "${pkgs.mariadb-galera}/lib/galera/libgalera_smm.so";
            wsrep_cluster_address = "gcomm://";
            wsrep_cluster_name = "galera";
            wsrep_node_address = "192.168.1.1";
            wsrep_node_name = "galera_01";
            wsrep_sst_method = "mariabackup";
            wsrep_sst_auth = "check_repl:check_pass";
            binlog_format = "ROW";
            enforce_storage_engine = "InnoDB";
            innodb_autoinc_lock_mode = "2";
          };
        };
      };
    };

    galera_02 =
      { pkgs, ... }:
      {
      networking = {
        interfaces.eth1 = {
          ipv4.addresses = [
            { address = "192.168.1.2"; prefixLength = 24; }
          ];
        };
        extraHosts = ''
          192.168.1.1 galera_01
          192.168.1.2 galera_02
          192.168.1.3 galera_03
        '';
        firewall.allowedTCPPorts = [ 3306 4444 4567 4568 ];
        firewall.allowedUDPPorts = [ 4567 ];
      };
      users.users.testuser = { isSystemUser = true; };
      systemd.services.mysql = with pkgs; {
        path = [ mysqlenv-common mysqlenv-mariabackup ];
      };
      services.mysql = {
        enable = true;
        package = pkgs.mariadb;
        settings = {
          mysqld = {
            bind_address = "0.0.0.0";
          };
          galera = {
            wsrep_on = "ON";
            wsrep_debug = "NONE";
            wsrep_retry_autocommit = "3";
            wsrep_provider = "${pkgs.mariadb-galera}/lib/galera/libgalera_smm.so";
            wsrep_cluster_address = "gcomm://galera_01,galera_02,galera_03";
            wsrep_cluster_name = "galera";
            wsrep_node_address = "192.168.1.2";
            wsrep_node_name = "galera_02";
            wsrep_sst_method = "mariabackup";
            wsrep_sst_auth = "check_repl:check_pass";
            binlog_format = "ROW";
            enforce_storage_engine = "InnoDB";
            innodb_autoinc_lock_mode = "2";
          };
        };
      };
    };

    galera_03 =
      { pkgs, ... }:
      {
      networking = {
        interfaces.eth1 = {
          ipv4.addresses = [
            { address = "192.168.1.3"; prefixLength = 24; }
          ];
        };
        extraHosts = ''
          192.168.1.1 galera_01
          192.168.1.2 galera_02
          192.168.1.3 galera_03
        '';
        firewall.allowedTCPPorts = [ 3306 4444 4567 4568 ];
        firewall.allowedUDPPorts = [ 4567 ];
      };
      users.users.testuser = { isSystemUser = true; };
      systemd.services.mysql = with pkgs; {
        path = [ mysqlenv-common mysqlenv-mariabackup ];
      };
      services.mysql = {
        enable = true;
        package = pkgs.mariadb;
        settings = {
          mysqld = {
            bind_address = "0.0.0.0";
          };
          galera = {
            wsrep_on = "ON";
            wsrep_debug = "NONE";
            wsrep_retry_autocommit = "3";
            wsrep_provider = "${pkgs.mariadb-galera}/lib/galera/libgalera_smm.so";
            wsrep_cluster_address = "gcomm://galera_01,galera_02,galera_03";
            wsrep_cluster_name = "galera";
            wsrep_node_address = "192.168.1.3";
            wsrep_node_name = "galera_03";
            wsrep_sst_method = "mariabackup";
            wsrep_sst_auth = "check_repl:check_pass";
            binlog_format = "ROW";
            enforce_storage_engine = "InnoDB";
            innodb_autoinc_lock_mode = "2";
          };
        };
      };
    };
  };

  testScript = ''
    galera_01.start()
    galera_01.wait_for_unit("mysql")
    galera_01.wait_for_open_port(3306)
    galera_01.succeed(
        "sudo -u testuser mysql -u testuser -e 'use testdb; create table db1 (test_id INT, PRIMARY KEY (test_id)) ENGINE = InnoDB;'"
    )
    galera_01.succeed(
        "sudo -u testuser mysql -u testuser -e 'use testdb; insert into db1 values (37);'"
    )
    galera_02.start()
    galera_02.wait_for_unit("mysql")
    galera_02.wait_for_open_port(3306)
    galera_03.start()
    galera_03.wait_for_unit("mysql")
    galera_03.wait_for_open_port(3306)
    galera_02.succeed(
        "sudo -u testuser mysql -u testuser -e 'use testdb; select test_id from db1;' -N | grep 37"
    )
    galera_02.succeed(
        "sudo -u testuser mysql -u testuser -e 'use testdb; create table db2 (test_id INT, PRIMARY KEY (test_id)) ENGINE = InnoDB;'"
    )
    galera_02.succeed("systemctl stop mysql")
    galera_01.succeed(
        "sudo -u testuser mysql -u testuser -e 'use testdb; insert into db2 values (38);'"
    )
    galera_03.succeed(
        "sudo -u testuser mysql -u testuser -e 'use testdb; create table db3 (test_id INT, PRIMARY KEY (test_id)) ENGINE = InnoDB;'"
    )
    galera_01.succeed(
        "sudo -u testuser mysql -u testuser -e 'use testdb; insert into db3 values (39);'"
    )
    galera_02.succeed("systemctl start mysql")
    galera_02.wait_for_open_port(3306)
    galera_02.succeed(
        "sudo -u testuser mysql -u testuser -e 'show status' -N | grep 'wsrep_cluster_size.*3'"
    )
    galera_03.succeed(
        "sudo -u testuser mysql -u testuser -e 'show status' -N | grep 'wsrep_local_state_comment.*Synced'"
    )
    galera_01.succeed(
        "sudo -u testuser mysql -u testuser -e 'use testdb; select test_id from db3;' -N | grep 39"
    )
    galera_02.succeed(
        "sudo -u testuser mysql -u testuser -e 'use testdb; select test_id from db2;' -N | grep 38"
    )
    galera_03.succeed(
        "sudo -u testuser mysql -u testuser -e 'use testdb; select test_id from db1;' -N | grep 37"
    )
    galera_01.succeed("sudo -u testuser mysql -u testuser -e 'use testdb; drop table db3;'")
    galera_02.succeed("sudo -u testuser mysql -u testuser -e 'use testdb; drop table db2;'")
    galera_03.succeed("sudo -u testuser mysql -u testuser -e 'use testdb; drop table db1;'")
  '';
})
