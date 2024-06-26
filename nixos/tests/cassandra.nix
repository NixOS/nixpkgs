import ./make-test-python.nix (
  {
    pkgs,
    lib,
    testPackage ? pkgs.cassandra,
    ...
  }:
  let
    clusterName = "NixOS Automated-Test Cluster";

    testRemoteAuth = lib.versionAtLeast testPackage.version "3.11";
    jmxRoles = [
      {
        username = "me";
        password = "password";
      }
    ];
    jmxRolesFile = ./cassandra-jmx-roles;
    jmxAuthArgs = "-u ${(builtins.elemAt jmxRoles 0).username} -pw ${
      (builtins.elemAt jmxRoles 0).password
    }";
    jmxPort = 7200; # Non-standard port so it doesn't accidentally work
    jmxPortStr = toString jmxPort;

    # Would usually be assigned to 512M.
    # Set it to a different value, so that we can check whether our config
    # actually changes it.
    numMaxHeapSize = "400";
    getHeapLimitCommand = ''
      nodetool info -p ${jmxPortStr} | grep "^Heap Memory" | awk '{print $NF}'
    '';
    checkHeapLimitCommand = pkgs.writeShellScript "check-heap-limit.sh" ''
      [ 1 -eq "$(echo "$(${getHeapLimitCommand}) < ${numMaxHeapSize}" | ${pkgs.bc}/bin/bc)" ]
    '';

    cassandraCfg = ipAddress: {
      enable = true;
      inherit clusterName;
      listenAddress = ipAddress;
      rpcAddress = ipAddress;
      seedAddresses = [ "192.168.1.1" ];
      package = testPackage;
      maxHeapSize = "${numMaxHeapSize}M";
      heapNewSize = "100M";
      inherit jmxPort;
    };
    nodeCfg =
      ipAddress: extra:
      { pkgs, config, ... }:
      rec {
        environment.systemPackages = [ testPackage ];
        networking = {
          firewall.allowedTCPPorts = [
            7000
            9042
            services.cassandra.jmxPort
          ];
          useDHCP = false;
          interfaces.eth1.ipv4.addresses = pkgs.lib.mkOverride 0 [
            {
              address = ipAddress;
              prefixLength = 24;
            }
          ];
        };
        services.cassandra = cassandraCfg ipAddress // extra;
      };
  in
  {
    name = "cassandra-${testPackage.version}";
    meta = {
      maintainers = with lib.maintainers; [ johnazoidberg ];
    };

    nodes = {
      cass0 = nodeCfg "192.168.1.1" { };
      cass1 = nodeCfg "192.168.1.2" (
        lib.optionalAttrs testRemoteAuth {
          inherit jmxRoles;
          remoteJmx = true;
        }
      );
      cass2 = nodeCfg "192.168.1.3" { jvmOpts = [ "-Dcassandra.replace_address=cass1" ]; };
    };

    testScript =
      ''
        # Check configuration
        with subtest("Timers exist"):
            cass0.succeed("systemctl list-timers | grep cassandra-full-repair.timer")
            cass0.succeed("systemctl list-timers | grep cassandra-incremental-repair.timer")

        with subtest("Can connect via cqlsh"):
            cass0.wait_for_unit("cassandra.service")
            cass0.wait_until_succeeds("nc -z cass0 9042")
            cass0.succeed("echo 'show version;' | cqlsh cass0")

        with subtest("Nodetool is operational"):
            cass0.wait_for_unit("cassandra.service")
            cass0.wait_until_succeeds("nc -z localhost ${jmxPortStr}")
            cass0.succeed("nodetool status -p ${jmxPortStr} --resolve-ip | egrep '^UN[[:space:]]+cass0'")

        with subtest("Cluster name was set"):
            cass0.wait_for_unit("cassandra.service")
            cass0.wait_until_succeeds("nc -z localhost ${jmxPortStr}")
            cass0.wait_until_succeeds(
                "nodetool describecluster -p ${jmxPortStr} | grep 'Name: ${clusterName}'"
            )

        with subtest("Heap limit set correctly"):
            # Nodetool takes a while until it can display info
            cass0.wait_until_succeeds("nodetool info -p ${jmxPortStr}")
            cass0.succeed("${checkHeapLimitCommand}")

        # Check cluster interaction
        with subtest("Bring up cluster"):
            cass1.wait_for_unit("cassandra.service")
            cass1.wait_until_succeeds(
                "nodetool -p ${jmxPortStr} ${jmxAuthArgs} status | egrep -c '^UN' | grep 2"
            )
            cass0.succeed("nodetool status -p ${jmxPortStr} --resolve-ip | egrep '^UN[[:space:]]+cass1'")
      ''
      + lib.optionalString testRemoteAuth ''
        with subtest("Remote authenticated jmx"):
            # Doesn't work if not enabled
            cass0.wait_until_succeeds("nc -z localhost ${jmxPortStr}")
            cass1.fail("nc -z 192.168.1.1 ${jmxPortStr}")
            cass1.fail("nodetool -p ${jmxPortStr} -h 192.168.1.1 status")

            # Works if enabled
            cass1.wait_until_succeeds("nc -z localhost ${jmxPortStr}")
            cass0.succeed("nodetool -p ${jmxPortStr} -h 192.168.1.2 ${jmxAuthArgs} status")
      ''
      + ''
        with subtest("Break and fix node"):
            cass1.block()
            cass0.wait_until_succeeds(
                "nodetool status -p ${jmxPortStr} --resolve-ip | egrep -c '^DN[[:space:]]+cass1'"
            )
            cass0.succeed("nodetool status -p ${jmxPortStr} | egrep -c '^UN'  | grep 1")
            cass1.unblock()
            cass1.wait_until_succeeds(
                "nodetool -p ${jmxPortStr} ${jmxAuthArgs} status | egrep -c '^UN'  | grep 2"
            )
            cass0.succeed("nodetool status -p ${jmxPortStr} | egrep -c '^UN'  | grep 2")

        with subtest("Replace crashed node"):
            cass1.block()  # .crash() waits until it's fully shutdown
            cass2.start()
            cass0.wait_until_fails(
                "nodetool status -p ${jmxPortStr} --resolve-ip | egrep '^UN[[:space:]]+cass1'"
            )

            cass2.wait_for_unit("cassandra.service")
            cass0.wait_until_succeeds(
                "nodetool status -p ${jmxPortStr} --resolve-ip | egrep '^UN[[:space:]]+cass2'"
            )
      '';

    passthru = {
      inherit testPackage;
    };
  }
)
