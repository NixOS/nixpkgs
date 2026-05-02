{ lib, ... }:
{
  name = "networking-tor";
  meta.maintainers = with lib.maintainers; [ deade1e ];

  nodes = {
    client =
      { ... }:
      {
        networking.tor.client.enable = true;
      };

    router =
      { ... }:
      {
        networking.tor.router.enable = true;
      };
  };

  testScript = ''
    client.wait_for_unit("tor.service")
    client.succeed("nft list ruleset | grep tor_nat_output")
    client.succeed("nft list ruleset | grep tor_filter_output")
    client.succeed("ss -tlpn | grep -F '127.0.0.1:9040'")
    client.succeed("ss -ulpn | grep -F '127.0.0.1:9053'")
    client.succeed("cat /proc/sys/net/ipv4/ip_forward | grep 0")

    router.wait_for_unit("tor.service")
    router.succeed("nft list ruleset | grep tor_nat_prerouting")
    router.succeed("nft list ruleset | grep tor_filter_forward")
    router.succeed("ss -tlpn | grep -F '0.0.0.0:9040'")
    router.succeed("ss -ulpn | grep -F '0.0.0.0:9053'")
    router.succeed("cat /proc/sys/net/ipv4/ip_forward | grep 1")
  '';
}
