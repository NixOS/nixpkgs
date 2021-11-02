# Test a minimal HDFS cluster with no HA
import ../make-test-python.nix ({...}: {
  nodes = {
    namenode = {pkgs, ...}: {
      services.hadoop = {
        package = pkgs.hadoop;
        hdfs.namenode = {
          enabled = true;
          formatOnInit = true;
        };
        coreSite = {
          "fs.defaultFS" = "hdfs://namenode:8020";
        };
        hdfsSite = {
          "dfs.replication" = 1;
          "dfs.namenode.rpc-bind-host" = "0.0.0.0";
          "dfs.namenode.http-bind-host" = "0.0.0.0";
        };
      };
    };
    datanode = {pkgs, ...}: {
      services.hadoop = {
        package = pkgs.hadoop;
        hdfs.datanode.enabled = true;
        coreSite = {
          "fs.defaultFS" = "hdfs://namenode:8020";
        };
      };
    };
  };

  testScript = ''
    start_all()

    namenode.wait_for_unit("hdfs-namenode")
    namenode.wait_for_unit("network.target")
    namenode.wait_for_open_port(8020)
    namenode.wait_for_open_port(9870)

    datanode.wait_for_unit("hdfs-datanode")
    datanode.wait_for_unit("network.target")
    datanode.wait_for_open_port(9864)
    datanode.wait_for_open_port(9866)
    datanode.wait_for_open_port(9867)

    namenode.succeed("curl -f http://namenode:9870")
    datanode.succeed("curl -f http://datanode:9864")

    datanode.succeed("sudo -u hdfs hdfs dfsadmin -safemode wait")
    datanode.succeed("echo testfilecontents | sudo -u hdfs hdfs dfs -put - /testfile")
    assert "testfilecontents" in datanode.succeed("sudo -u hdfs hdfs dfs -cat /testfile")
  '';
})
