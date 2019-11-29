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

  testScript = let
    getaddrinfo_py = pkgs.writeScript "getaddrinfo.py" ''
      import socket
      import sys

      result = set()
      for gai in socket.getaddrinfo(sys.argv[1], 0):
          result.add(gai[4][0])

      print(' '.join(sorted(list(result))))
    '';

    getaddrinfo = "${pkgs.python3.interpreter} ${getaddrinfo_py}";

  in
  ''
    def compare(test, should, is_):
        should = should.strip()
        is_ = is_.strip()
        resolv.log("{}: expected '{}', actual '{}'".format(test, should, is_))
        if should == is_:
            resolv.log("* OK")
            return True
        else:
            resolv.log("* FAILED")
            return False


    start_all()
    resolv.wait_for_unit("nscd")
    res = []

    out = resolv.succeed(
        "${getaddrinfo} host-ipv4.example.net"
    )
    res.append(compare("resolve IPv4", "192.0.2.1 192.0.2.2", out))

    out = resolv.succeed(
        "${getaddrinfo} host-ipv6.example.net"
    )
    res.append(compare("resolve IPv6", "2001:db8::2:1 2001:db8::2:2", out))

    out = resolv.succeed(
        "${getaddrinfo} host-dual.example.net"
    )
    res.append(
        compare(
            "resolve dual stack", "192.0.2.1 192.0.2.2 2001:db8::2:1 2001:db8::2:2", out
        )
    )

    assert all(res) is True
  '';
})
