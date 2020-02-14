# Test whether DNS resolving returns multiple records and all address families.
import ./make-test-python.nix ({ pkgs, ... } : {
  name = "resolv";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ ckauhaus ];
  };

  nodes.resolv = { ... }: {
    networking.extraHosts = ''
      # IPv4 only
      192.0.2.1 host-ipv4.example.net
      192.0.2.2 host-ipv4.example.net
      # IP6 only
      2001:db8::2:1 host-ipv6.example.net
      2001:db8::2:2 host-ipv6.example.net
      # dual stack
      192.0.2.1 host-dual.example.net
      192.0.2.2 host-dual.example.net
      2001:db8::2:1 host-dual.example.net
      2001:db8::2:2 host-dual.example.net
    '';
  };

  testScript = ''
    def addrs_in(hostname, addrs):
        res = resolv.succeed("getent ahosts {}".format(hostname))
        for addr in addrs:
            assert addr in res, "Expected output '{}' not found in\n{}".format(addr, res)


    start_all()
    resolv.wait_for_unit("nscd")

    ipv4 = ["192.0.2.1", "192.0.2.2"]
    ipv6 = ["2001:db8::2:1", "2001:db8::2:2"]

    with subtest("IPv4 resolves"):
        addrs_in("host-ipv4.example.net", ipv4)

    with subtest("IPv6 resolves"):
        addrs_in("host-ipv6.example.net", ipv6)

    with subtest("Dual stack resolves"):
        addrs_in("host-dual.example.net", ipv4 + ipv6)
  '';
})
