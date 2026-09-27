{ pkgs, lib, ... }:
let

  # We'll need to be able to trade cert files between nodes via scp.
  inherit (import ../ssh-keys.nix pkgs)
    snakeOilPrivateKey
    snakeOilPublicKey
    ;

  makeNebulaNode =
    { config, ... }:
    name: extraConfig:
    lib.mkMerge [
      {
        # Expose nebula for doing cert signing.
        environment.systemPackages = [
          pkgs.dig
          pkgs.nebula
          pkgs.jq
        ];
        users.users.root.openssh.authorizedKeys.keys = [ snakeOilPublicKey ];
        services.openssh.enable = true;
        networking.firewall.enable = true; # Implicitly true, but let's make sure.
        networking.interfaces.eth1.useDHCP = false;

        services.nebula.networks.smoke = {
          # Note that these paths won't exist when the machine is first booted.
          ca = "/etc/nebula/ca.crt";
          cert = "/etc/nebula/${name}.crt";
          key = "/etc/nebula/${name}.key";
          listen = {
            host = "::";
            port =
              if
                (
                  config.services.nebula.networks.smoke.isLighthouse || config.services.nebula.networks.smoke.isRelay
                )
              then
                4242
              else
                0;
          };
        };
      }
      extraConfig
    ];

in
{
  name = "nebula";

  nodes = {

    lighthouse =
      { ... }@args:
      makeNebulaNode args "lighthouse" {
        networking.firewall.allowedUDPPorts = [ 53 ];
        networking.interfaces.eth1 = {
          ipv4.addresses = lib.mkForce [
            {
              address = "192.168.1.1";
              prefixLength = 24;
            }
          ];
          ipv6.addresses = lib.mkForce [
            {
              address = "3fff::1";
              prefixLength = 64;
            }
          ];
        };

        services.nebula.networks.smoke = {
          isLighthouse = true;
          isRelay = true;
          firewall = {
            outbound = [
              {
                port = "any";
                proto = "any";
                host = "any";
              }
            ];
            inbound = [
              {
                port = "any";
                proto = "any";
                host = "any";
              }
            ];
          };
          lighthouse = {
            dns = {
              enable = true;
              host = "10.0.100.1"; # bind to lighthouse interface
              port = 53; # answer on standard DNS port
            };
          };
        };
      };

    allowAny =
      { ... }@args:
      makeNebulaNode args "allowAny" {
        networking.interfaces.eth1 = {
          ipv4.addresses = lib.mkForce [
            {
              address = "192.168.1.2";
              prefixLength = 24;
            }
          ];
          ipv6.addresses = lib.mkForce [
            {
              address = "3fff::2";
              prefixLength = 64;
            }
          ];
        };

        services.nebula.networks.smoke = {
          staticHostMap = {
            "10.0.100.1" = [
              "192.168.1.1:4242"
              "[3fff::1]:4242"
            ];
          };
          isLighthouse = false;
          lighthouses = [ "10.0.100.1" ];
          relays = [ "10.0.100.1" ];
          firewall = {
            outbound = [
              {
                port = "any";
                proto = "any";
                host = "any";
              }
            ];
            inbound = [
              {
                port = "any";
                proto = "any";
                host = "any";
              }
            ];
          };
        };
      };

    allowFromLighthouse =
      { ... }@args:
      makeNebulaNode args "allowFromLighthouse" {
        networking.interfaces.eth1 = {
          ipv6.addresses = lib.mkForce [
            {
              address = "3fff::3";
              prefixLength = 64;
            }
          ];
        };

        services.nebula.networks.smoke = {
          staticHostMap = {
            "10.0.100.1" = [
              "192.168.1.1:4242"
              "[3fff::1]:4242"
            ];
          };
          isLighthouse = false;
          lighthouses = [ "10.0.100.1" ];
          relays = [ "10.0.100.1" ];
          firewall = {
            outbound = [
              {
                port = "any";
                proto = "any";
                host = "any";
              }
            ];
            inbound = [
              {
                port = "any";
                proto = "any";
                host = "lighthouse";
              }
            ];
          };
        };
      };

    allowToLighthouse =
      { ... }@args:
      makeNebulaNode args "allowToLighthouse" {
        networking.interfaces.eth1.ipv4.addresses = lib.mkForce [
          {
            address = "192.168.1.4";
            prefixLength = 24;
          }
        ];

        services.nebula.networks.smoke = {
          enable = true;
          staticHostMap = {
            "10.0.100.1" = [
              "192.168.1.1:4242"
              "[3fff::1]:4242"
            ];
          };
          isLighthouse = false;
          lighthouses = [ "10.0.100.1" ];
          relays = [ "10.0.100.1" ];
          firewall = {
            outbound = [
              {
                port = "any";
                proto = "any";
                host = "lighthouse";
              }
            ];
            inbound = [
              {
                port = "any";
                proto = "any";
                host = "any";
              }
            ];
          };
        };
      };

    disabled =
      { ... }@args:
      makeNebulaNode args "disabled" {
        networking.interfaces.eth1.ipv4.addresses = lib.mkForce [
          {
            address = "192.168.1.5";
            prefixLength = 24;
          }
        ];

        services.nebula.networks.smoke = {
          enable = false;
          staticHostMap = {
            "10.0.100.1" = [
              "192.168.1.1:4242"
            ];
          };
          isLighthouse = false;
          lighthouses = [ "10.0.100.1" ];
          relays = [ "10.0.100.1" ];
          firewall = {
            outbound = [
              {
                port = "any";
                proto = "any";
                host = "lighthouse";
              }
            ];
            inbound = [
              {
                port = "any";
                proto = "any";
                host = "any";
              }
            ];
          };
        };
      };

  };

  testScript =
    let

      setUpPrivateKey = name: ''
        ${name}.start()
        ${name}.succeed(
            "mkdir -p /root/.ssh",
            "chmod 700 /root/.ssh",
            "cat '${snakeOilPrivateKey}' > /root/.ssh/id_snakeoil",
            "chmod 600 /root/.ssh/id_snakeoil",
            "mkdir -p /root"
        )
      '';

      # From what I can tell, StrictHostKeyChecking=no is necessary for ssh to work between machines.
      sshOpts = "-oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null -oIdentityFile=/root/.ssh/id_snakeoil";

      restartAndCheckNebula = name: ip: ''
        ${name}.systemctl("restart nebula@smoke.service")
        ${name}.wait_until_succeeds("ping -c1 -W1 ${ip}", timeout=10)
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
            'nebula-cert sign -duration $((365*24*60))m -ca-crt /etc/nebula/ca.crt -ca-key /etc/nebula/ca.key -name "${name}" -groups "${name}" -networks "${ip}" -in-pub /root/${name}.pub -out-crt /root/${name}.crt'
        )
        ${name}.succeed(
            "scp ${sshOpts} root@192.168.1.1:/root/${name}.crt /etc/nebula/${name}.crt",
            "scp ${sshOpts} root@192.168.1.1:/etc/nebula/ca.crt /etc/nebula/ca.crt",
            '(id nebula-smoke >/dev/null && chown -R nebula-smoke:nebula-smoke /etc/nebula) || true'
        )
      '';

      getPublicIpv4 = node: ''
        ${node}.succeed("ip --json addr show eth1 | jq -r '.[0].addr_info | map(select(.family == \"inet\")) | map(.local) | join(\",\")'").strip()
      '';

      getPublicIpv6 = node: ''
        ${node}.succeed("ip --json addr show eth1 | jq -r '.[0].addr_info | map(select(.family == \"inet6\")) | map(.local) | join(\",\")'").strip()
      '';

      # Never do this for anything security critical! (Thankfully it's just a test.)
      # Restart Nebula right after the mutual block and/or restore so the state is fresh.
      blockTrafficBetweenV4 = nodeA: nodeB: ''
        node_a_4 = ${getPublicIpv4 nodeA}
        node_b_4 = ${getPublicIpv4 nodeB}
        ${nodeA}.succeed("iptables -I INPUT -s " + node_b_4 + " -j DROP")
        ${nodeB}.succeed("iptables -I INPUT -s " + node_a_4 + " -j DROP")
        ${nodeA}.systemctl("restart nebula@smoke.service")
        ${nodeB}.systemctl("restart nebula@smoke.service")
      '';
      allowTrafficBetweenV4 = nodeA: nodeB: ''
        node_a_4 = ${getPublicIpv4 nodeA}
        node_b_4 = ${getPublicIpv4 nodeB}
        ${nodeA}.succeed("iptables -D INPUT -s " + node_b_4 + " -j DROP")
        ${nodeB}.succeed("iptables -D INPUT -s " + node_a_4 + " -j DROP")
        ${nodeA}.systemctl("restart nebula@smoke.service")
        ${nodeB}.systemctl("restart nebula@smoke.service")
      '';
      blockTrafficBetweenV6 = nodeA: nodeB: ''
        node_a_6 = ${getPublicIpv6 nodeA}
        node_b_6 = ${getPublicIpv6 nodeB}
        ${nodeA}.succeed("ip6tables -I INPUT -i eth1 -s " + node_b_6 + " -j DROP")
        ${nodeB}.succeed("ip6tables -I INPUT -i eth1 -s " + node_a_6 + " -j DROP")
        ${nodeA}.systemctl("restart nebula@smoke.service")
        ${nodeB}.systemctl("restart nebula@smoke.service")
      '';
      allowTrafficBetweenV6 = nodeA: nodeB: ''
        node_a_6 = ${getPublicIpv6 nodeA}
        node_b_6 = ${getPublicIpv6 nodeB}
        ${nodeA}.succeed("ip6tables -D INPUT -i eth1 -s " + node_b_6 + " -j DROP")
        ${nodeB}.succeed("ip6tables -D INPUT -i eth1 -s " + node_a_6 + " -j DROP")
        ${nodeA}.systemctl("restart nebula@smoke.service")
        ${nodeB}.systemctl("restart nebula@smoke.service")
      '';

      blockTrafficBetween = nodeA: nodeB: ''
        ${blockTrafficBetweenV4 nodeA nodeB}
        ${blockTrafficBetweenV6 nodeA nodeB}
      '';
      allowTrafficBetween = nodeA: nodeB: ''
        ${allowTrafficBetweenV4 nodeA nodeB}
        ${allowTrafficBetweenV6 nodeA nodeB}
      '';
    in
    ''
      # Create the certificate and sign the lighthouse's keys.
      ${setUpPrivateKey "lighthouse"}
      lighthouse.succeed(
          "mkdir -p /etc/nebula",
          'nebula-cert ca -duration $((10*365*24*60))m -name "Smoke Test" -out-crt /etc/nebula/ca.crt -out-key /etc/nebula/ca.key',
          'nebula-cert sign -duration $((365*24*60))m -ca-crt /etc/nebula/ca.crt -ca-key /etc/nebula/ca.key -name "lighthouse" -groups "lighthouse" -networks "10.0.100.1/24,2001:db8::1/64" -out-crt /etc/nebula/lighthouse.crt -out-key /etc/nebula/lighthouse.key',
          'chown -R nebula-smoke:nebula-smoke /etc/nebula'
      )

      # Reboot the lighthouse and verify that the nebula service comes up on boot.
      # Since rebooting takes a while, we'll just restart the service on the other nodes.
      lighthouse.shutdown()
      lighthouse.start()
      lighthouse.wait_for_unit("nebula@smoke.service")
      lighthouse.wait_until_succeeds("ping -c1 -W1 10.0.100.1", timeout=10)
      lighthouse.wait_until_succeeds("ping -c1 -W1 2001:db8::1", timeout=10)

      # Start all the machines to be set up
      allowAny.start()
      allowFromLighthouse.start()
      allowToLighthouse.start()
      disabled.start()

      # Create keys for allowAny's nebula service and test that it comes up.
      ${setUpPrivateKey "allowAny"}
      ${signKeysFor "allowAny" "10.0.100.2/24,2001:db8::2/64"}
      ${restartAndCheckNebula "allowAny" "10.0.100.2"}
      ${restartAndCheckNebula "allowAny" "2001:db8::2"}

      # Create keys for allowFromLighthouse's nebula service and test that it comes up.
      ${setUpPrivateKey "allowFromLighthouse"}
      ${signKeysFor "allowFromLighthouse" "10.0.100.3/24,2001:db8::3/64"}
      ${restartAndCheckNebula "allowFromLighthouse" "10.0.100.3"}
      ${restartAndCheckNebula "allowFromLighthouse" "2001:db8::3"}

      # Create keys for allowToLighthouse's nebula service and test that it comes up.
      ${setUpPrivateKey "allowToLighthouse"}
      ${signKeysFor "allowToLighthouse" "10.0.100.4/24,2001:db8::4/64"}
      ${restartAndCheckNebula "allowToLighthouse" "10.0.100.4"}
      ${restartAndCheckNebula "allowToLighthouse" "2001:db8::4"}

      # Create keys for disabled's nebula service and test that it does not come up.
      ${setUpPrivateKey "disabled"}
      ${signKeysFor "disabled" "10.0.100.5/24,2001:db8::5/64"}
      disabled.fail("systemctl status nebula@smoke.service")
      disabled.fail("ping -c3 -W1 10.0.100.5")
      disabled.fail("ping -c3 -W1 2001:db8::5")

      # The lighthouse can ping allowAny and allowFromLighthouse but not disabled
      lighthouse.wait_until_succeeds("ping -c1 -W1 10.0.100.2", timeout=10)
      lighthouse.wait_until_succeeds("ping -c1 -W1 2001:db8::2", timeout=10)
      lighthouse.wait_until_succeeds("ping -c1 -W1 10.0.100.3", timeout=10)
      lighthouse.wait_until_succeeds("ping -c1 -W1 2001:db8::3", timeout=10)
      lighthouse.fail("ping -c3 -W1 10.0.100.5")
      lighthouse.fail("ping -c3 -W1 2001:db8::5")

      # allowAny can ping the lighthouse, but not allowFromLighthouse because of its inbound firewall
      allowAny.wait_until_succeeds("ping -c1 -W1 10.0.100.1", timeout=10)
      allowAny.wait_until_succeeds("ping -c1 -W1 2001:db8::1", timeout=10)
      allowAny.fail("ping -c3 -W1 10.0.100.3")
      allowAny.fail("ping -c3 -W1 2001:db8::3")
      # allowAny can also resolve DNS on lighthouse
      allowAny.succeed("dig @10.0.100.1 allowToLighthouse A | grep -E 'allowToLighthouse\.\s+[0-9]+\s+IN\s+A\s+10\.0\.100\.4'")
      allowAny.succeed("dig @10.0.100.1 allowToLighthouse AAAA | grep -E 'allowToLighthouse\.\s+[0-9]+\s+IN\s+AAAA\s+2001:db8::4'")

      # allowFromLighthouse can ping the lighthouse and allowAny
      allowFromLighthouse.wait_until_succeeds("ping -c1 -W1 10.0.100.1", timeout=10)
      allowFromLighthouse.wait_until_succeeds("ping -c1 -W1 2001:db8::1", timeout=10)
      allowFromLighthouse.wait_until_succeeds("ping -c1 -W1 10.0.100.2", timeout=10)
      allowFromLighthouse.wait_until_succeeds("ping -c1 -W1 2001:db8::2", timeout=10)

      # allowAny does IPv6 -> IPv4 and IPv4 -> IPv6 switchover for the underlay network
      ${blockTrafficBetweenV4 "lighthouse" "allowAny"}
      ${blockTrafficBetweenV6 "lighthouse" "allowToLighthouse"}
      ${blockTrafficBetweenV6 "allowAny" "allowToLighthouse"}
      allowAny.wait_until_succeeds("ping -c1 -W1 10.0.100.1", timeout=10)
      allowAny.wait_until_succeeds("ping -c1 -W1 2001:db8::1", timeout=10)
      allowAny.wait_until_succeeds("ping -c1 -W1 10.0.100.4", timeout=10)
      allowAny.wait_until_succeeds("ping -c1 -W1 2001:db8::4", timeout=10)
      ${blockTrafficBetweenV6 "lighthouse" "allowAny"}
      allowAny.fail("ping -c3 -W1 10.0.100.1")
      allowAny.fail("ping -c3 -W1 2001:db8::4")
      ${allowTrafficBetweenV4 "lighthouse" "allowAny"}
      allowAny.wait_until_succeeds("ping -c1 -W1 192.168.1.1", timeout=10)
      allowAny.wait_until_succeeds("ping -c1 -W1 10.0.100.1", timeout=15)
      allowAny.wait_until_succeeds("ping -c1 -W1 10.0.100.4", timeout=15)
      ${allowTrafficBetweenV6 "lighthouse" "allowAny"}
      ${allowTrafficBetweenV6 "lighthouse" "allowToLighthouse"}
      ${allowTrafficBetweenV6 "allowAny" "allowToLighthouse"}

      # block allowFromLighthouse <-> allowAny, and allowFromLighthouse -> allowAny should still work.
      ${blockTrafficBetween "allowFromLighthouse" "allowAny"}
      allowFromLighthouse.wait_until_succeeds("ping -c1 -W1 2001:db8::2", timeout=10)
      allowFromLighthouse.wait_until_succeeds("ping -c1 -W1 10.0.100.2", timeout=10)
      ${allowTrafficBetween "allowFromLighthouse" "allowAny"}
      allowFromLighthouse.wait_until_succeeds("ping -c1 -W1 10.0.100.2", timeout=10)
      allowFromLighthouse.wait_until_succeeds("ping -c1 -W1 2001:db8::2", timeout=10)

      # allowToLighthouse can ping the lighthouse but not allowAny or allowFromLighthouse
      allowToLighthouse.wait_until_succeeds("ping -c1 -W1 10.0.100.1", timeout=10)
      allowToLighthouse.wait_until_succeeds("ping -c1 -W1 2001:db8::1", timeout=10)
      allowToLighthouse.fail("ping -c3 -W1 10.0.100.2")
      allowToLighthouse.fail("ping -c3 -W1 2001:db8::2")
      allowToLighthouse.fail("ping -c3 -W1 10.0.100.3")
      allowToLighthouse.fail("ping -c3 -W1 2001:db8::3")

      # allowAny can ping allowFromLighthouse now that allowFromLighthouse pinged it first
      allowAny.wait_until_succeeds("ping -c1 -W1 10.0.100.3", timeout=10)
      allowAny.wait_until_succeeds("ping -c1 -W1 2001:db8::3", timeout=10)

      # block allowAny <-> allowFromLighthouse, and allowAny -> allowFromLighthouse should still work.
      ${blockTrafficBetween "allowAny" "allowFromLighthouse"}
      allowFromLighthouse.wait_until_succeeds("ping -c1 -W1 10.0.100.2", timeout=10)
      allowFromLighthouse.wait_until_succeeds("ping -c1 -W1 2001:db8::2", timeout=10)
      allowAny.wait_until_succeeds("ping -c1 -W1 10.0.100.3", timeout=10)
      allowAny.wait_until_succeeds("ping -c1 -W1 2001:db8::3", timeout=10)
      ${allowTrafficBetween "allowAny" "allowFromLighthouse"}
      allowFromLighthouse.wait_until_succeeds("ping -c1 -W1 10.0.100.2", timeout=10)
      allowFromLighthouse.wait_until_succeeds("ping -c1 -W1 2001:db8::2", timeout=10)
      allowAny.wait_until_succeeds("ping -c1 -W1 10.0.100.3", timeout=10)
      allowAny.wait_until_succeeds("ping -c1 -W1 2001:db8::3", timeout=10)

      # allowToLighthouse can ping allowAny if allowAny pings it first
      allowAny.wait_until_succeeds("ping -c1 -W1 10.0.100.4", timeout=10)
      allowAny.wait_until_succeeds("ping -c1 -W1 2001:db8::4", timeout=10)
      allowToLighthouse.wait_until_succeeds("ping -c1 -W1 10.0.100.2", timeout=10)
      allowToLighthouse.wait_until_succeeds("ping -c1 -W1 2001:db8::2", timeout=10)

      # block allowToLighthouse <-> allowAny, and allowAny <-> allowToLighthouse should still work.
      ${blockTrafficBetween "allowAny" "allowToLighthouse"}
      allowAny.wait_until_succeeds("ping -c1 -W1 10.0.100.4", timeout=10)
      allowAny.wait_until_succeeds("ping -c1 -W1 2001:db8::4", timeout=10)
      allowToLighthouse.wait_until_succeeds("ping -c1 -W1 10.0.100.2", timeout=10)
      allowToLighthouse.wait_until_succeeds("ping -c1 -W1 2001:db8::2", timeout=10)
      ${allowTrafficBetween "allowAny" "allowToLighthouse"}
      allowAny.wait_until_succeeds("ping -c1 -W1 10.0.100.4", timeout=10)
      allowAny.wait_until_succeeds("ping -c1 -W1 2001:db8::4", timeout=10)
      allowToLighthouse.wait_until_succeeds("ping -c1 -W1 10.0.100.2", timeout=10)
      allowToLighthouse.wait_until_succeeds("ping -c1 -W1 2001:db8::2", timeout=10)

      # block lighthouse <-> allowFromLighthouse and allowAny <-> allowFromLighthouse; allowFromLighthouse won't get to allowAny
      ${blockTrafficBetween "allowFromLighthouse" "lighthouse"}
      ${blockTrafficBetween "allowFromLighthouse" "allowAny"}
      allowFromLighthouse.fail("ping -c3 -W1 10.0.100.2")
      allowFromLighthouse.fail("ping -c3 -W1 2001:db8::2")
      ${allowTrafficBetween "allowFromLighthouse" "lighthouse"}
      ${allowTrafficBetween "allowFromLighthouse" "allowAny"}
      allowFromLighthouse.wait_until_succeeds("ping -c1 -W1 10.0.100.2", timeout=10)
      allowFromLighthouse.wait_until_succeeds("ping -c1 -W1 2001:db8::2", timeout=10)

      # block lighthouse <-> allowAny, allowAny <-> allowFromLighthouse, and allowAny <-> allowToLighthouse; it won't get to allowFromLighthouse or allowToLighthouse
      ${blockTrafficBetween "allowAny" "lighthouse"}
      ${blockTrafficBetween "allowAny" "allowFromLighthouse"}
      ${blockTrafficBetween "allowAny" "allowToLighthouse"}
      allowFromLighthouse.fail("ping -c3 -W1 10.0.100.2")
      allowFromLighthouse.fail("ping -c3 -W1 2001:db8::2")
      allowAny.fail("ping -c3 -W1 10.0.100.3")
      allowAny.fail("ping -c3 -W1 2001:db8::3")
      allowAny.fail("ping -c3 -W1 10.0.100.4")
      allowAny.fail("ping -c3 -W1 2001:db8::4")
      ${allowTrafficBetween "allowAny" "lighthouse"}
      ${allowTrafficBetween "allowAny" "allowFromLighthouse"}
      ${allowTrafficBetween "allowAny" "allowToLighthouse"}
      allowFromLighthouse.wait_until_succeeds("ping -c1 -W1 10.0.100.2", timeout=10)
      allowFromLighthouse.wait_until_succeeds("ping -c1 -W1 2001:db8::2", timeout=10)
      allowAny.wait_until_succeeds("ping -c1 -W1 10.0.100.3", timeout=10)
      allowAny.wait_until_succeeds("ping -c1 -W1 2001:db8::3", timeout=10)
      allowAny.wait_until_succeeds("ping -c1 -W1 10.0.100.4", timeout=10)
      allowAny.wait_until_succeeds("ping -c1 -W1 2001:db8::4", timeout=10)

      # block lighthouse <-> allowToLighthouse and allowToLighthouse <-> allowAny; it won't get to allowAny
      ${blockTrafficBetween "allowToLighthouse" "lighthouse"}
      ${blockTrafficBetween "allowToLighthouse" "allowAny"}
      allowAny.fail("ping -c3 -W1 10.0.100.4")
      allowAny.fail("ping -c3 -W1 2001:db8::4")
      allowToLighthouse.fail("ping -c3 -W1 10.0.100.2")
      allowToLighthouse.fail("ping -c3 -W1 2001:db8::2")
      ${allowTrafficBetween "allowToLighthouse" "lighthouse"}
      ${allowTrafficBetween "allowToLighthouse" "allowAny"}
      allowAny.wait_until_succeeds("ping -c1 -W1 10.0.100.4", timeout=10)
      allowToLighthouse.wait_until_succeeds("ping -c1 -W1 10.0.100.2", timeout=10)
    '';
}
