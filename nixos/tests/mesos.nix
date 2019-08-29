import ./make-test.nix ({ pkgs, ...} : rec {
  name = "mesos";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ offline kamilchm cstrahan ];
  };

  nodes = {
    master = { ... }: {
      networking.firewall.enable = false;
      services.zookeeper.enable = true;
      services.mesos.master = {
          enable = true;
          zk = "zk://master:2181/mesos";
      };
    };

    slave = { ... }: {
      networking.firewall.enable = false;
      networking.nat.enable = true;
      virtualisation.docker.enable = true;
      services.mesos = {
        slave = {
          enable = true;
          master = "master:5050";
          dockerRegistry = registry;
          executorEnvironmentVariables = {
            PATH = "/run/current-system/sw/bin";
          };
        };
      };
    };
  };

  simpleDocker = pkgs.dockerTools.buildImage {
    name = "echo";
    tag = "latest";
    contents = [ pkgs.stdenv.shellPackage pkgs.coreutils ];
    config = {
      Env = [
        # When shell=true, mesos invokes "sh -c '<cmd>'", so make sure "sh" is
        # on the PATH.
        "PATH=${pkgs.stdenv.shellPackage}/bin:${pkgs.coreutils}/bin"
      ];
      Entrypoint = [ "echo" ];
    };
  };

  registry = pkgs.runCommand "registry" { } ''
    mkdir -p $out
    cp ${simpleDocker} $out/echo:latest.tar
  '';

  testFramework = pkgs.pythonPackages.buildPythonPackage {
    name = "mesos-tests";
    propagatedBuildInputs = [ pkgs.mesos ];
    catchConflicts = false;
    src = ./mesos_test.py;
    phases = [ "installPhase" "fixupPhase" ];
    installPhase = ''
      install -Dvm 0755 $src $out/bin/mesos_test.py

      echo "done" > test.result
      tar czf $out/test.tar.gz test.result
    '';
  };

  testScript =
    ''
      startAll;
      $master->waitForUnit("zookeeper.service");
      $master->waitForUnit("mesos-master.service");
      $slave->waitForUnit("docker.service");
      $slave->waitForUnit("mesos-slave.service");
      $master->waitForOpenPort(2181);
      $master->waitForOpenPort(5050);
      $slave->waitForOpenPort(5051);

      # is slave registered?
      $master->waitUntilSucceeds("curl -s --fail http://master:5050/master/slaves".
                                 " | grep -q \"\\\"hostname\\\":\\\"slave\\\"\"");

      # try to run docker image
      $master->succeed("${pkgs.mesos}/bin/mesos-execute --master=master:5050".
                       " --resources=\"cpus:0.1;mem:32\" --name=simple-docker".
                       " --containerizer=mesos --docker_image=echo:latest".
                       " --shell=true --command=\"echo done\" | grep -q TASK_FINISHED");

      # simple command with .tar.gz uri
      $master->succeed("${testFramework}/bin/mesos_test.py master ".
                       "${testFramework}/test.tar.gz");
    '';
})
