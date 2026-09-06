{ lib, ... }:
{
  name = "vanguards";
  meta.maintainers = [ ]; # TODO: add nixpkgs handle before submitting

  nodes.machine =
    { pkgs, ... }:
    {
      services.tor = {
        enable = true;
        controlSocket.enable = true;
        relay.onionServices.web = {
          map = [
            {
              port = 80;
              target = {
                addr = "127.0.0.1";
                port = 8080;
              };
            }
          ];
        };
      };

      services.vanguards.enable = true;

      # Minimal HTTP server so the onion service has something to publish -
      # the test only exercises vanguards attaching to the control port, it
      # does not fetch the page.
      services.static-web-server = {
        enable = true;
        listen = "127.0.0.1:8080";
        root = pkgs.writeTextDir "index.html" "vanguards test";
      };
    };

  testScript = ''
    machine.start()
    machine.wait_for_unit("tor.service")

    # The control socket has to exist before vanguards can attach to it.
    machine.wait_for_file("/run/tor/control")

    machine.wait_for_unit("vanguards.service")

    # Exact string from mikeperry-tor/vanguards, src/vanguards/control.py:
    # plog("NOTICE", "Vanguards %s connected to Tor %s using stem %s", ...)
    # Verified against the upstream source on 2026-09-06, not assumed.
    machine.wait_until_succeeds(
        "journalctl -o cat -u vanguards.service | grep -q 'connected to Tor'"
    )

    # The unit should still be active once it has connected, not
    # crash-looping (bindsTo=tor.service would otherwise mask a real crash
    # as "tor.service also died", so check this independently).
    machine.succeed("systemctl is-active vanguards.service")

    # A cookie-auth failure would show up as a stem AuthenticationFailure
    # rather than the success line above, but check explicitly: this is
    # the failure mode the CookieAuthFile relocation in the module exists
    # to prevent, so a regression there should fail this test, not just
    # fail to match the success grep above.
    machine.fail(
        "journalctl -o cat -u vanguards.service | grep -q 'Unable to authenticate'"
    )

    machine.log(
        machine.succeed("systemd-analyze security vanguards.service | grep -v '✓'")
    )
  '';

  # What this test does NOT prove, stated so nobody downstream claims more
  # than was checked: this network never runs a directory authority, so
  # Tor never has a real consensus to give vanguards, and the journal keeps
  # showing "Tor needs descriptors: Cannot read
  # /var/lib/tor/cached-microdesc-consensus: [Errno 2] No such file or
  # directory" in a retry loop even on a fully working setup (confirmed
  # 2026-09-06 - after fixing the module to run as the tor user instead of
  # DynamicUser, this is the only error left, and it is a missing file, not
  # a permission error). Guard selection itself - the actual point of
  # vanguards - is therefore unverified here. Proving that would mean
  # standing up a real test consensus, the way nixos/tests/tor.nix does
  # with three directory authorities; disproportionate for what this test
  # exists to check, which is that the module wires vanguards to a running
  # Tor's control port correctly.
}
