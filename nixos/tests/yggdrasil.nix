let
  aliceIp6 = "200:3b91:b2d8:e708:fbf3:f06:fdd5:90d0";
  aliceKeys = {
    EncryptionPublicKey = "13e23986fe76bc3966b42453f479bc563348b7ff76633b7efcb76e185ec7652f";
    EncryptionPrivateKey = "9f86947b15e86f9badac095517a1982e39a2db37ca726357f95987b898d82208";
    SigningPublicKey = "e2c43349083bc1e998e4ec4535b4c6a8f44ca9a5a8e07336561267253b2be5f4";
    SigningPrivateKey = "fe3add8da35316c05f6d90d3ca79bd2801e6ccab6d37e5339fef4152589398abe2c43349083bc1e998e4ec4535b4c6a8f44ca9a5a8e07336561267253b2be5f4";
  };
  bobIp6 = "201:ebbd:bde9:f138:c302:4afa:1fb6:a19a";
  bobPrefix = "301:ebbd:bde9:f138";
  bobConfig = {
    InterfacePeers = {
      eth1 = [ "tcp://192.168.1.200:12345" ];
    };
    MulticastInterfaces = [ "eth1" ];
    LinkLocalTCPPort = 54321;
    EncryptionPublicKey = "c99d6830111e12d1b004c52fe9e5a2eef0f6aefca167aca14589a370b7373279";
    EncryptionPrivateKey = "2e698a53d3fdce5962d2ff37de0fe77742a5c8b56cd8259f5da6aa792f6e8ba3";
    SigningPublicKey = "de111da0ec781e45bf6c63ecb45a78c24d7d4655abfaeea83b26c36eb5c0fd5b";
    SigningPrivateKey = "2a6c21550f3fca0331df50668ffab66b6dce8237bcd5728e571e8033b363e247de111da0ec781e45bf6c63ecb45a78c24d7d4655abfaeea83b26c36eb5c0fd5b";
  };
  danIp6 = bobPrefix + "::2";

in import ./make-test-python.nix ({ pkgs, ...} : {
  name = "yggdrasil";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ gazally ];
  };

  nodes = rec {
    # Alice is listening for peerings on a specified port,
    # but has multicast peering disabled.  Alice has part of her
    # yggdrasil config in Nix and part of it in a file.
    alice =
      { ... }:
      {
        networking = {
          interfaces.eth1.ipv4.addresses = [{
            address = "192.168.1.200";
            prefixLength = 24;
          }];
          firewall.allowedTCPPorts = [ 80 12345 ];
        };
        services.httpd.enable = true;
        services.httpd.adminAddr = "foo@example.org";

        services.yggdrasil = {
          enable = true;
          config = {
            Listen = ["tcp://0.0.0.0:12345"];
            MulticastInterfaces = [ ];
          };
          configFile = toString (pkgs.writeTextFile {
                         name = "yggdrasil-alice-conf";
                         text = builtins.toJSON aliceKeys;
                       });
        };
      };

    # Bob is set up to peer with Alice, and also to do local multicast
    # peering.  Bob's yggdrasil config is in a file.
    bob =
      { ... }:
      {
        networking.firewall.allowedTCPPorts = [ 54321 ];
        services.yggdrasil = {
          enable = true;
          openMulticastPort = true;
          configFile = toString (pkgs.writeTextFile {
                         name = "yggdrasil-bob-conf";
                         text = builtins.toJSON bobConfig;
                       });
        };

        boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = 1;

        networking = {
          bridges.br0.interfaces = [ ];
          interfaces.br0 = {
            ipv6.addresses = [{
              address = bobPrefix + "::1";
              prefixLength = 64;
            }];
          };
        };

        # dan is a node inside a container running on bob's host.
        containers.dan = {
          autoStart = true;
          privateNetwork = true;
          hostBridge = "br0";
          config = { config, pkgs, ... }: {
            networking.interfaces.eth0.ipv6 = {
              addresses = [{
                address = bobPrefix + "::2";
                prefixLength = 64;
              }];
              routes = [{
                address = "200::";
                prefixLength = 7;
                via = bobPrefix + "::1";
              }];
            };
            services.httpd.enable = true;
            services.httpd.adminAddr = "foo@example.org";
            networking.firewall.allowedTCPPorts = [ 80 ];
          };
        };
      };

    # Carol only does local peering.  Carol's yggdrasil config is all Nix.
    carol =
      { ... }:
      {
        networking.firewall.allowedTCPPorts = [ 43210 ];
        services.yggdrasil = {
          enable = true;
          denyDhcpcdInterfaces = [ "ygg0" ];
          config = {
            IfTAPMode = true;
            IfName = "ygg0";
            MulticastInterfaces = [ "eth1" ];
            LinkLocalTCPPort = 43210;
          };
          persistentKeys = true;
        };
      };
    };

  testScript =
    ''
      import re

      # Give Alice a head start so she is ready when Bob calls.
      alice.start()
      alice.wait_for_unit("yggdrasil.service")

      bob.start()
      carol.start()
      bob.wait_for_unit("default.target")
      carol.wait_for_unit("yggdrasil.service")

      ip_addr_show = "ip -o -6 addr show dev ygg0 scope global"
      carol.wait_until_succeeds(f"[ `{ip_addr_show} | grep -v tentative | wc -l` -ge 1 ]")
      carol_ip6 = re.split(" +|/", carol.succeed(ip_addr_show))[3]

      # If Alice can talk to Carol, then Bob's outbound peering and Carol's
      # local peering have succeeded and everybody is connected.
      alice.wait_until_succeeds(f"ping -c 1 {carol_ip6}")
      alice.succeed(f"ping -c 1 ${bobIp6}")

      bob.succeed("ping -c 1 ${aliceIp6}")
      bob.succeed(f"ping -c 1 {carol_ip6}")

      carol.succeed("ping -c 1 ${aliceIp6}")
      carol.succeed("ping -c 1 ${bobIp6}")
      carol.succeed("ping -c 1 ${bobPrefix}::1")
      carol.succeed("ping -c 8 ${danIp6}")

      carol.fail("journalctl -u dhcpcd | grep ygg0")

      alice.wait_for_unit("httpd.service")
      carol.succeed("curl --fail -g http://[${aliceIp6}]")
      carol.succeed("curl --fail -g http://[${danIp6}]")
    '';
})
