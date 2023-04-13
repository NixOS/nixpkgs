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
      networking.interfaces.eth1.useDHCP = false;

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
        networking.interfaces.eth1.ipv4.addresses = lib.mkForce [{
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

    allowAny = { ... } @ args:
      makeNebulaNode args "allowAny" {
        networking.interfaces.eth1.ipv4.addresses = lib.mkForce [{
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

    allowFromLighthouse = { ... } @ args:
      makeNebulaNode args "allowFromLighthouse" {
        networking.interfaces.eth1.ipv4.addresses = lib.mkForce [{
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

    allowToLighthouse = { ... } @ args:
      makeNebulaNode args "allowToLighthouse" {
        networking.interfaces.eth1.ipv4.addresses = lib.mkForce [{
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

    disabled = { ... } @ args:
      makeNebulaNode args "disabled" {
        networking.interfaces.eth1.ipv4.addresses = lib.mkForce [{
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
          "mkdir -p /root"
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
          "scp ${sshOpts} /etc/nebula/${name}.pub root@192.168.1.1:/root/${name}.pub",
      )
      lighthouse.succeed(
          'nebula-cert sign -ca-crt /etc/nebula/ca.crt -ca-key /etc/nebula/ca.key -name "${name}" -groups "${name}" -ip "${ip}" -in-pub /root/${name}.pub -out-crt /root/${name}.crt'
      )
      ${name}.succeed(
          "scp ${sshOpts} root@192.168.1.1:/root/${name}.crt /etc/nebula/${name}.crt",
          "scp ${sshOpts} root@192.168.1.1:/etc/nebula/ca.crt /etc/nebula/ca.crt",
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

    # Create keys for allowAny's nebula service and test that it comes up.
    ${setUpPrivateKey "allowAny"}
    ${signKeysFor "allowAny" "10.0.100.2/24"}
    ${restartAndCheckNebula "allowAny" "10.0.100.2"}

    # Create keys for allowFromLighthouse's nebula service and test that it comes up.
    ${setUpPrivateKey "allowFromLighthouse"}
    ${signKeysFor "allowFromLighthouse" "10.0.100.3/24"}
    ${restartAndCheckNebula "allowFromLighthouse" "10.0.100.3"}

    # Create keys for allowToLighthouse's nebula service and test that it comes up.
    ${setUpPrivateKey "allowToLighthouse"}
    ${signKeysFor "allowToLighthouse" "10.0.100.4/24"}
    ${restartAndCheckNebula "allowToLighthouse" "10.0.100.4"}

    # Create keys for disabled's nebula service and test that it does not come up.
    ${setUpPrivateKey "disabled"}
    ${signKeysFor "disabled" "10.0.100.5/24"}
    disabled.fail("systemctl status nebula@smoke.service")
    disabled.fail("ping -c5 10.0.100.5")

    # The lighthouse can ping allowAny and allowFromLighthouse but not disabled
    lighthouse.succeed("ping -c3 10.0.100.2")
    lighthouse.succeed("ping -c3 10.0.100.3")
    lighthouse.fail("ping -c3 10.0.100.5")

    # allowAny can ping the lighthouse, but not allowFromLighthouse because of its inbound firewall
    allowAny.succeed("ping -c3 10.0.100.1")
    allowAny.fail("ping -c3 10.0.100.3")

    # allowFromLighthouse can ping the lighthouse and allowAny
    allowFromLighthouse.succeed("ping -c3 10.0.100.1")
    allowFromLighthouse.succeed("ping -c3 10.0.100.2")

    # block allowFromLighthouse <-> allowAny, and allowFromLighthouse -> allowAny should still work.
    ${blockTrafficBetween "allowFromLighthouse" "allowAny"}
    allowFromLighthouse.succeed("ping -c10 10.0.100.2")
    ${allowTrafficBetween "allowFromLighthouse" "allowAny"}
    allowFromLighthouse.succeed("ping -c10 10.0.100.2")

    # allowToLighthouse can ping the lighthouse but not allowAny or allowFromLighthouse
    allowToLighthouse.succeed("ping -c3 10.0.100.1")
    allowToLighthouse.fail("ping -c3 10.0.100.2")
    allowToLighthouse.fail("ping -c3 10.0.100.3")

    # allowAny can ping allowFromLighthouse now that allowFromLighthouse pinged it first
    allowAny.succeed("ping -c3 10.0.100.3")

    # block allowAny <-> allowFromLighthouse, and allowAny -> allowFromLighthouse should still work.
    ${blockTrafficBetween "allowAny" "allowFromLighthouse"}
    allowFromLighthouse.succeed("ping -c10 10.0.100.2")
    allowAny.succeed("ping -c10 10.0.100.3")
    ${allowTrafficBetween "allowAny" "allowFromLighthouse"}
    allowFromLighthouse.succeed("ping -c10 10.0.100.2")
    allowAny.succeed("ping -c10 10.0.100.3")

    # allowToLighthouse can ping allowAny if allowAny pings it first
    allowAny.succeed("ping -c3 10.0.100.4")
    allowToLighthouse.succeed("ping -c3 10.0.100.2")

    # block allowToLighthouse <-> allowAny, and allowAny <-> allowToLighthouse should still work.
    ${blockTrafficBetween "allowAny" "allowToLighthouse"}
    allowAny.succeed("ping -c10 10.0.100.4")
    allowToLighthouse.succeed("ping -c10 10.0.100.2")
    ${allowTrafficBetween "allowAny" "allowToLighthouse"}
    allowAny.succeed("ping -c10 10.0.100.4")
    allowToLighthouse.succeed("ping -c10 10.0.100.2")

    # block lighthouse <-> allowFromLighthouse and allowAny <-> allowFromLighthouse; allowFromLighthouse won't get to allowAny
    ${blockTrafficBetween "allowFromLighthouse" "lighthouse"}
    ${blockTrafficBetween "allowFromLighthouse" "allowAny"}
    allowFromLighthouse.fail("ping -c3 10.0.100.2")
    ${allowTrafficBetween "allowFromLighthouse" "lighthouse"}
    ${allowTrafficBetween "allowFromLighthouse" "allowAny"}
    allowFromLighthouse.succeed("ping -c3 10.0.100.2")

    # block lighthouse <-> allowAny, allowAny <-> allowFromLighthouse, and allowAny <-> allowToLighthouse; it won't get to allowFromLighthouse or allowToLighthouse
    ${blockTrafficBetween "allowAny" "lighthouse"}
    ${blockTrafficBetween "allowAny" "allowFromLighthouse"}
    ${blockTrafficBetween "allowAny" "allowToLighthouse"}
    allowFromLighthouse.fail("ping -c3 10.0.100.2")
    allowAny.fail("ping -c3 10.0.100.3")
    allowAny.fail("ping -c3 10.0.100.4")
    ${allowTrafficBetween "allowAny" "lighthouse"}
    ${allowTrafficBetween "allowAny" "allowFromLighthouse"}
    ${allowTrafficBetween "allowAny" "allowToLighthouse"}
    allowFromLighthouse.succeed("ping -c3 10.0.100.2")
    allowAny.succeed("ping -c3 10.0.100.3")
    allowAny.succeed("ping -c3 10.0.100.4")

    # block lighthouse <-> allowToLighthouse and allowToLighthouse <-> allowAny; it won't get to allowAny
    ${blockTrafficBetween "allowToLighthouse" "lighthouse"}
    ${blockTrafficBetween "allowToLighthouse" "allowAny"}
    allowAny.fail("ping -c3 10.0.100.4")
    allowToLighthouse.fail("ping -c3 10.0.100.2")
    ${allowTrafficBetween "allowToLighthouse" "lighthouse"}
    ${allowTrafficBetween "allowToLighthouse" "allowAny"}
    allowAny.succeed("ping -c3 10.0.100.4")
    allowToLighthouse.succeed("ping -c3 10.0.100.2")
  '';
})
