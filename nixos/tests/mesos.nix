import ./make-test.nix ({ pkgs, ...} : {
  name = "simple";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ offline ];
  };

  machine = { config, pkgs, ... }: {
    services.zookeeper.enable = true;
    virtualisation.docker.enable = true;
    services.mesos = {
      slave = {
        enable = true;
        master = "zk://localhost:2181/mesos";
        attributes = {
          tag1 = "foo";
          tag2 = "bar";
        };
      };
      master = {
        enable = true;
        zk = "zk://localhost:2181/mesos";
      };
    };
  };

  testScript =
    ''
      startAll;
      $machine->waitForUnit("mesos-master.service");
      $machine->waitForUnit("mesos-slave.service");
    '';
})
