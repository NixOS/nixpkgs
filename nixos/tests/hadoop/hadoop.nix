# This test is very comprehensive. It tests whether all hadoop services work well with each other.
# Run this when updating the Hadoop package or making significant changes to the hadoop module.
# For a more basic test, see hdfs.nix and yarn.nix
import ../make-test-python.nix ({ package, ... }: {
  name = "hadoop-combined";

  nodes =
    let
      coreSite = {
        "fs.defaultFS" = "hdfs://ns1";
      };
      hdfsSite = {
        # HA Quorum Journal Manager configuration
        "dfs.nameservices" = "ns1";
        "dfs.ha.namenodes.ns1" = "nn1,nn2";
        "dfs.namenode.shared.edits.dir.ns1" = "qjournal://jn1:8485;jn2:8485;jn3:8485/ns1";
        "dfs.namenode.rpc-address.ns1.nn1" = "nn1:8020";
        "dfs.namenode.rpc-address.ns1.nn2" = "nn2:8020";
        "dfs.namenode.servicerpc-address.ns1.nn1" = "nn1:8022";
        "dfs.namenode.servicerpc-address.ns1.nn2" = "nn2:8022";
        "dfs.namenode.http-address.ns1.nn1" = "nn1:9870";
        "dfs.namenode.http-address.ns1.nn2" = "nn2:9870";

        # Automatic failover configuration
        "dfs.client.failover.proxy.provider.ns1" = "org.apache.hadoop.hdfs.server.namenode.ha.ConfiguredFailoverProxyProvider";
        "dfs.ha.automatic-failover.enabled.ns1" = "true";
        "dfs.ha.fencing.methods" = "shell(true)";
        "ha.zookeeper.quorum" = "zk1:2181";
      };
      yarnSite = {
        "yarn.resourcemanager.zk-address" = "zk1:2181";
        "yarn.resourcemanager.ha.enabled" = "true";
        "yarn.resourcemanager.ha.rm-ids" = "rm1,rm2";
        "yarn.resourcemanager.hostname.rm1" = "rm1";
        "yarn.resourcemanager.hostname.rm2" = "rm2";
        "yarn.resourcemanager.ha.automatic-failover.enabled" = "true";
        "yarn.resourcemanager.cluster-id" = "cluster1";
        # yarn.resourcemanager.webapp.address needs to be defined even though yarn.resourcemanager.hostname is set. This shouldn't be necessary, but there's a bug in
        # hadoop-yarn-project/hadoop-yarn/hadoop-yarn-server/hadoop-yarn-server-web-proxy/src/main/java/org/apache/hadoop/yarn/server/webproxy/amfilter/AmFilterInitializer.java:70
        # that causes AM containers to fail otherwise.
        "yarn.resourcemanager.webapp.address.rm1" = "rm1:8088";
        "yarn.resourcemanager.webapp.address.rm2" = "rm2:8088";
      };
    in
    {
      zk1 = { ... }: {
        services.zookeeper.enable = true;
        networking.firewall.allowedTCPPorts = [ 2181 ];
      };

      # HDFS cluster
      nn1 = { ... }: {
        services.hadoop = {
          inherit package coreSite hdfsSite;
          hdfs.namenode = {
            enable = true;
            openFirewall = true;
          };
          hdfs.zkfc.enable = true;
        };
      };
      nn2 = { ... }: {
        services.hadoop = {
          inherit package coreSite hdfsSite;
          hdfs.namenode = {
            enable = true;
            openFirewall = true;
          };
          hdfs.zkfc.enable = true;
        };
      };

      jn1 = { ... }: {
        services.hadoop = {
          inherit package coreSite hdfsSite;
          hdfs.journalnode = {
            enable = true;
            openFirewall = true;
          };
        };
      };
      jn2 = { ... }: {
        services.hadoop = {
          inherit package coreSite hdfsSite;
          hdfs.journalnode = {
            enable = true;
            openFirewall = true;
          };
        };
      };
      jn3 = { ... }: {
        services.hadoop = {
          inherit package coreSite hdfsSite;
          hdfs.journalnode = {
            enable = true;
            openFirewall = true;
          };
        };
      };

      dn1 = { ... }: {
        virtualisation.diskSize = 4096;
        services.hadoop = {
          inherit package coreSite hdfsSite;
          hdfs.datanode = {
            enable = true;
            openFirewall = true;
          };
        };
      };

      # YARN cluster
      rm1 = { options, ... }: {
        services.hadoop = {
          inherit package coreSite hdfsSite yarnSite;
          yarn.resourcemanager = {
            enable = true;
            openFirewall = true;
          };
        };
      };
      rm2 = { options, ... }: {
        services.hadoop = {
          inherit package coreSite hdfsSite yarnSite;
          yarn.resourcemanager = {
            enable = true;
            openFirewall = true;
          };
        };
      };
      nm1 = { options, ... }: {
        virtualisation.memorySize = 2048;
        services.hadoop = {
          inherit package coreSite hdfsSite yarnSite;
          yarn.nodemanager = {
            enable = true;
            openFirewall = true;
          };
        };
      };
      client = { options, ... }: {
        services.hadoop = {
          gatewayRole.enable = true;
          inherit package coreSite hdfsSite yarnSite;
        };
      };
  };

  testScript = ''
    start_all()

    #### HDFS tests ####

    zk1.wait_for_unit("network.target")
    jn1.wait_for_unit("network.target")
    jn2.wait_for_unit("network.target")
    jn3.wait_for_unit("network.target")
    nn1.wait_for_unit("network.target")
    nn2.wait_for_unit("network.target")
    dn1.wait_for_unit("network.target")

    zk1.wait_for_unit("zookeeper")
    jn1.wait_for_unit("hdfs-journalnode")
    jn2.wait_for_unit("hdfs-journalnode")
    jn3.wait_for_unit("hdfs-journalnode")

    zk1.wait_for_open_port(2181)
    jn1.wait_for_open_port(8480)
    jn1.wait_for_open_port(8485)
    jn2.wait_for_open_port(8480)
    jn2.wait_for_open_port(8485)

    # Namenodes must be stopped before initializing the cluster
    nn1.succeed("systemctl stop hdfs-namenode")
    nn2.succeed("systemctl stop hdfs-namenode")
    nn1.succeed("systemctl stop hdfs-zkfc")
    nn2.succeed("systemctl stop hdfs-zkfc")

    # Initialize zookeeper for failover controller
    nn1.succeed("sudo -u hdfs systemd-cat hdfs zkfc -formatZK")

    # Format NN1 and start it
    nn1.succeed("sudo -u hdfs systemd-cat hadoop namenode -format")
    nn1.succeed("systemctl start hdfs-namenode")
    nn1.wait_for_open_port(9870)
    nn1.wait_for_open_port(8022)
    nn1.wait_for_open_port(8020)

    # Bootstrap NN2 from NN1 and start it
    nn2.succeed("sudo -u hdfs systemd-cat hdfs namenode -bootstrapStandby")
    nn2.succeed("systemctl start hdfs-namenode")
    nn2.wait_for_open_port(9870)
    nn2.wait_for_open_port(8022)
    nn2.wait_for_open_port(8020)
    nn1.succeed("systemd-cat netstat -tulpne")

    # Start failover controllers
    nn1.succeed("systemctl start hdfs-zkfc")
    nn2.succeed("systemctl start hdfs-zkfc")

    # DN should have started by now, but confirm anyway
    dn1.wait_for_unit("hdfs-datanode")
    # Print states of namenodes
    client.succeed("sudo -u hdfs systemd-cat hdfs haadmin -getAllServiceState")
    # Wait for cluster to exit safemode
    client.succeed("sudo -u hdfs hdfs dfsadmin -safemode wait")
    client.succeed("sudo -u hdfs systemd-cat hdfs haadmin -getAllServiceState")
    # test R/W
    client.succeed("echo testfilecontents | sudo -u hdfs hdfs dfs -put - /testfile")
    assert "testfilecontents" in client.succeed("sudo -u hdfs hdfs dfs -cat /testfile")

    # Test NN failover
    nn1.succeed("systemctl stop hdfs-namenode")
    assert "active" in client.succeed("sudo -u hdfs hdfs haadmin -getAllServiceState")
    client.succeed("sudo -u hdfs systemd-cat hdfs haadmin -getAllServiceState")
    assert "testfilecontents" in client.succeed("sudo -u hdfs hdfs dfs -cat /testfile")

    nn1.succeed("systemctl start hdfs-namenode")
    nn1.wait_for_open_port(9870)
    nn1.wait_for_open_port(8022)
    nn1.wait_for_open_port(8020)
    assert "standby" in client.succeed("sudo -u hdfs hdfs haadmin -getAllServiceState")
    client.succeed("sudo -u hdfs systemd-cat hdfs haadmin -getAllServiceState")

    #### YARN tests ####

    rm1.wait_for_unit("network.target")
    rm2.wait_for_unit("network.target")
    nm1.wait_for_unit("network.target")

    rm1.wait_for_unit("yarn-resourcemanager")
    rm1.wait_for_open_port(8088)
    rm2.wait_for_unit("yarn-resourcemanager")
    rm2.wait_for_open_port(8088)

    nm1.wait_for_unit("yarn-nodemanager")
    nm1.wait_for_open_port(8042)
    nm1.wait_for_open_port(8040)
    client.wait_until_succeeds("yarn node -list | grep Nodes:1")
    client.succeed("sudo -u yarn systemd-cat yarn rmadmin -getAllServiceState")
    client.succeed("sudo -u yarn systemd-cat yarn node -list")

    # Test RM failover
    rm1.succeed("systemctl stop yarn-resourcemanager")
    assert "standby" not in client.succeed("sudo -u yarn yarn rmadmin -getAllServiceState")
    client.succeed("sudo -u yarn systemd-cat yarn rmadmin -getAllServiceState")
    rm1.succeed("systemctl start yarn-resourcemanager")
    rm1.wait_for_unit("yarn-resourcemanager")
    rm1.wait_for_open_port(8088)
    assert "standby" in client.succeed("sudo -u yarn yarn rmadmin -getAllServiceState")
    client.succeed("sudo -u yarn systemd-cat yarn rmadmin -getAllServiceState")

    assert "Estimated value of Pi is" in client.succeed("HADOOP_USER_NAME=hdfs yarn jar $(readlink $(which yarn) | sed -r 's~bin/yarn~share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar~g') pi 2 10")
    assert "SUCCEEDED" in client.succeed("yarn application -list -appStates FINISHED")
  '';
})
