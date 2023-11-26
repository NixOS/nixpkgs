# Test a minimal HDFS cluster with no HA
import ../make-test-python.nix ({ package, lib, ... }:
{
  name = "hadoop-hdfs";

  nodes = let
    coreSite = {
      "fs.defaultFS" = "hdfs://namenode:8020";
      "hadoop.proxyuser.httpfs.groups" = "*";
      "hadoop.proxyuser.httpfs.hosts" = "*";
    };
    in {
    namenode = { pkgs, ... }: {
      services.hadoop = {
        inherit package;
        hdfs = {
          namenode = {
            enable = true;
            openFirewall = true;
            formatOnInit = true;
          };
          httpfs = {
            # The NixOS hadoop module only support webHDFS on 3.3 and newer
            enable = lib.mkIf (lib.versionAtLeast package.version "3.3") true;
            openFirewall = true;
          };
        };
        inherit coreSite;
      };
    };
    datanode = { pkgs, ... }: {
      services.hadoop = {
        inherit package;
        hdfs.datanode = {
          enable = true;
          openFirewall = true;
          dataDirs = [{
            type = "DISK";
            path = "/tmp/dn1";
          }];
        };
        inherit coreSite;
      };
    };
  };

  testScript = ''
    start_all()

    namenode.wait_for_unit("hdfs-namenode")
    namenode.wait_for_unit("network.target")
    namenode.wait_for_open_port(8020)
    namenode.succeed("systemd-cat ss -tulpne")
    namenode.succeed("systemd-cat cat /etc/hadoop*/hdfs-site.xml")
    namenode.wait_for_open_port(9870)

    datanode.wait_for_unit("hdfs-datanode")
    datanode.wait_for_unit("network.target")
  '' + (if lib.versionAtLeast package.version "3" then ''
    datanode.wait_for_open_port(9864)
    datanode.wait_for_open_port(9866)
    datanode.wait_for_open_port(9867)

    datanode.succeed("curl -f http://datanode:9864")
  '' else ''
    datanode.wait_for_open_port(50075)
    datanode.wait_for_open_port(50010)
    datanode.wait_for_open_port(50020)

    datanode.succeed("curl -f http://datanode:50075")
  '' ) + ''
    namenode.succeed("curl -f http://namenode:9870")

    datanode.succeed("sudo -u hdfs hdfs dfsadmin -safemode wait")
    datanode.succeed("echo testfilecontents | sudo -u hdfs hdfs dfs -put - /testfile")
    assert "testfilecontents" in datanode.succeed("sudo -u hdfs hdfs dfs -cat /testfile")

  '' + lib.optionalString (lib.versionAtLeast package.version "3.3" ) ''
    namenode.wait_for_unit("hdfs-httpfs")
    namenode.wait_for_open_port(14000)
    assert "testfilecontents" in datanode.succeed("curl -f \"http://namenode:14000/webhdfs/v1/testfile?user.name=hdfs&op=OPEN\" 2>&1")
  '';
})
