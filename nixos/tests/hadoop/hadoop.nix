import ../make-test-python.nix ({pkgs, ...}: {

  nodes = let
    package = pkgs.hadoop;
    coreSite = {
      "fs.defaultFS" = "hdfs://master";
    };
  in {
    master = {pkgs, options, ...}: {
      services.hadoop = {
        inherit package coreSite;
        hdfs.namenode.enabled = true;
        yarn.resourcemanager.enabled = true;
      };
      virtualisation.memorySize = 1024;
    };

    worker = {pkgs, options, ...}: {
      services.hadoop = {
        inherit package coreSite;
        hdfs.datanode.enabled = true;
        yarn.nodemanager.enabled = true;
        yarnSite = options.services.hadoop.yarnSite.default // {
          "yarn.resourcemanager.hostname" = "master";
        };
      };
      virtualisation.memorySize = 2048;
    };
  };

  testScript = ''
    start_all()

    master.wait_for_unit("network.target")
    master.wait_for_unit("hdfs-namenode")

    master.wait_for_open_port(8020)
    master.wait_for_open_port(9870)

    worker.wait_for_unit("network.target")
    worker.wait_for_unit("hdfs-datanode")
    worker.wait_for_open_port(9864)
    worker.wait_for_open_port(9866)
    worker.wait_for_open_port(9867)

    master.succeed("curl -f http://worker:9864")
    worker.succeed("curl -f http://master:9870")

    worker.succeed("sudo -u hdfs hdfs dfsadmin -safemode wait")

    master.wait_for_unit("yarn-resourcemanager")

    master.wait_for_open_port(8030)
    master.wait_for_open_port(8031)
    master.wait_for_open_port(8032)
    master.wait_for_open_port(8088)
    worker.succeed("curl -f http://master:8088")

    worker.wait_for_unit("yarn-nodemanager")
    worker.wait_for_open_port(8042)
    worker.wait_for_open_port(8040)
    master.succeed("curl -f http://worker:8042")

    assert "Total Nodes:1" in worker.succeed("yarn node -list")

    assert "Estimated value of Pi is" in worker.succeed("HADOOP_USER_NAME=hdfs yarn jar $(readlink $(which yarn) | sed -r 's~bin/yarn~lib/hadoop-*/share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar~g') pi 2 10")
    assert "SUCCEEDED" in worker.succeed("yarn application -list -appStates FINISHED")
    worker.succeed("sudo -u hdfs hdfs dfs -ls / | systemd-cat")
  '';
 })
