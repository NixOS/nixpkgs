import ./make-test-python.nix ({ pkgs, lib, ... }: let

  # We'll need to be able to trade cert files between nodes via scp.
  inherit (import ./ssh-keys.nix pkgs)
    snakeOilPrivateKey snakeOilPublicKey;

  makeNebulaNode = { config, ... }: name: extraConfig: lib.mkMerge [
    {
      # Expose nebula for doing cert signing.
      environment.systemPackages = [ pkgs.nebula ];
      users.users.root.openssh.authorizedKeys.keys = [ snakeOilPublicKey ];
      services.openssh.enable = true;

      services.nebula.networks.smoke = {
        # Note that these paths won't exist when the machine is first booted.
        ca = "/etc/nebula/ca.crt";
        cert = "/etc/nebula/${name}.crt";
        key = "/etc/nebula/${name}.key";
        listen = { host = "0.0.0.0"; port = 4242; };
      };
    }
    extraConfig
  ];

in
{
  name = "nebula";

  nodes = {

    lighthouse = { ... } @ args:
      makeNebulaNode args "lighthouse" {
        networking.interfaces.eth1.ipv4.addresses = [{
          address = "192.168.1.1";
          prefixLength = 24;
        }];

        services.nebula.networks.smoke = {
          isLighthouse = true;
          isRelay = true;
          firewall = {
            outbound = [ { port = "any"; proto = "any"; host = "any"; } ];
            inbound = [ { port = "any"; proto = "any"; host = "any"; } ];
          };
        };
      };

    node2 = { ... } @ args:
      makeNebulaNode args "node2" {
        networking.interfaces.eth1.ipv4.addresses = [{
          address = "192.168.1.2";
          prefixLength = 24;
        }];

        services.nebula.networks.smoke = {
          staticHostMap = { "10.0.100.1" = [ "192.168.1.1:4242" ]; };
          isLighthouse = false;
          lighthouses = [ "10.0.100.1" ];
          relays = [ "10.0.100.1" ];
          firewall = {
            outbound = [ { port = "any"; proto = "any"; host = "any"; } ];
            inbound = [ { port = "any"; proto = "any"; host = "any"; } ];
          };
        };
      };

    node3 = { ... } @ args:
      makeNebulaNode args "node3" {
        networking.interfaces.eth1.ipv4.addresses = [{
          address = "192.168.1.3";
          prefixLength = 24;
        }];

        services.nebula.networks.smoke = {
          staticHostMap = { "10.0.100.1" = [ "192.168.1.1:4242" ]; };
          isLighthouse = false;
          lighthouses = [ "10.0.100.1" ];
          relays = [ "10.0.100.1" ];
          firewall = {
            outbound = [ { port = "any"; proto = "any"; host = "any"; } ];
            inbound = [ { port = "any"; proto = "any"; host = "lighthouse"; } ];
          };
        };
      };

    node4 = { ... } @ args:
      makeNebulaNode args "node4" {
        networking.interfaces.eth1.ipv4.addresses = [{
          address = "192.168.1.4";
          prefixLength = 24;
        }];

        services.nebula.networks.smoke = {
          enable = true;
          staticHostMap = { "10.0.100.1" = [ "192.168.1.1:4242" ]; };
          isLighthouse = false;
          lighthouses = [ "10.0.100.1" ];
          relays = [ "10.0.100.1" ];
          firewall = {
            outbound = [ { port = "any"; proto = "any"; host = "lighthouse"; } ];
            inbound = [ { port = "any"; proto = "any"; host = "any"; } ];
          };
        };
      };

    node5 = { ... } @ args:
      makeNebulaNode args "node5" {
        networking.interfaces.eth1.ipv4.addresses = [{
          address = "192.168.1.5";
          prefixLength = 24;
        }];

        services.nebula.networks.smoke = {
          enable = false;
          staticHostMap = { "10.0.100.1" = [ "192.168.1.1:4242" ]; };
          isLighthouse = false;
          lighthouses = [ "10.0.100.1" ];
          relays = [ "10.0.100.1" ];
          firewall = {
            outbound = [ { port = "any"; proto = "any"; host = "lighthouse"; } ];
            inbound = [ { port = "any"; proto = "any"; host = "any"; } ];
          };
        };
      };

  };

  testScript = let

    setUpPrivateKey = name: ''
      ${name}.start()
      ${name}.succeed(
          "mkdir -p /root/.ssh",
          "chown 700 /root/.ssh",
          "cat '${snakeOilPrivateKey}' > /root/.ssh/id_snakeoil",
          "chown 600 /root/.ssh/id_snakeoil",
      )
    '';

    # From what I can tell, StrictHostKeyChecking=no is necessary for ssh to work between machines.
    sshOpts = "-oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null -oIdentityFile=/root/.ssh/id_snakeoil";

    restartAndCheckNebula = name: ip: ''
      ${name}.systemctl("restart nebula@smoke.service")
      ${name}.succeed("ping -c5 ${ip}")
    '';

    # Create a keypair on the client node, then use the public key to sign a cert on the lighthouse.
    signKeysFor = name: ip: ''
      lighthouse.wait_for_unit("sshd.service")
      ${name}.wait_for_unit("sshd.service")
      ${name}.succeed(
          "mkdir -p /etc/nebula",
          "nebula-cert keygen -out-key /etc/nebula/${name}.key -out-pub /etc/nebula/${name}.pub",
          "scp ${sshOpts} /etc/nebula/${name}.pub 192.168.1.1:/tmp/${name}.pub",
      )
      lighthouse.succeed(
          'nebula-cert sign -ca-crt /etc/nebula/ca.crt -ca-key /etc/nebula/ca.key -name "${name}" -groups "${name}" -ip "${ip}" -in-pub /tmp/${name}.pub -out-crt /tmp/${name}.crt',
      )
      ${name}.succeed(
          "scp ${sshOpts} 192.168.1.1:/tmp/${name}.crt /etc/nebula/${name}.crt",
          "scp ${sshOpts} 192.168.1.1:/etc/nebula/ca.crt /etc/nebula/ca.crt",
          '(id nebula-smoke >/dev/null && chown -R nebula-smoke:nebula-smoke /etc/nebula) || true'
      )
    '';

    getPublicIp = node: ''
      ${node}.succeed("ip --brief addr show eth1 | awk '{print $3}' | tail -n1 | cut -d/ -f1").strip()
    '';

    # Never do this for anything security critical! (Thankfully it's just a test.)
    # Restart Nebula right after the mutual block and/or restore so the state is fresh.
    blockTrafficBetween = nodeA: nodeB: ''
      node_a = ${getPublicIp nodeA}
      node_b = ${getPublicIp nodeB}
      ${nodeA}.succeed("iptables -I INPUT -s " + node_b + " -j DROP")
      ${nodeB}.succeed("iptables -I INPUT -s " + node_a + " -j DROP")
      ${nodeA}.systemctl("restart nebula@smoke.service")
      ${nodeB}.systemctl("restart nebula@smoke.service")
    '';
    allowTrafficBetween = nodeA: nodeB: ''
      node_a = ${getPublicIp nodeA}
      node_b = ${getPublicIp nodeB}
      ${nodeA}.succeed("iptables -D INPUT -s " + node_b + " -j DROP")
      ${nodeB}.succeed("iptables -D INPUT -s " + node_a + " -j DROP")
      ${nodeA}.systemctl("restart nebula@smoke.service")
      ${nodeB}.systemctl("restart nebula@smoke.service")
    '';
  in ''
    # Create the certificate and sign the lighthouse's keys.
    ${setUpPrivateKey "lighthouse"}
    lighthouse.succeed(
        "mkdir -p /etc/nebula",
        'nebula-cert ca -name "Smoke Test" -out-crt /etc/nebula/ca.crt -out-key /etc/nebula/ca.key',
        'nebula-cert sign -ca-crt /etc/nebula/ca.crt -ca-key /etc/nebula/ca.key -name "lighthouse" -groups "lighthouse" -ip "10.0.100.1/24" -out-crt /etc/nebula/lighthouse.crt -out-key /etc/nebula/lighthouse.key',
        'chown -R nebula-smoke:nebula-smoke /etc/nebula'
    )

    # Reboot the lighthouse and verify that the nebula service comes up on boot.
    # Since rebooting takes a while, we'll just restart the service on the other nodes.
    lighthouse.shutdown()
    lighthouse.start()
    lighthouse.wait_for_unit("nebula@smoke.service")
    lighthouse.succeed("ping -c5 10.0.100.1")

    # Create keys for node2's nebula service and test that it comes up.
    ${setUpPrivateKey "node2"}
    ${signKeysFor "node2" "10.0.100.2/24"}
    ${restartAndCheckNebula "node2" "10.0.100.2"}

    # Create keys for node3's nebula service and test that it comes up.
    ${setUpPrivateKey "node3"}
    ${signKeysFor "node3" "10.0.100.3/24"}
    ${restartAndCheckNebula "node3" "10.0.100.3"}

    # Create keys for node4's nebula service and test that it comes up.
    ${setUpPrivateKey "node4"}
    ${signKeysFor "node4" "10.0.100.4/24"}
    ${restartAndCheckNebula "node4" "10.0.100.4"}

    # Create keys for node4's nebula service and test that it does not come up.
    ${setUpPrivateKey "node5"}
    ${signKeysFor "node5" "10.0.100.5/24"}
    node5.fail("systemctl status nebula@smoke.service")
    node5.fail("ping -c5 10.0.100.5")

    # The lighthouse can ping node2 and node3 but not node5
    lighthouse.succeed("ping -c3 10.0.100.2")
    lighthouse.succeed("ping -c3 10.0.100.3")
    lighthouse.fail("ping -c3 10.0.100.5")

    # node2 can ping the lighthouse, but not node3 because of its inbound firewall
    node2.succeed("ping -c3 10.0.100.1")
    node2.fail("ping -c3 10.0.100.3")

    # node3 can ping the lighthouse and node2
    node3.succeed("ping -c3 10.0.100.1")
    node3.succeed("ping -c3 10.0.100.2")

    # block node3 <-> node2, and node3 -> node2 should still work.
    ${blockTrafficBetween "node3" "node2"}
    node3.succeed("ping -c10 10.0.100.2")
    ${allowTrafficBetween "node3" "node2"}
    node3.succeed("ping -c10 10.0.100.2")

    # node4 can ping the lighthouse but not node2 or node3
    node4.succeed("ping -c3 10.0.100.1")
    node4.fail("ping -c3 10.0.100.2")
    node4.fail("ping -c3 10.0.100.3")

    # node2 can ping node3 now that node3 pinged it first
    node2.succeed("ping -c3 10.0.100.3")

    # block node2 <-> node3, and node2 -> node3 should still work.
    ${blockTrafficBetween "node2" "node3"}
    node3.succeed("ping -c10 10.0.100.2")
    node2.succeed("ping -c10 10.0.100.3")
    ${allowTrafficBetween "node2" "node3"}
    node3.succeed("ping -c10 10.0.100.2")
    node2.succeed("ping -c10 10.0.100.3")

    # node4 can ping node2 if node2 pings it first
    node2.succeed("ping -c3 10.0.100.4")
    node4.succeed("ping -c3 10.0.100.2")

    # block node4 <-> node2, and node2 <-> node4 should still work.
    ${blockTrafficBetween "node2" "node4"}
    node2.succeed("ping -c10 10.0.100.4")
    node4.succeed("ping -c10 10.0.100.2")
    ${allowTrafficBetween "node2" "node4"}
    node2.succeed("ping -c10 10.0.100.4")
    node4.succeed("ping -c10 10.0.100.2")

    # block lighthouse <-> node3 and node2 <-> node3; node3 won't get to node2
    ${blockTrafficBetween "node3" "lighthouse"}
    ${blockTrafficBetween "node3" "node2"}
    node3.fail("ping -c3 10.0.100.2")
    ${allowTrafficBetween "node3" "lighthouse"}
    ${allowTrafficBetween "node3" "node2"}
    node3.succeed("ping -c3 10.0.100.2")

    # block lighthouse <-> node2, node2 <-> node3, and node2 <-> node4; it won't get to node3 or node4
    ${blockTrafficBetween "node2" "lighthouse"}
    ${blockTrafficBetween "node2" "node3"}
    ${blockTrafficBetween "node2" "node4"}
    node3.fail("ping -c3 10.0.100.2")
    node2.fail("ping -c3 10.0.100.3")
    node2.fail("ping -c3 10.0.100.4")
    ${allowTrafficBetween "node2" "lighthouse"}
    ${allowTrafficBetween "node2" "node3"}
    ${allowTrafficBetween "node2" "node4"}
    node3.succeed("ping -c3 10.0.100.2")
    node2.succeed("ping -c3 10.0.100.3")
    node2.succeed("ping -c3 10.0.100.4")

    # block lighthouse <-> node4 and node4 <-> node2; it won't get to node2
    ${blockTrafficBetween "node4" "lighthouse"}
    ${blockTrafficBetween "node4" "node2"}
    node2.fail("ping -c3 10.0.100.4")
    node4.fail("ping -c3 10.0.100.2")
    ${allowTrafficBetween "node4" "lighthouse"}
    ${allowTrafficBetween "node4" "node2"}
    node2.succeed("ping -c3 10.0.100.4")
    node4.succeed("ping -c3 10.0.100.2")
  '';
})
