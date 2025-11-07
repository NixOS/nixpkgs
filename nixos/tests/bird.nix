{
  runTest,
  package,
}:

let
  makeBirdHost =
    hostId:
    { pkgs, ... }:
    {
      virtualisation.vlans = [ 1 ];

      environment.systemPackages = with pkgs; [ jq ];

      networking = {
        useNetworkd = true;
        useDHCP = false;
        firewall.enable = false;
      };

      systemd.network.networks."01-eth1" = {
        name = "eth1";
        networkConfig.Address = "10.0.0.${hostId}/24";
      };

      services.bird = {
        inherit package;

        enable = true;

        config = ''
          log syslog all;

          debug protocols all;

          router id 10.0.0.${hostId};

          protocol device {
          }

          protocol kernel kernel4 {
            ipv4 {
              import none;
              export all;
            };
          }

          protocol static static4 {
            ipv4;
            include "static4.conf";
          }

          protocol ospf v2 ospf4 {
            ipv4 {
              export all;
            };
            area 0 {
              interface "eth1" {
                hello 5;
                wait 5;
              };
            };
          }

          protocol kernel kernel6 {
            ipv6 {
              import none;
              export all;
            };
          }

          protocol static static6 {
            ipv6;
            include "static6.conf";
          }

          protocol ospf v3 ospf6 {
            ipv6 {
              export all;
            };
            area 0 {
              interface "eth1" {
                hello 5;
                wait 5;
              };
            };
          }
        '';

        preCheckConfig = ''
          echo "route 1.2.3.4/32 blackhole;" > static4.conf
          echo "route fd00::/128 blackhole;" > static6.conf
        '';
      };

      systemd.tmpfiles.rules = [
        "f /etc/bird/static4.conf - - - - route 10.10.0.${hostId}/32 blackhole;"
        "f /etc/bird/static6.conf - - - - route fdff::${hostId}/128 blackhole;"
      ];
    };
in
{
  twoNodeOSPF = runTest {
    name = "bird-twoNodeOSPF";

    nodes.host1 = makeBirdHost "1";
    nodes.host2 = makeBirdHost "2";

    testScript = ''
      start_all()

      host1.wait_for_unit("bird.service")
      host2.wait_for_unit("bird.service")

      host1.succeed("bird --version")
      host2.succeed("bird --version")

      host1.succeed("systemctl reload bird.service")

      with subtest("Waiting for advertised IPv4 routes"):
        host1.wait_until_succeeds("ip --json r | jq -e 'map(select(.dst == \"10.10.0.2\")) | any'")
        host2.wait_until_succeeds("ip --json r | jq -e 'map(select(.dst == \"10.10.0.1\")) | any'")
      with subtest("Waiting for advertised IPv6 routes"):
        host1.wait_until_succeeds("ip --json -6 r | jq -e 'map(select(.dst == \"fdff::2\")) | any'")
        host2.wait_until_succeeds("ip --json -6 r | jq -e 'map(select(.dst == \"fdff::1\")) | any'")

      with subtest("Check fake routes in preCheckConfig do not exist"):
        host1.fail("ip --json r | jq -e 'map(select(.dst == \"1.2.3.4\")) | any'")
        host2.fail("ip --json r | jq -e 'map(select(.dst == \"1.2.3.4\")) | any'")

        host1.fail("ip --json -6 r | jq -e 'map(select(.dst == \"fd00::\")) | any'")
        host2.fail("ip --json -6 r | jq -e 'map(select(.dst == \"fd00::\")) | any'")
    '';
  };
}
