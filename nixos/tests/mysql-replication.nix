import ./make-test.nix ({ pkgs, ...} :

let
  replicateUser = "replicate";
  replicatePassword = "secret";
in

{
  name = "mysql-replication";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ eelco chaoflow shlevy ];
  };

  nodes = {
    master =
      { pkgs, config, ... }:

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
      { pkgs, config, nodes, ... }:

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
      { pkgs, config, nodes, ... }:

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
    $master->start;
    $master->waitForUnit("mysql");
    $master->waitForOpenPort(3306);
    $slave1->start;
    $slave2->start;
    $slave1->waitForUnit("mysql");
    $slave1->waitForOpenPort(3306);
    $slave2->waitForUnit("mysql");
    $slave2->waitForOpenPort(3306);
    $slave2->succeed("echo 'use testdb; select * from tests' | mysql -u root -N | grep 4");
    $slave2->succeed("systemctl stop mysql");
    $master->succeed("echo 'insert into testdb.tests values (123, 456);' | mysql -u root -N");
    $slave2->succeed("systemctl start mysql");
    $slave2->waitForUnit("mysql");
    $slave2->waitForOpenPort(3306);
    $slave2->succeed("echo 'select * from testdb.tests where Id = 123;' | mysql -u root -N | grep 456");
  '';
})
