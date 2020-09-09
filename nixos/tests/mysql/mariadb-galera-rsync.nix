import ./../make-test-python.nix ({ pkgs, ...} :

let
  mysqlenv-common      = pkgs.buildEnv { name = "mysql-path-env-common";      pathsToLink = [ "/bin" ]; paths = with pkgs; [ bash gawk gnutar inetutils which ]; };
  mysqlenv-rsync       = pkgs.buildEnv { name = "mysql-path-env-rsync";       pathsToLink = [ "/bin" ]; paths = with pkgs; [ lsof procps rsync stunnel ]; };

in {
  name = "mariadb-galera-rsync";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ izorkin ];
  };

  # The test creates a Galera cluster with 3 nodes and is checking if rsync-based SST works. The cluster is tested by creating a DB and an empty table on one node,
  # and checking the table's presence on the other node.

  nodes = {
    galera_04 =
      { pkgs, ... }:
      {
      networking = {
        interfaces.eth1 = {
          ipv4.addresses = [
            { address = "192.168.2.1"; prefixLength = 24; }
          ];
        };
        extraHosts = ''
          192.168.2.1 galera_04
          192.168.2.2 galera_05
          192.168.2.3 galera_06
        '';
        firewall.allowedTCPPorts = [ 3306 4444 4567 4568 ];
        firewall.allowedUDPPorts = [ 4567 ];
      };
      users.users.testuser = { };
      systemd.services.mysql = with pkgs; {
        path = [ mysqlenv-common mysqlenv-rsync ];
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
            wsrep_cluster_name = "galera-rsync";
            wsrep_node_address = "192.168.2.1";
            wsrep_node_name = "galera_04";
            wsrep_sst_method = "rsync";
            binlog_format = "ROW";
            enforce_storage_engine = "InnoDB";
            innodb_autoinc_lock_mode = "2";
          };
        };
      };
    };

    galera_05 =
      { pkgs, ... }:
      {
      networking = {
        interfaces.eth1 = {
          ipv4.addresses = [
            { address = "192.168.2.2"; prefixLength = 24; }
          ];
        };
        extraHosts = ''
          192.168.2.1 galera_04
          192.168.2.2 galera_05
          192.168.2.3 galera_06
        '';
        firewall.allowedTCPPorts = [ 3306 4444 4567 4568 ];
        firewall.allowedUDPPorts = [ 4567 ];
      };
      users.users.testuser = { };
      systemd.services.mysql = with pkgs; {
        path = [ mysqlenv-common mysqlenv-rsync ];
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
            wsrep_cluster_address = "gcomm://galera_04,galera_05,galera_06";
            wsrep_cluster_name = "galera-rsync";
            wsrep_node_address = "192.168.2.2";
            wsrep_node_name = "galera_05";
            wsrep_sst_method = "rsync";
            binlog_format = "ROW";
            enforce_storage_engine = "InnoDB";
            innodb_autoinc_lock_mode = "2";
          };
        };
      };
    };

    galera_06 =
      { pkgs, ... }:
      {
      networking = {
        interfaces.eth1 = {
          ipv4.addresses = [
            { address = "192.168.2.3"; prefixLength = 24; }
          ];
        };
        extraHosts = ''
          192.168.2.1 galera_04
          192.168.2.2 galera_05
          192.168.2.3 galera_06
        '';
        firewall.allowedTCPPorts = [ 3306 4444 4567 4568 ];
        firewall.allowedUDPPorts = [ 4567 ];
      };
      users.users.testuser = { };
      systemd.services.mysql = with pkgs; {
        path = [ mysqlenv-common mysqlenv-rsync ];
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
            wsrep_cluster_address = "gcomm://galera_04,galera_05,galera_06";
            wsrep_cluster_name = "galera-rsync";
            wsrep_node_address = "192.168.2.3";
            wsrep_node_name = "galera_06";
            wsrep_sst_method = "rsync";
            binlog_format = "ROW";
            enforce_storage_engine = "InnoDB";
            innodb_autoinc_lock_mode = "2";
          };
        };
      };
    };
  };

  testScript = ''
    galera_04.start()
    galera_04.wait_for_unit("mysql")
    galera_04.wait_for_open_port(3306)
    galera_04.succeed(
        "sudo -u testuser mysql -u testuser -e 'use testdb; create table db1 (test_id INT, PRIMARY KEY (test_id)) ENGINE = InnoDB;'"
    )
    galera_04.succeed(
        "sudo -u testuser mysql -u testuser -e 'use testdb; insert into db1 values (41);'"
    )
    galera_05.start()
    galera_05.wait_for_unit("mysql")
    galera_05.wait_for_open_port(3306)
    galera_06.start()
    galera_06.wait_for_unit("mysql")
    galera_06.wait_for_open_port(3306)
    galera_05.succeed(
        "sudo -u testuser mysql -u testuser -e 'use testdb; select test_id from db1;' -N | grep 41"
    )
    galera_05.succeed(
        "sudo -u testuser mysql -u testuser -e 'use testdb; create table db2 (test_id INT, PRIMARY KEY (test_id)) ENGINE = InnoDB;'"
    )
    galera_05.succeed("systemctl stop mysql")
    galera_04.succeed(
        "sudo -u testuser mysql -u testuser -e 'use testdb; insert into db2 values (42);'"
    )
    galera_06.succeed(
        "sudo -u testuser mysql -u testuser -e 'use testdb; create table db3 (test_id INT, PRIMARY KEY (test_id)) ENGINE = InnoDB;'"
    )
    galera_04.succeed(
        "sudo -u testuser mysql -u testuser -e 'use testdb; insert into db3 values (43);'"
    )
    galera_05.succeed("systemctl start mysql")
    galera_05.wait_for_open_port(3306)
    galera_05.succeed(
        "sudo -u testuser mysql -u testuser -e 'show status' -N | grep 'wsrep_cluster_size.*3'"
    )
    galera_06.succeed(
        "sudo -u testuser mysql -u testuser -e 'show status' -N | grep 'wsrep_local_state_comment.*Synced'"
    )
    galera_04.succeed(
        "sudo -u testuser mysql -u testuser -e 'use testdb; select test_id from db3;' -N | grep 43"
    )
    galera_05.succeed(
        "sudo -u testuser mysql -u testuser -e 'use testdb; select test_id from db2;' -N | grep 42"
    )
    galera_06.succeed(
        "sudo -u testuser mysql -u testuser -e 'use testdb; select test_id from db1;' -N | grep 41"
    )
    galera_04.succeed("sudo -u testuser mysql -u testuser -e 'use testdb; drop table db3;'")
    galera_05.succeed("sudo -u testuser mysql -u testuser -e 'use testdb; drop table db2;'")
    galera_06.succeed("sudo -u testuser mysql -u testuser -e 'use testdb; drop table db1;'")
  '';
})
