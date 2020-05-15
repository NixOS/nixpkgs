import ./make-test-python.nix ({pkgs, lib, ...}:

let
  # Settings for both servers and agents
  webUi = true;
  retry_interval = "1s";
  raft_multiplier = 1;

  defaultExtraConfig = {
    inherit retry_interval;
    performance = {
      inherit raft_multiplier;
    };
  };

  allConsensusServerHosts = [
    "192.168.1.1"
    "192.168.1.2"
    "192.168.1.3"
  ];

  allConsensusClientHosts = [
    "192.168.2.1"
    "192.168.2.2"
  ];

  firewallSettings = {
    # See https://www.consul.io/docs/install/ports.html
    allowedTCPPorts = [ 8301 8302 8600 8500 8300 ];
    allowedUDPPorts = [ 8301 8302 8600 ];
  };

  client = index: { pkgs, ... }:
    let
      ip = builtins.elemAt allConsensusClientHosts index;
    in
      {
        environment.systemPackages = [ pkgs.consul ];

        networking.interfaces.eth1.ipv4.addresses = pkgs.lib.mkOverride 0 [
          { address = ip; prefixLength = 16; }
        ];
        networking.firewall = firewallSettings;

        services.consul = {
          enable = true;
          inherit webUi;
          extraConfig = defaultExtraConfig // {
            server = false;
            retry_join = allConsensusServerHosts;
            bind_addr = ip;
          };
        };
      };

  server = index: { pkgs, ... }:
    let
      ip = builtins.elemAt allConsensusServerHosts index;
    in
      {
        networking.interfaces.eth1.ipv4.addresses = pkgs.lib.mkOverride 0 [
          { address = builtins.elemAt allConsensusServerHosts index; prefixLength = 16; }
        ];
        networking.firewall = firewallSettings;

        services.consul =
          let
            thisConsensusServerHost = builtins.elemAt allConsensusServerHosts index;
          in
          assert builtins.elem thisConsensusServerHost allConsensusServerHosts;
          {
            enable = true;
            inherit webUi;
            extraConfig = defaultExtraConfig // {
              server = true;
              bootstrap_expect = builtins.length allConsensusServerHosts;
              retry_join =
                # If there's only 1 node in the network, we allow self-join;
                # otherwise, the node must not try to join itself, and join only the other servers.
                # See https://github.com/hashicorp/consul/issues/2868
                if builtins.length allConsensusServerHosts == 1
                  then allConsensusServerHosts
                  else builtins.filter (h: h != thisConsensusServerHost) allConsensusServerHosts;
              bind_addr = ip;
            };
          };
      };
in {
  name = "consul";

  nodes = {
    server1 = server 0;
    server2 = server 1;
    server3 = server 2;

    client1 = client 0;
    client2 = client 1;
  };

  testScript = ''
    servers = [server1, server2, server3]
    machines = [server1, server2, server3, client1, client2]

    for m in machines:
        m.wait_for_unit("consul.service")

    for m in machines:
        m.wait_until_succeeds("[ $(consul members | grep -o alive | wc -l) == 5 ]")

    client1.succeed("consul kv put testkey 42")
    client2.succeed("[ $(consul kv get testkey) == 42 ]")

    # Test that the cluster can tolearate failures of any single server:
    for server in servers:
        server.crash()

        # For each client, wait until they have connection again
        # using `kv get -recurse` before issuing commands.
        client1.wait_until_succeeds("consul kv get -recurse")
        client2.wait_until_succeeds("consul kv get -recurse")

        # Do some consul actions while one server is down.
        client1.succeed("consul kv put testkey 43")
        client2.succeed("[ $(consul kv get testkey) == 43 ]")
        client2.succeed("consul kv delete testkey")

        # Restart crashed machine.
        server.start()

        # Wait for recovery.
        for m in machines:
            m.wait_until_succeeds("[ $(consul members | grep -o alive | wc -l) == 5 ]")

        # Wait for client connections.
        client1.wait_until_succeeds("consul kv get -recurse")
        client2.wait_until_succeeds("consul kv get -recurse")

        # Do some consul actions with server back up.
        client1.succeed("consul kv put testkey 44")
        client2.succeed("[ $(consul kv get testkey) == 44 ]")
        client2.succeed("consul kv delete testkey")
  '';
})
