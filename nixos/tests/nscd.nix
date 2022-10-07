import ./make-test-python.nix ({ pkgs, ... }:
let
  # build a getent that itself doesn't see anything in /etc/hosts and
  # /etc/nsswitch.conf, by using libredirect to steer its own requests to
  # /dev/null.
  # This means is /has/ to go via nscd to actuallly resolve any of the
  # additionally configured hosts.
  getent' = pkgs.writeScript "getent-without-etc-hosts" ''
    export NIX_REDIRECTS=/etc/hosts=/dev/null:/etc/nsswitch.conf=/dev/null
    export LD_PRELOAD=${pkgs.libredirect}/lib/libredirect.so
    exec getent $@
  '';
in
{
  name = "nscd";

  nodes.machine = { lib, ... }: {
    imports = [ common/user-account.nix ];
    networking.extraHosts = ''
      2001:db8::1 somehost.test
      192.0.2.1 somehost.test
    '';
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("default.target")

    # Regression test for https://github.com/NixOS/nixpkgs/issues/50273
    with subtest("DynamicUser actually allocates a user"):
        assert "iamatest" in machine.succeed(
            "systemd-run --pty --property=Type=oneshot --property=DynamicUser=yes --property=User=iamatest whoami"
        )

    # Test resolution of somehost.test with getent', to make sure we go via nscd
    with subtest("host lookups via nscd"):
        # ahosts
        output = machine.succeed("${getent'} ahosts somehost.test")
        assert "192.0.2.1" in output
        assert "2001:db8::1" in output

        # ahostsv4
        output = machine.succeed("${getent'} ahostsv4 somehost.test")
        assert "192.0.2.1" in output
        assert "2001:db8::1" not in output

        # ahostsv6
        output = machine.succeed("${getent'} ahostsv6 somehost.test")
        assert "192.0.2.1" not in output
        assert "2001:db8::1" in output

        # reverse lookups (hosts)
        assert "somehost.test" in machine.succeed("${getent'} hosts 2001:db8::1")
        assert "somehost.test" in machine.succeed("${getent'} hosts 192.0.2.1")


    # Test host resolution via nss modules works
    # We rely on nss-myhostname in this case, which resolves *.localhost and
    # _gateway.
    # We don't need to use getent' here, as non-glibc nss modules can only be
    # discovered via nscd.
    with subtest("nss-myhostname provides hostnames (ahosts)"):
        # ahosts
        output = machine.succeed("getent ahosts foobar.localhost")
        assert "::1" in output
        assert "127.0.0.1" in output

        # ahostsv4
        output = machine.succeed("getent ahostsv4 foobar.localhost")
        assert "::1" not in output
        assert "127.0.0.1" in output

        # ahostsv6
        output = machine.succeed("getent ahostsv6 foobar.localhost")
        assert "::1" in output
        assert "127.0.0.1" not in output

        # ahosts
        output = machine.succeed("getent ahosts _gateway")

        # returns something like the following:
        # 10.0.2.2        STREAM _gateway
        # 10.0.2.2        DGRAM
        # 10.0.2.2        RAW
        # fe80::2         STREAM
        # fe80::2         DGRAM
        # fe80::2         RAW

        # Verify we see both ip addresses
        assert "10.0.2.2" in output
        assert "fe80::2" in output
  '';
})
