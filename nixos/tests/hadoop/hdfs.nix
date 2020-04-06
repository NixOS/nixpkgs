import ../make-test-python.nix ({...}: {
  nodes = {
    namenode = {pkgs, ...}: {
      services.hadoop = {
        package = pkgs.hadoop_3_1;
        hdfs.namenode.enabled = true;
        coreSite = {
          "fs.defaultFS" = "hdfs://namenode:8020";
        };
        hdfsSite = {
          "dfs.replication" = 1;
          "dfs.namenode.rpc-bind-host" = "0.0.0.0";
          "dfs.namenode.http-bind-host" = "0.0.0.0";
        };
      };
      networking.firewall.allowedTCPPorts = [
        9870 # namenode.http-address
        8020 # namenode.rpc-address
      ];
    };
    datanode = {pkgs, ...}: {
      services.hadoop = {
        package = pkgs.hadoop_3_1;
        hdfs.datanode.enabled = true;
        coreSite = {
          "fs.defaultFS" = "hdfs://namenode:8020";
        };
      };
      networking.firewall.allowedTCPPorts = [
        9864 # datanode.http.address
        9866 # datanode.address
        9867 # datanode.ipc.address
      ];
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

    namenode.succeed("curl http://namenode:9870")
    datanode.succeed("curl http://datanode:9864")
  '';
})
