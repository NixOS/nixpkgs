# Test of IPv6 functionality in NixOS, including whether router
# solicication/advertisement using radvd works.

{ pkgs, lib, ... }:
{
  name = "ipv6";
  meta = {
    maintainers = [ ];
  };

  nodes = {
    # We use lib.mkForce here to remove the interface configuration
    # provided by makeTest, so that the interfaces are all configured
    # implicitly.

    # This client should use privacy extensions fully, having a
    # completely-default network configuration.
    client_defaults.networking.interfaces = lib.mkForce { };

    # Both of these clients should obtain temporary addresses, but
    # not use them as the default source IP. We thus run the same
    # checks against them — but the configuration resulting in this
    # behaviour is different.

    # Here, by using an altered default value for the global setting...
    client_global_setting = {
      networking.interfaces = lib.mkForce { };
      networking.tempAddresses = "enabled";
    };
    # and here, by setting this on the interface explicitly.
    client_interface_setting = {
      networking.tempAddresses = "disabled";
      networking.interfaces = lib.mkForce {
        eth1.tempAddress = "enabled";
      };
    };

    server = {
      services.httpd.enable = true;
      services.httpd.adminAddr = "foo@example.org";
      networking.firewall.allowedTCPPorts = [ 80 ];
      # disable testing driver's default IPv6 address.
      networking.interfaces.eth1.ipv6.addresses = lib.mkForce [ ];
    };

    router =
      { ... }:
      {
        services.radvd.enable = true;
        services.radvd.config = ''
          interface eth1 {
            AdvSendAdvert on;
            # ULA prefix (RFC 4193).
            prefix fd60:cc69:b537:1::/64 { };
          };
        '';
      };
  };

  testScript = ''
    import re

    # Start the router first so that it respond to router solicitations.
    router.wait_for_unit("radvd")

    clients = [client_defaults, client_global_setting, client_interface_setting]

    start_all()

    for client in clients:
        client.wait_for_unit("network.target")
    server.wait_for_unit("network.target")
    server.wait_for_unit("httpd.service")

    # Wait until the given interface has a non-tentative address of
    # the desired scope (i.e. has completed Duplicate Address
    # Detection).
    def wait_for_address(machine, iface, scope, temporary=False):
        temporary_flag = "temporary" if temporary else "-temporary"
        cmd = f"ip -o -6 addr show dev {iface} scope {scope} -tentative {temporary_flag}"

        machine.wait_until_succeeds(f"[ `{cmd} | wc -l` -eq 1 ]")
        output = machine.succeed(cmd)
        ip = re.search(r"inet6 ([0-9a-f:]{2,})/", output).group(1)

        if temporary:
            scope = scope + " temporary"
        machine.log(f"{scope} address on {iface} is {ip}")
        return ip


    with subtest("Loopback address can be pinged"):
        client_defaults.succeed("ping -c 1 ::1 >&2")
        client_defaults.fail("ping -c 1 2001:db8:: >&2")

    with subtest("Local link addresses can be obtained and pinged"):
        for client in clients:
            client_ip = wait_for_address(client, "eth1", "link")
            server_ip = wait_for_address(server, "eth1", "link")
            client.succeed(f"ping -c 1 {client_ip}%eth1 >&2")
            client.succeed(f"ping -c 1 {server_ip}%eth1 >&2")

    with subtest("Global addresses can be obtained, pinged, and reached via http"):
        for client in clients:
            client_ip = wait_for_address(client, "eth1", "global")
            server_ip = wait_for_address(server, "eth1", "global")
            client.succeed(f"ping -c 1 {client_ip} >&2")
            client.succeed(f"ping -c 1 {server_ip} >&2")
            client.succeed(f"curl --fail -g http://[{server_ip}]")
            client.fail(f"curl --fail -g http://[{client_ip}]")

    with subtest(
        "Privacy extensions: Global temporary address is used as default source address"
    ):
        ip = wait_for_address(client_defaults, "eth1", "global", temporary=True)
        # Default route should have "src <temporary address>" in it
        client_defaults.succeed(f"ip route get 2001:db8:: | grep 'src {ip}'")

    for client, setting_desc in (
        (client_global_setting, "global"),
        (client_interface_setting, "interface"),
    ):
        with subtest(f'Privacy extensions: "enabled" through {setting_desc} setting)'):
            # We should be obtaining both a temporary address and an EUI-64 address...
            ip = wait_for_address(client, "eth1", "global")
            assert "ff:fe" in ip
            ip_temp = wait_for_address(client, "eth1", "global", temporary=True)
            # But using the EUI-64 one.
            client.succeed(f"ip route get 2001:db8:: | grep 'src {ip}'")
  '';
}
