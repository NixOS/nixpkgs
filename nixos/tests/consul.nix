{ lib, ... }:

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
    allowedTCPPorts = [
      8301
      8302
      8600
      8500
      8300
    ];
    allowedUDPPorts = [
      8301
      8302
      8600
    ];
  };

  client =
    index:
    { pkgs, ... }:
    let
      ip = builtins.elemAt allConsensusClientHosts index;
    in
    {
      environment.systemPackages = [ pkgs.consul ];

      networking.interfaces.eth1.ipv4.addresses = pkgs.lib.mkOverride 0 [
        {
          address = ip;
          prefixLength = 16;
        }
      ];
      networking.firewall = firewallSettings;

      nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "consul" ];

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

  server =
    index:
    { pkgs, ... }:
    let
      numConsensusServers = builtins.length allConsensusServerHosts;
      thisConsensusServerHost = builtins.elemAt allConsensusServerHosts index;
      ip = thisConsensusServerHost; # since we already use IPs to identify servers
    in
    {
      networking.interfaces.eth1.ipv4.addresses = pkgs.lib.mkOverride 0 [
        {
          address = ip;
          prefixLength = 16;
        }
      ];
      networking.firewall = firewallSettings;

      nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "consul" ];

      services.consul =
        assert builtins.elem thisConsensusServerHost allConsensusServerHosts;
        {
          enable = true;
          inherit webUi;
          extraConfig = defaultExtraConfig // {
            server = true;
            bootstrap_expect = numConsensusServers;
            # Tell Consul that we never intend to drop below this many servers.
            # Ensures to not permanently lose consensus after temporary loss.
            # See https://github.com/hashicorp/consul/issues/8118#issuecomment-645330040
            autopilot.min_quorum = numConsensusServers;
            retry_join =
              # If there's only 1 node in the network, we allow self-join;
              # otherwise, the node must not try to join itself, and join only the other servers.
              # See https://github.com/hashicorp/consul/issues/2868
              if numConsensusServers == 1 then
                allConsensusServerHosts
              else
                builtins.filter (h: h != thisConsensusServerHost) allConsensusServerHosts;
            bind_addr = ip;
          };
        };
    };
in
{
  name = "consul";

  node.pkgsReadOnly = false;

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


    def wait_for_healthy_servers():
        # See https://github.com/hashicorp/consul/issues/8118#issuecomment-645330040
        # for why the `Voter` column of `list-peers` has that info.
        # TODO: The `grep true` relies on the fact that currently in
        #       the output like
        #           # consul operator raft list-peers
        #           Node     ID   Address           State     Voter  RaftProtocol
        #           server3  ...  192.168.1.3:8300  leader    true   3
        #           server2  ...  192.168.1.2:8300  follower  true   3
        #           server1  ...  192.168.1.1:8300  follower  false  3
        #       `Voter`is the only boolean column.
        #       Change this to the more reliable way to be defined by
        #       https://github.com/hashicorp/consul/issues/8118
        #       once that ticket is closed.
        for m in machines:
            m.wait_until_succeeds(
                "[ $(consul operator raft list-peers | grep true | wc -l) == 3 ]"
            )


    def wait_for_all_machines_alive():
        """
        Note that Serf-"alive" does not mean "Raft"-healthy;
        see `wait_for_healthy_servers()` for that instead.
        """
        for m in machines:
            m.wait_until_succeeds("[ $(consul members | grep -o alive | wc -l) == 5 ]")


    wait_for_healthy_servers()
    # Also wait for clients to be alive.
    wait_for_all_machines_alive()

    client1.succeed("consul kv put testkey 42")
    client2.succeed("[ $(consul kv get testkey) == 42 ]")


    def rolling_restart_test(proper_rolling_procedure=True):
        """
        Tests that the cluster can tolearate failures of any single server,
        following the recommended rolling upgrade procedure from
        https://www.consul.io/docs/upgrading#standard-upgrades.

        Optionally, `proper_rolling_procedure=False` can be given
        to wait only for each server to be back `Healthy`, not `Stable`
        in the Raft consensus, see Consul setting `ServerStabilizationTime` and
        https://github.com/hashicorp/consul/issues/8118#issuecomment-645330040.
        """

        for server in servers:
            server.block()
            server.systemctl("stop consul")

            # Make sure the stopped peer is recognized as being down
            client1.wait_until_succeeds(
              f"[ $(consul members | grep {server.name} | grep -o -E 'failed|left' | wc -l) == 1 ]"
            )

            # For each client, wait until they have connection again
            # using `kv get -recurse` before issuing commands.
            client1.wait_until_succeeds("consul kv get -recurse")
            client2.wait_until_succeeds("consul kv get -recurse")

            # Do some consul actions while one server is down.
            client1.succeed("consul kv put testkey 43")
            client2.succeed("[ $(consul kv get testkey) == 43 ]")
            client2.succeed("consul kv delete testkey")

            server.unblock()
            server.systemctl("start consul")

            if proper_rolling_procedure:
                # Wait for recovery.
                wait_for_healthy_servers()
            else:
                # NOT proper rolling upgrade procedure, see above.
                wait_for_all_machines_alive()

            # Wait for client connections.
            client1.wait_until_succeeds("consul kv get -recurse")
            client2.wait_until_succeeds("consul kv get -recurse")

            # Do some consul actions with server back up.
            client1.succeed("consul kv put testkey 44")
            client2.succeed("[ $(consul kv get testkey) == 44 ]")
            client2.succeed("consul kv delete testkey")


    def all_servers_crash_simultaneously_test():
        """
        Tests that the cluster will eventually come back after all
        servers crash simultaneously.
        """

        for server in servers:
            server.block()
            server.systemctl("stop --no-block consul")

        for server in servers:
            # --no-block is async, so ensure it has been stopped by now
            server.wait_until_fails("systemctl is-active --quiet consul")
            server.unblock()
            server.systemctl("start consul")

        # Wait for recovery.
        wait_for_healthy_servers()

        # Wait for client connections.
        client1.wait_until_succeeds("consul kv get -recurse")
        client2.wait_until_succeeds("consul kv get -recurse")

        # Do some consul actions with servers back up.
        client1.succeed("consul kv put testkey 44")
        client2.succeed("[ $(consul kv get testkey) == 44 ]")
        client2.succeed("consul kv delete testkey")


    # Run the tests.

    print("rolling_restart_test()")
    rolling_restart_test()

    print("all_servers_crash_simultaneously_test()")
    all_servers_crash_simultaneously_test()

    print("rolling_restart_test(proper_rolling_procedure=False)")
    rolling_restart_test(proper_rolling_procedure=False)
  '';
}
