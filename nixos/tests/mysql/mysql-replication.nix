{
  system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../../.. { inherit system config; },
  lib ? pkgs.lib
}:

let
  inherit (import ./common.nix { inherit pkgs lib; }) mkTestName mariadbPackages;

  replicateUser = "replicate";
  replicatePassword = "secret";

  makeTest = import ./../make-test-python.nix;

  makeReplicationTest = {
    package,
    name ? mkTestName package,
  }: makeTest {
    name = "${name}-replication";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ ajs124 das_j ];
    };

    nodes = {
      primary = {
        services.mysql = {
          inherit package;
          enable = true;
          replication.role = "master";
          replication.slaveHost = "%";
          replication.masterUser = replicateUser;
          replication.masterPassword = replicatePassword;
          initialDatabases = [ { name = "testdb"; schema = ./testdb.sql; } ];
        };
        networking.firewall.allowedTCPPorts = [ 3306 ];
      };

      secondary1 = { nodes, ... }: {
        services.mysql = {
          inherit package;
          enable = true;
          replication.role = "slave";
          replication.serverId = 2;
          replication.masterHost = nodes.primary.config.networking.hostName;
          replication.masterUser = replicateUser;
          replication.masterPassword = replicatePassword;
        };
      };

      secondary2 = { nodes, ... }: {
        services.mysql = {
          inherit package;
          enable = true;
          replication.role = "slave";
          replication.serverId = 3;
          replication.masterHost = nodes.primary.config.networking.hostName;
          replication.masterUser = replicateUser;
          replication.masterPassword = replicatePassword;
        };
      };
    };

    testScript = ''
      primary.start()
      primary.wait_for_unit("mysql")
      primary.wait_for_open_port(3306)
      # Wait for testdb to be fully populated (5 rows).
      primary.wait_until_succeeds(
          "sudo -u mysql mysql -u mysql -D testdb -N -B -e 'select count(id) from tests' | grep -q 5"
      )

      secondary1.start()
      secondary2.start()
      secondary1.wait_for_unit("mysql")
      secondary1.wait_for_open_port(3306)
      secondary2.wait_for_unit("mysql")
      secondary2.wait_for_open_port(3306)

      # wait for replications to finish
      secondary1.wait_until_succeeds(
          "sudo -u mysql mysql -u mysql -D testdb -N -B -e 'select count(id) from tests' | grep -q 5"
      )
      secondary2.wait_until_succeeds(
          "sudo -u mysql mysql -u mysql -D testdb -N -B -e 'select count(id) from tests' | grep -q 5"
      )

      secondary2.succeed("systemctl stop mysql")
      primary.succeed(
          "echo 'insert into testdb.tests values (123, 456);' | sudo -u mysql mysql -u mysql -N"
      )
      secondary2.succeed("systemctl start mysql")
      secondary2.wait_for_unit("mysql")
      secondary2.wait_for_open_port(3306)
      secondary2.wait_until_succeeds(
          "echo 'select * from testdb.tests where Id = 123;' | sudo -u mysql mysql -u mysql -N | grep 456"
      )
    '';
  };
in
  lib.mapAttrs (_: package: makeReplicationTest { inherit package; }) mariadbPackages
