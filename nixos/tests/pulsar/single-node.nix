import ../make-test-python.nix ({ pkgs, ...} : {
  name = "pulsar-single-node";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ samdroid-apps ];
  };

  nodes = {
    server = { ... }: {
      services.pulsar = {
        zookeeper.enable = true;
        bookie.enable = true;
        broker.enable = true;
        broker.extraConf = ''
          # we only have 1 bookie node
          managedLedgerDefaultEnsembleSize=1
          managedLedgerDefaultWriteQuorum=1
          managedLedgerDefaultAckQuorum=1
        '';
        # By default pulsar allocates 2GB for all services
        jvmMemoryOptions = "-Xms64m -Xmx64m";
      };
      # 3 JVM services won't fit in the default ~300mb memory
      virtualisation.memorySize = 1024;
      networking.firewall.allowedTCPPorts = [ 6650 ];
    };
  };

  testScript = ''
    start_all()

    server.wait_for_unit("network.target")
    server.wait_for_open_port(6650)

    # The subscription can only consume messages sent after it is created.
    # So constantly send a message while we're subscribed.
    status, out = server.execute(
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
