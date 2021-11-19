let
  hostIp = "192.168.0.1";
  containerIp = "192.168.0.100/24";
  hostIp6 = "fc00::1";
  containerIp6 = "fc00::2/7";
in

import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "containers-bridge";
  meta = {
    maintainers = with lib.maintainers; [ aristid aszlig eelco kampfschlaefer ];
  };

  machine =
    { pkgs, ... }:
    { imports = [ ../modules/installer/cd-dvd/channel.nix ];
      virtualisation.writableStore = true;
      virtualisation.memorySize = 768;

      networking.bridges = {
        br0 = {
          interfaces = [];
        };
      };
      networking.interfaces = {
        br0 = {
          ipv4.addresses = [{ address = hostIp; prefixLength = 24; }];
          ipv6.addresses = [{ address = hostIp6; prefixLength = 7; }];
        };
      };

      containers.webserver =
        {
          autoStart = true;
          privateNetwork = true;
          hostBridge = "br0";
          localAddress = containerIp;
          localAddress6 = containerIp6;
          config =
            { services.httpd.enable = true;
              services.httpd.adminAddr = "foo@example.org";
              networking.firewall.allowedTCPPorts = [ 80 ];
            };
        };

      containers.web-noip =
        {
          autoStart = true;
          privateNetwork = true;
          hostBridge = "br0";
          config =
            { services.httpd.enable = true;
              services.httpd.adminAddr = "foo@example.org";
              networking.firewall.allowedTCPPorts = [ 80 ];
            };
        };


      virtualisation.additionalPaths = [ pkgs.stdenv ];
    };

  testScript = ''
    machine.wait_for_unit("default.target")
    assert "webserver" in machine.succeed("nixos-container list")

    with subtest("Start the webserver container"):
        assert "up" in machine.succeed("nixos-container status webserver")

    with subtest("Bridges exist inside containers"):
        machine.succeed(
            "nixos-container run webserver -- ip link show eth0",
            "nixos-container run web-noip -- ip link show eth0",
        )

    ip = "${containerIp}".split("/")[0]
    machine.succeed(f"ping -n -c 1 {ip}")
    machine.succeed(f"curl --fail http://{ip}/ > /dev/null")

    ip6 = "${containerIp6}".split("/")[0]
    machine.succeed(f"ping -n -c 1 {ip6}")
    machine.succeed(f"curl --fail http://[{ip6}]/ > /dev/null")

    with subtest(
        "nixos-container show-ip works in case of an ipv4 address "
        + "with subnetmask in CIDR notation."
    ):
        result = machine.succeed("nixos-container show-ip webserver").rstrip()
        assert result == ip

    with subtest("Stop the container"):
        machine.succeed("nixos-container stop webserver")
        machine.fail(
            f"curl --fail --connect-timeout 2 http://{ip}/ > /dev/null",
            f"curl --fail --connect-timeout 2 http://[{ip6}]/ > /dev/null",
        )

    # Destroying a declarative container should fail.
    machine.fail("nixos-container destroy webserver")
  '';
})
