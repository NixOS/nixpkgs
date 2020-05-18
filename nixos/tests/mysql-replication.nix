import ./make-test-python.nix ({ pkgs, ...} :

let
  replicateUser = "replicate";
  replicatePassword = "secret";
in

{
  name = "mysql-replication";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ eelco shlevy ];
  };

  nodes = {
    master =
      { pkgs, ... }:

      {
        services.mysql.enable = true;
        services.mysql.package = pkgs.mysql;
        services.mysql.replication.role = "master";
        services.mysql.replication.slaveHost = "%";
        services.mysql.replication.masterUser = replicateUser;
        services.mysql.replication.masterPassword = replicatePassword;
        services.mysql.initialDatabases = [ { name = "testdb"; schema = ./testdb.sql; } ];
        networking.firewall.allowedTCPPorts = [ 3306 ];
      };

    slave1 =
      { pkgs, nodes, ... }:

      {
        services.mysql.enable = true;
        services.mysql.package = pkgs.mysql;
        services.mysql.replication.role = "slave";
        services.mysql.replication.serverId = 2;
        services.mysql.replication.masterHost = nodes.master.config.networking.hostName;
        services.mysql.replication.masterUser = replicateUser;
        services.mysql.replication.masterPassword = replicatePassword;
      };

    slave2 =
      { pkgs, nodes, ... }:

      {
        services.mysql.enable = true;
        services.mysql.package = pkgs.mysql;
        services.mysql.replication.role = "slave";
        services.mysql.replication.serverId = 3;
        services.mysql.replication.masterHost = nodes.master.config.networking.hostName;
        services.mysql.replication.masterUser = replicateUser;
        services.mysql.replication.masterPassword = replicatePassword;
      };
  };

  testScript = ''
    master.start()
    master.wait_for_unit("mysql")
    master.wait_for_open_port(3306)
    # Wait for testdb to be fully populated (5 rows).
    master.wait_until_succeeds(
        "mysql -u root -D testdb -N -B -e 'select count(id) from tests' | grep -q 5"
    )

    slave1.start()
    slave2.start()
    slave1.wait_for_unit("mysql")
    slave1.wait_for_open_port(3306)
    slave2.wait_for_unit("mysql")
    slave2.wait_for_open_port(3306)

    # wait for replications to finish
    slave1.wait_until_succeeds(
        "mysql -u root -D testdb -N -B -e 'select count(id) from tests' | grep -q 5"
    )
    slave2.wait_until_succeeds(
        "mysql -u root -D testdb -N -B -e 'select count(id) from tests' | grep -q 5"
    )

    slave2.succeed("systemctl stop mysql")
    master.succeed("echo 'insert into testdb.tests values (123, 456);' | mysql -u root -N")
    slave2.succeed("systemctl start mysql")
    slave2.wait_for_unit("mysql")
    slave2.wait_for_open_port(3306)
    slave2.wait_until_succeeds(
        "echo 'select * from testdb.tests where Id = 123;' | mysql -u root -N | grep 456"
    )
  '';
})
