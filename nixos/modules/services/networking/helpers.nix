{ config, lib, ... }: ''
  # Helper command to manipulate both the IPv4 and IPv6 tables.
  ip46tables() {
    iptables -w "$@"
    ${
      lib.optionalString config.networking.enableIPv6 ''
        ip6tables -w "$@"
      ''
    }
  }
''
