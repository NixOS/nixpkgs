{
  system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../../.. { inherit system config; },
  lib ? pkgs.lib
}:

let
  inherit (import ./common.nix { inherit pkgs lib; }) mkTestName mariadbPackages;

  makeTest = import ./../make-test-python.nix;

  # Common user configuration
  makeGaleraTest = {
    mariadbPackage,
    name ? mkTestName mariadbPackage,
    galeraPackage ? pkgs.mariadb-galera
  }: makeTest {
    name = "${name}-galera-mariabackup";
    meta = {
      maintainers = with lib.maintainers; [ izorkin ] ++ lib.teams.helsinki-systems.members;
    };

    # The test creates a Galera cluster with 3 nodes and is checking if mariabackup-based SST works. The cluster is tested by creating a DB and an empty table on one node,
    # and checking the table's presence on the other node.
    nodes = let
      mkGaleraNode = {
        id,
        method
      }: let
        address = "192.168.1.${toString id}";
        isFirstClusterNode = id == 1 || id == 4;
      in {
        users = {
          users.testuser = {
            isSystemUser = true;
            group = "testusers";
          };
          groups.testusers = { };
        };

        networking = {
          interfaces.eth1 = {
            ipv4.addresses = [
              { inherit address; prefixLength = 24; }
            ];
          };
          extraHosts = lib.concatMapStringsSep "\n" (i: "192.168.1.${toString i} galera_0${toString i}") (lib.range 1 6);
          firewall.allowedTCPPorts = [ 3306 4444 4567 4568 ];
          firewall.allowedUDPPorts = [ 4567 ];
        };
        systemd.services.mysql = with pkgs; {
          path = with pkgs; [
            bash
            gawk
            gnutar
            gzip
            inetutils
            iproute2
            netcat
            procps
            pv
            rsync
            socat
            stunnel
            which
          ];
        };
        services.mysql = {
          enable = true;
          package = mariadbPackage;
          ensureDatabases = lib.mkIf isFirstClusterNode [ "testdb" ];
          ensureUsers = lib.mkIf isFirstClusterNode [{
            name = "testuser";
            ensurePermissions = {
              "testdb.*" = "ALL PRIVILEGES";
            };
          }];
          initialScript = lib.mkIf isFirstClusterNode (pkgs.writeText "mariadb-init.sql" ''
            GRANT ALL PRIVILEGES ON *.* TO 'check_repl'@'localhost' IDENTIFIED BY 'check_pass' WITH GRANT OPTION;
            FLUSH PRIVILEGES;
          '');
          settings = {
            mysqld = {
              bind_address = "0.0.0.0";
            };
            galera = {
              wsrep_on = "ON";
              wsrep_debug = "NONE";
              wsrep_retry_autocommit = "3";
              wsrep_provider = "${galeraPackage}/lib/galera/libgalera_smm.so";
              wsrep_cluster_address = "gcomm://"
                + lib.optionalString (id == 2 || id == 3) "galera_01,galera_02,galera_03"
                + lib.optionalString (id == 5 || id == 6) "galera_04,galera_05,galera_06";
              wsrep_cluster_name = "galera";
              wsrep_node_address = address;
              wsrep_node_name = "galera_0${toString id}";
              wsrep_sst_method = method;
              wsrep_sst_auth = "check_repl:check_pass";
              binlog_format = "ROW";
              enforce_storage_engine = "InnoDB";
              innodb_autoinc_lock_mode = "2";
            };
          };
        };
      };
    in {
      galera_01 = mkGaleraNode {
        id = 1;
        method = "mariabackup";
      };

      galera_02 = mkGaleraNode {
        id = 2;
        method = "mariabackup";
      };

      galera_03 = mkGaleraNode {
        id = 3;
        method = "mariabackup";
      };

      galera_04 = mkGaleraNode {
        id = 4;
        method = "rsync";
      };

      galera_05 = mkGaleraNode {
        id = 5;
        method = "rsync";
      };

      galera_06 = mkGaleraNode {
        id = 6;
        method = "rsync";
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
      galera_01.crash()
      galera_02.crash()
      galera_03.crash()

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
  };
in
  lib.mapAttrs (_: mariadbPackage: makeGaleraTest { inherit mariadbPackage; }) mariadbPackages
