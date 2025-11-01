let
  aliceIp6 = "201:f1f6:b019:6174:c3c9:42ec:6142:d2b4";
  aliceKeys = {
    PublicKey = "438253f9a7a2cf0daf44e7af4b52c0e03e505a6e03a5f7ebc16486e6ad7d5b7b";
    PrivateKeyPem = ''
      -----BEGIN PRIVATE KEY-----
      MC4CAQAwBQYDK2VwBCIEIJ+k6PQM5qO+aJx4h8blzMS9b3rDWWZdpoyGPrkF50gW
      -----END PRIVATE KEY-----
    '';
  };
  bobIp6 = "201:30d3:4bbe:ae0:8162:12bf:bb5c:e2bd";
  bobPrefix = "301:30d3:4bbe:ae0";
  bobConfig = {
    InterfacePeers = {
      eth1 = [ "tcp://192.168.1.200:12345" ];
    };
    MulticastInterfaces = [
      {
        Regex = ".*";
        Beacon = true;
        Listen = true;
        Port = 54321;
        Priority = 0;
      }
    ];
    PublicKey = "f6b50add59b20238c3f523cfe6093a2c14195fb3ba361b42969082d72d8fc21f";
    PrivateKeyPem = ''
      -----BEGIN PRIVATE KEY-----
      MC4CAQAwBQYDK2VwBCIEIP4N9UyIgglBZ2HysrC7qfALUdFub8eUTeyDAnMHsWy9
      -----END PRIVATE KEY-----
    '';
  };
  danIp6 = bobPrefix + "::2";

in
{ pkgs, ... }:
{
  name = "yggdrasil";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ gazally ];
  };

  nodes = {
    # Alice is listening for peerings on a specified port,
    # but has multicast peering disabled.  Alice has part of her
    # yggdrasil config in Nix and part of it in a file.
    alice =
      { ... }:
      {
        networking = {
          interfaces.eth1.ipv4.addresses = [
            {
              address = "192.168.1.200";
              prefixLength = 24;
            }
          ];
          firewall.allowedTCPPorts = [
            80
            12345
          ];
        };
        services.httpd.enable = true;
        services.httpd.adminAddr = "foo@example.org";

        services.yggdrasil = {
          enable = true;
          settings = {
            Listen = [ "tcp://0.0.0.0:12345" ];
            MulticastInterfaces = [ ];
            PublicKey = aliceKeys.PublicKey;
            PrivateKeyPath = toString (
              pkgs.writeTextFile {
                name = "yggdrasil-alice-private-key";
                text = aliceKeys.PrivateKeyPem;
              }
            );
          };
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
          settings = {
            InterfacePeers = bobConfig.InterfacePeers;
            MulticastInterfaces = bobConfig.MulticastInterfaces;
            PublicKey = bobConfig.PublicKey;
            PrivateKeyPath = toString (
              pkgs.writeTextFile {
                name = "yggdrasil-bob-private-key";
                text = bobConfig.PrivateKeyPem;
              }
            );
          };
        };

        boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = 1;

        networking = {
          bridges.br0.interfaces = [ ];
          interfaces.br0 = {
            ipv6.addresses = [
              {
                address = bobPrefix + "::1";
                prefixLength = 64;
              }
            ];
          };
        };

        # dan is a node inside a container running on bob's host.
        containers.dan = {
          autoStart = true;
          privateNetwork = true;
          hostBridge = "br0";
          config = {
            networking.interfaces.eth0.ipv6 = {
              addresses = [
                {
                  address = bobPrefix + "::2";
                  prefixLength = 64;
                }
              ];
              routes = [
                {
                  address = "200::";
                  prefixLength = 7;
                  via = bobPrefix + "::1";
                }
              ];
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
          extraArgs = [
            "-loglevel"
            "error"
          ];
          denyDhcpcdInterfaces = [ "ygg0" ];
          openMulticastPort = true;
          settings = {
            IfName = "ygg0";
            MulticastInterfaces = [
              {
                Regex = ".*";
                Beacon = true;
                Listen = true;
                Port = 43210;
              }
            ];
          };
        };
      };
  };

  testScript = ''
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
}
