import ./make-test.nix ({ pkgs, ...} : rec {
  name = "mesos";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ offline kamilchm ];
  };

  nodes = {
    master = { config, pkgs, ... }: {
      networking.firewall.enable = false;
      services.zookeeper.enable = true;
      services.mesos.master = {
          enable = true;
          zk = "zk://master:2181/mesos";
      };
    };

    slave = { config, pkgs, ... }: {
      networking.firewall.enable = false;
      networking.nat.enable = true;
      virtualisation.docker.enable = true;
      services.mesos = {
        slave = {
          enable = true;
          master = "master:5050";
        };
      };
    };
  };

  simpleDocker = pkgs.dockerTools.buildImage {
    name = "echo";
    contents = pkgs.coreutils;
    config = {
      Entrypoint = [ "${pkgs.coreutils}/bin/echo" ];
    };
  };

  testFramework = pkgs.pythonPackages.buildPythonPackage {
    name = "mesos-tests";
    propagatedBuildInputs = [ pkgs.mesos ];
    catchConflicts = false;
    src = ./mesos_test.py;
    phases = [ "installPhase" "fixupPhase" ];
    installPhase = ''
      mkdir $out
      cp $src $out/mesos_test.py
      chmod +x $out/mesos_test.py

      echo "done" > test.result
      tar czf $out/test.tar.gz test.result
    '';
  };

  testScript =
    ''
      startAll;
      $master->waitForUnit("mesos-master.service");
      $slave->waitForUnit("mesos-slave.service");

      $master->waitForOpenPort(5050);
      $slave->waitForOpenPort(5051);

      # is slave registred? 
      $master->waitUntilSucceeds("curl -s --fail http://master:5050/master/slaves".
                                 " | grep -q \"\\\"hostname\\\":\\\"slave\\\"\"");

      # try to run docker image 
      $slave->succeed("docker load < ${simpleDocker}");
      $master->succeed("${pkgs.mesos}/bin/mesos-execute --master=master:5050".
                       " --resources=\"cpus:0.1;mem:32\" --name=simple-docker".
                       " --containerizer=docker --docker_image=echo".
                       " --shell=false --command=\"done\" | grep -q TASK_FINISHED");

      # simple command with .tar.gz uri
      $master->succeed("${testFramework}/mesos_test.py master ".
                       "${testFramework}/test.tar.gz");
    '';
})
