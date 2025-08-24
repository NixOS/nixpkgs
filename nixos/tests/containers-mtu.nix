let
  nullOr = value: default: if value != null then value else default;
  defaultContainer =
    args:
    {
      # save some time compared to sequential starting
      # these containers eat basically zero resources anyway
      autoStart = true;
      privateNetwork = true;
      config = {
        networking.firewall.enable = false;
      };
    }
    // args;

in
{ lib, ... }:
{
  name = "containers-mtu";
  meta = {
    maintainers = with lib.maintainers; [
      benaryorg
    ];
  };

  nodes.machine.containers = {
    # minimum MTU sizes for IPv6 and IPv4 are 1280 and 68 respectively
    # maximum are quite a bit higher but testing for the usual 9000 suffices to confirm that the MTU is in fact set
    # default should use the ubiquitious 1500 since it being absent will default to whatever Linux decides to use
    small6 = defaultContainer {
      mtu = 1280;
      hostAddress6 = "fc00::1";
      localAddress6 = "fd17:4ab0:cdf3::1";
    };
    small4 = defaultContainer {
      mtu = 68;
      hostAddress = "169.254.0.1";
      localAddress = "10.0.0.1";
    };
    regular6 = defaultContainer {
      mtu = 1500;
      hostAddress6 = "fc00::1";
      localAddress6 = "fd17:4ab0:cdf3::2";
    };
    regular4 = defaultContainer {
      mtu = 1500;
      hostAddress = "169.254.0.1";
      localAddress = "10.0.0.2";
    };
    default6 = defaultContainer {
      hostAddress6 = "fc00::1";
      localAddress6 = "fd17:4ab0:cdf3::3";
    };
    default4 = defaultContainer {
      hostAddress = "169.254.0.1";
      localAddress = "10.0.0.3";
    };
    large6 = defaultContainer {
      mtu = 9000;
      hostAddress6 = "fc00::1";
      localAddress6 = "fd17:4ab0:cdf3::4";
    };
    large4 = defaultContainer {
      mtu = 9000;
      hostAddress = "169.254.0.1";
      localAddress = "10.0.0.4";
    };
  };

  testScript =
    { nodes, ... }:
    ''
      def ping_host(ip, size=0):
          # 4 pings to avoid a single random packet being lost from failing the entire test suite
          # default of size 0 to ensure that reachability pings always work
          return f"ping -i 0.2 -c 4 -s {size} -M probe {ip}"

      machine.start()
      machine.wait_for_unit("default.target")

      containers: list[tuple[str, str, int]] = ${
        lib.pipe nodes.machine.config.containers [
          # just using builtins.toJSON all the way would've been easier but make the Python type checker angy
          (lib.mapAttrsToList (
            name: config: [
              name
              (nullOr config.localAddress6 config.localAddress)
              (nullOr config.mtu 1500)
            ]
          ))
          (builtins.map (builtins.map builtins.toJSON))
          (builtins.map (builtins.concatStringsSep ", "))
          (builtins.map (tuple: "    (${tuple})"))
          (builtins.concatStringsSep ",\n")
          (list: "[\n${list}\n]")
        ]
      }
      for container, ip, mtu in containers:
          print(f"{container}: {ip} ({mtu})")
          assert container in machine.succeed("nixos-container list")

          with subtest(f"{container} is reachable"):
              machine.wait_until_succeeds(ping_host(ip), timeout=16)

          # IPv6: 40 bytes IPv6 header, 4 byte ICMPv6 header, 4 byte Echo Request header
          # IPv4: 20 bytes IPv4 header, 4 byte ICMP header, 4 byte Echo Request header
          header_size: int = 48 if ":" in ip else 28
          with subtest(f"{container} MTU bounds check"):
              # 1 below MTU
              machine.succeed(ping_host(ip, mtu - header_size - 1))
              # exact MTU
              machine.succeed(ping_host(ip, mtu - header_size))
              # 1 above MTU
              machine.fail(ping_host(ip, mtu - header_size + 1))

          with subtest(f"Stop container {container}"):
              machine.succeed(f"nixos-container stop {container}")
              machine.fail(ping_host(ip) + "-W 1")
    '';
}
