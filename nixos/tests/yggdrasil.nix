let
  aliceIp6 = "202:b70:9b0b:cf34:f93c:8f18:bbfd:7034";
  aliceKeys = {
    PublicKey = "3e91ec9e861960d86e1ce88051f97c435bdf2859640ab681dfa906eb45ad5182";
    PrivateKey = "a867f9e078e4ce58d310cf5acd4622d759e2a21df07e1d6fc380a2a26489480d3e91ec9e861960d86e1ce88051f97c435bdf2859640ab681dfa906eb45ad5182";
  };
  bobIp6 = "202:a483:73a4:9f2d:a559:4a19:bc9:8458";
  bobPrefix = "302:a483:73a4:9f2d";
  bobConfig = {
    InterfacePeers = {
      eth1 = [ "tcp://192.168.1.200:12345" ];
    };
    MulticastInterfaces = [ {
      Regex = ".*";
      Beacon = true;
      Listen = true;
      Port = 54321;
      Priority = 0;
    } ];
    PublicKey = "2b6f918b6c1a4b54d6bcde86cf74e074fb32ead4ee439b7930df2aa60c825186";
    PrivateKey = "0c4a24acd3402722ce9277ed179f4a04b895b49586493c25fbaed60653d857d62b6f918b6c1a4b54d6bcde86cf74e074fb32ead4ee439b7930df2aa60c825186";
  };
  danIp6 = bobPrefix + "::2";

in import ./make-test-python.nix ({ pkgs, ...} : {
  name = "yggdrasil";
  meta = with pkgs.lib.maintainers; {
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
          settings = {
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
          extraArgs = [ "-loglevel" "error" ];
          denyDhcpcdInterfaces = [ "ygg0" ];
          settings = {
            IfTAPMode = true;
            IfName = "ygg0";
            MulticastInterfaces = [
              {
                Port = 43210;
              }
            ];
            openMulticastPort = true;
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
      alice.succeed("ping -c 1 ${bobIp6}")

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
