{ pkgs, ... }:

let
  replicateUser = "replicate";
  replicatePassword = "secret";
in
{
  nodes = {
    master =
      { pkgs, config, ... }:

      {
        services.mysql.enable = true;
	services.mysql.replication.role = "master";
	services.mysql.initialDatabases = [ { name = "testdb"; schema = ./testdb.sql; } ];
	services.mysql.initialScript = pkgs.writeText "initmysql"
        ''
	  create user '${replicateUser}'@'%' identified by '${replicatePassword}';
          grant replication slave on *.* to '${replicateUser}'@'%';
        '';
      };

    slave1 =
      { pkgs, config, nodes, ... }:

      {
        services.mysql.enable = true;
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
	services.mysql.replication.role = "slave";
	services.mysql.replication.serverId = 3;
	services.mysql.replication.masterHost = nodes.master.config.networking.hostName;
	services.mysql.replication.masterUser = replicateUser;
	services.mysql.replication.masterPassword = replicatePassword;
      };
  };

  testScript = ''
    startAll;

    $master->waitForUnit("mysql");
    $master->waitForUnit("mysql");
    $slave2->waitForUnit("mysql");
    $slave2->sleep(100); # Hopefully this is long enough!!
    $slave2->succeed("echo 'use testdb; select * from tests' | mysql -u root -N | grep 4");
  '';
}
