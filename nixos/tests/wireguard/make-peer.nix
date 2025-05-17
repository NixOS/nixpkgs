{ lib, ... }:
{
  ip4,
  ip6,
  extraConfig,
}:
lib.mkMerge [
  {
    boot.kernel.sysctl = {
      net.ipv6.conf.all.forwarding = true;
      net.ipv6.conf.default.forwarding = true;
      net.ipv4.ip_forward = true;
    };

    networking.useDHCP = false;
    networking.interfaces.eth1 = {
      ipv4.addresses = [
        {
          address = ip4;
          prefixLength = 24;
        }
      ];
      ipv6.addresses = [
        {
          address = ip6;
          prefixLength = 64;
        }
      ];
    };
  }
  extraConfig
]
