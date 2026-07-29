{
  ip4,
  ip6,
  extraConfig,
}:
{
  imports = [
    {
      boot.kernel.sysctl = {
        "net.ipv6.conf.all.forwarding" = "1";
        "net.ipv6.conf.default.forwarding" = "1";
        "net.ipv4.ip_forward" = "1";
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
  ];
}
