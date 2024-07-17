import ./make-test-python.nix (
  { pkgs, ... }:
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

    nodes.machine =
      { pkgs, ... }:
      {
        imports = [ common/user-account.nix ];
        networking.extraHosts = ''
          2001:db8::1 somehost.test
          192.0.2.1 somehost.test
        '';

        systemd.services.sockdump = {
          wantedBy = [ "multi-user.target" ];
          path = [
            # necessary for bcc to unpack kernel headers and invoke modprobe
            pkgs.gnutar
            pkgs.xz.bin
            pkgs.kmod
          ];
          environment.PYTHONUNBUFFERED = "1";

          serviceConfig = {
            ExecStart = "${pkgs.sockdump}/bin/sockdump /var/run/nscd/socket";
            Restart = "on-failure";
            RestartSec = "1";
            Type = "simple";
          };
        };

        specialisation = {
          withGlibcNscd.configuration =
            { ... }:
            {
              services.nscd.enableNsncd = false;
            };
          withUnscd.configuration =
            { ... }:
            {
              services.nscd.enableNsncd = false;
              services.nscd.package = pkgs.unscd;
            };
        };
      };

    testScript =
      { nodes, ... }:
      let
        specialisations = "${nodes.machine.system.build.toplevel}/specialisation";
      in
      ''
        # Regression test for https://github.com/NixOS/nixpkgs/issues/50273
        def test_dynamic_user():
            with subtest("DynamicUser actually allocates a user"):
                assert "iamatest" in machine.succeed(
                    "systemd-run --pty --property=Type=oneshot --property=DynamicUser=yes --property=User=iamatest whoami"
                )

        # Test resolution of somehost.test with getent', to make sure we go via
        # nscd protocol
        def test_host_lookups():
            with subtest("host lookups via nscd protocol"):
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
        def test_nss_myhostname():
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

        start_all()
        machine.wait_for_unit("default.target")

        # give sockdump some time to finish attaching.
        machine.sleep(5)

        # Test all tests with glibc-nscd.
        test_dynamic_user()
        test_host_lookups()
        test_nss_myhostname()

        with subtest("glibc-nscd"):
            machine.succeed('${specialisations}/withGlibcNscd/bin/switch-to-configuration test')
            machine.wait_for_unit("default.target")

            test_dynamic_user()
            test_host_lookups()
            test_nss_myhostname()

        with subtest("unscd"):
            machine.succeed('${specialisations}/withUnscd/bin/switch-to-configuration test')
            machine.wait_for_unit("default.target")

            # known to fail, unscd doesn't load external NSS modules
            # test_dynamic_user()

            test_host_lookups()

            # known to fail, unscd doesn't load external NSS modules
            # test_nss_myhostname()
      '';
  }
)
