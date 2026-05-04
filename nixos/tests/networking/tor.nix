{ lib, ... }:
{
  name = "networking-tor";
  meta.maintainers = with lib.maintainers; [ deade1e ];

  nodes = {
    client =
      { ... }:
      {
        networking.tor = {
          transPort = 8040;
          dnsPort = 8053;
          client.enable = true;
        };
      };

    router =
      { ... }:
      {
        networking.tor = {
          transPort = 7040;
          dnsPort = 7053;
          router.enable = true;
        };
      };
  };

  testScript = ''
    client.wait_for_unit("tor.service")
    client.succeed("nft list ruleset | grep tor_nat_output")
    client.succeed("nft list ruleset | grep tor_filter_output")
    client.succeed("ss -tlpn | grep -F '127.0.0.1:8040'")
    client.succeed("ss -ulpn | grep -F '127.0.0.1:8053'")
    client.succeed("cat /proc/sys/net/ipv4/ip_forward | grep 0")

    router.wait_for_unit("tor.service")
    router.succeed("nft list ruleset | grep tor_nat_prerouting")
    router.succeed("nft list ruleset | grep tor_filter_forward")
    router.succeed("ss -tlpn | grep -F '0.0.0.0:7040'")
    router.succeed("ss -ulpn | grep -F '0.0.0.0:7053'")
    router.succeed("cat /proc/sys/net/ipv4/ip_forward | grep 1")
  '';
}
