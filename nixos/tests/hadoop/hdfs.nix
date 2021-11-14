# Test a minimal HDFS cluster with no HA
import ../make-test-python.nix ({...}: {
  nodes = {
    namenode = {pkgs, ...}: {
      virtualisation.memorySize = 1024;
      services.hadoop = {
        package = pkgs.hadoop;
        hdfs = {
          namenode = {
            enable = true;
            formatOnInit = true;
          };
          httpfs.enable = true;
        };
        coreSite = {
          "fs.defaultFS" = "hdfs://namenode:8020";
          "hadoop.proxyuser.httpfs.groups" = "*";
          "hadoop.proxyuser.httpfs.hosts" = "*";
        };
      };
    };
    datanode = {pkgs, ...}: {
      services.hadoop = {
        package = pkgs.hadoop;
        hdfs.datanode.enable = true;
        coreSite = {
          "fs.defaultFS" = "hdfs://namenode:8020";
          "hadoop.proxyuser.httpfs.groups" = "*";
          "hadoop.proxyuser.httpfs.hosts" = "*";
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

    namenode.wait_for_unit("hdfs-httpfs")
    namenode.wait_for_open_port(14000)
    assert "testfilecontents" in datanode.succeed("curl -f \"http://namenode:14000/webhdfs/v1/testfile?user.name=hdfs&op=OPEN\" 2>&1")
  '';
})
