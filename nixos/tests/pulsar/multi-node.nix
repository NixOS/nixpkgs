import ../make-test-python.nix ({ pkgs, ...} : {
  name = "pulsar-multi-node";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ samdroid-apps ];
  };

  nodes = let
    jvmMemoryOptions = "-Xms64m -Xmx64m";

    bookieNode = { nodes, ... }: {
    };
  in {
    zk1 = { nodes, ... }: {
      services.pulsar = {
        inherit jvmMemoryOptions;
        zookeeper.enable = true;
        zookeeper.servers = [ nodes.zk1.config.networking.hostName ];
      };
      networking.firewall.allowedTCPPorts = [ 2181 ];
    };
    bk1 = { nodes, ... }: {
      services.pulsar = {
        inherit jvmMemoryOptions;
        zookeeper.servers = [ nodes.zk1.config.networking.hostName ];
        bookie = {
          enable = true;
          advertisedAddress = nodes.bk1.config.networking.primaryIPAddress;
        };
      };
      networking.firewall.allowedTCPPorts = [ 3181 ];
    };
    bk2 = { nodes, ... }: {
      services.pulsar = {
        inherit jvmMemoryOptions;
        zookeeper.servers = [ nodes.zk1.config.networking.hostName ];
        bookie = {
          enable = true;
          advertisedAddress = nodes.bk2.config.networking.primaryIPAddress;
        };
      };
      networking.firewall.allowedTCPPorts = [ 3181 ];
    };
    broker = { nodes, ... }: {
      services.pulsar = {
        inherit jvmMemoryOptions;
        zookeeper.servers = [ nodes.zk1.config.networking.hostName ];
        broker.enable = true;
      };
      networking.firewall.allowedTCPPorts = [ 6650 ];
      virtualisation.memorySize = 1024;
    };
  };

  testScript = ''
    zk1.wait_for_open_port(2181)
    bk1.wait_for_open_port(3181)
    bk2.wait_for_open_port(3181)
    broker.wait_for_open_port(6650)

    # The subscription can only consume messages sent after it is created.
    # So constantly send a message while we're subscribed.
    status, out = broker.execute(
        "( while true; do"
        "  ${pkgs.pulsar}/bin/pulsar-client produce test-topic -m foo;"
        "  sleep 1; done ) &"
        " ${pkgs.pulsar}/bin/pulsar-client consume test-topic"
        " -s sub1"
    )
    assert status == 0
    assert "foo" in out
  '';
})
