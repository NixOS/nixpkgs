# Test a minimal hbase cluster
{ pkgs, ... }:
import ../make-test-python.nix (
  {
    hadoop ? pkgs.hadoop,
    hbase ? pkgs.hbase,
    ...
  }:
  with pkgs.lib;
  {
    name = "hadoop-hbase";

    nodes =
      let
        coreSite = {
          "fs.defaultFS" = "hdfs://namenode:8020";
        };
        defOpts = {
          enable = true;
          openFirewall = true;
        };
        zookeeperQuorum = "zookeeper";
      in
      {
        zookeeper =
          { ... }:
          {
            services.zookeeper.enable = true;
            networking.firewall.allowedTCPPorts = [ 2181 ];
          };
        namenode =
          { ... }:
          {
            services.hadoop = {
              hdfs = {
                namenode = defOpts // {
                  formatOnInit = true;
                };
              };
              inherit coreSite;
            };
          };
        datanode =
          { ... }:
          {
            virtualisation.diskSize = 8192;
            services.hadoop = {
              hdfs.datanode = defOpts;
              inherit coreSite;
            };
          };

        master =
          { ... }:
          {
            services.hadoop = {
              inherit coreSite;
              hbase = {
                inherit zookeeperQuorum;
                master = defOpts // {
                  initHDFS = true;
                };
              };
            };
          };
        regionserver =
          { ... }:
          {
            services.hadoop = {
              inherit coreSite;
              hbase = {
                inherit zookeeperQuorum;
                regionServer = defOpts;
              };
            };
          };
        thrift =
          { ... }:
          {
            services.hadoop = {
              inherit coreSite;
              hbase = {
                inherit zookeeperQuorum;
                thrift = defOpts;
              };
            };
          };
        rest =
          { ... }:
          {
            services.hadoop = {
              inherit coreSite;
              hbase = {
                inherit zookeeperQuorum;
                rest = defOpts;
              };
            };
          };
      };

    testScript = ''
      start_all()

      # wait for HDFS cluster
      namenode.wait_for_unit("hdfs-namenode")
      namenode.wait_for_unit("network.target")
      namenode.wait_for_open_port(8020)
      namenode.wait_for_open_port(9870)
      datanode.wait_for_unit("hdfs-datanode")
      datanode.wait_for_unit("network.target")
      datanode.wait_for_open_port(9864)
      datanode.wait_for_open_port(9866)
      datanode.wait_for_open_port(9867)

      # wait for ZK
      zookeeper.wait_for_unit("zookeeper")
      zookeeper.wait_for_open_port(2181)

      # wait for HBase to start up
      master.wait_for_unit("hbase-master")
      regionserver.wait_for_unit("hbase-regionserver")

      assert "1 active master, 0 backup masters, 1 servers" in master.succeed("echo status | HADOOP_USER_NAME=hbase hbase shell -n")
      regionserver.wait_until_succeeds("echo \"create 't1','f1'\" | HADOOP_USER_NAME=hbase hbase shell -n")
      assert "NAME => 'f1'" in regionserver.succeed("echo \"describe 't1'\" | HADOOP_USER_NAME=hbase hbase shell -n")

      rest.wait_for_open_port(8080)
      assert "${hbase.version}" in regionserver.succeed("curl http://rest:8080/version/cluster")

      thrift.wait_for_open_port(9090)
    '';

    meta.maintainers = with maintainers; [ illustris ];
  }
)
