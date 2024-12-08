{ pkgs, ... }:

let
  inherit (pkgs) lib;
  tests = {
    default = testsForPackage { sparkPackage = pkgs.spark; };
  };

  testsForPackage = args: lib.recurseIntoAttrs {
    sparkCluster = testSparkCluster args;
    passthru.override = args': testsForPackage (args // args');
  };
  testSparkCluster = { sparkPackage, ... }: pkgs.testers.nixosTest ({
    name = "spark";

    nodes = {
      worker = { nodes, pkgs, ... }: {
        services.spark = {
          package = sparkPackage;
          worker = {
            enable = true;
            master = "master:7077";
          };
        };
        virtualisation.memorySize = 2048;
      };
      master = { config, pkgs, ... }: {
        services.spark = {
          package = sparkPackage;
          master = {
            enable = true;
            bind = "0.0.0.0";
          };
        };
        networking.firewall.allowedTCPPorts = [ 22 7077 8080 ];
      };
    };

    testScript = ''
      master.wait_for_unit("spark-master.service")
      worker.wait_for_unit("spark-worker.service")
      worker.copy_from_host( "${./spark_sample.py}", "/spark_sample.py" )
      assert "<title>Spark Master at spark://" in worker.succeed("curl -sSfkL http://master:8080/")
      worker.succeed("spark-submit --version | systemd-cat")
      worker.succeed("spark-submit --master spark://master:7077 --executor-memory 512m --executor-cores 1 /spark_sample.py")
    '';
  });
in tests
