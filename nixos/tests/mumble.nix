import ./make-test-python.nix ({ pkgs, ...} :

let
  client = { pkgs, ... }: {
    imports = [ ./common/x11.nix ];
    environment.systemPackages = [ pkgs.mumble ];
  };

  # outside of tests, this file should obviously not come from the nix store
  envFile = pkgs.writeText "nixos-test-mumble-murmurd.env" ''
    MURMURD_PASSWORD=testpassword
  '';

in
{
  name = "mumble";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ thoughtpolice ];
  };

  nodes = {
    server = { config, ... }: {
      security.apparmor.enable = true;
      services.murmur.enable = true;
      services.murmur.registerName = "NixOS tests";
      services.murmur.password = "$MURMURD_PASSWORD";
      services.murmur.environmentFile = envFile;
      networking.firewall.allowedTCPPorts = [ config.services.murmur.port ];
    };

    client1 = client;
    client2 = client;
  };

  testScript = ''
    start_all()

    server.wait_for_unit("murmur.service")
    client1.wait_for_x()
    client2.wait_for_x()

    client1.execute("mumble mumble://client1:testpassword\@server/test >&2 &")
    client2.execute("mumble mumble://client2:testpassword\@server/test >&2 &")

    # cancel client audio configuration
    client1.wait_for_window(r"Audio Tuning Wizard")
    client2.wait_for_window(r"Audio Tuning Wizard")
    server.sleep(5)  # wait because mumble is slow to register event handlers
    client1.send_key("esc")
    client2.send_key("esc")

    # cancel client cert configuration
    client1.wait_for_window(r"Certificate Management")
    client2.wait_for_window(r"Certificate Management")
    server.sleep(5)  # wait because mumble is slow to register event handlers
    client1.send_key("esc")
    client2.send_key("esc")

    # accept server certificate
    client1.wait_for_window(r"^Mumble$")
    client2.wait_for_window(r"^Mumble$")
    server.sleep(5)  # wait because mumble is slow to register event handlers
    client1.send_chars("y")
    client2.send_chars("y")
    server.sleep(5)  # wait because mumble is slow to register event handlers

    # sometimes the wrong of the 2 windows is focused, we switch focus and try pressing "y" again
    client1.send_key("alt-tab")
    client2.send_key("alt-tab")
    server.sleep(5)  # wait because mumble is slow to register event handlers
    client1.send_chars("y")
    client2.send_chars("y")

    # Find clients in logs
    server.wait_until_succeeds(
        "journalctl -eu murmur -o cat | grep -q 'client1.\+Authenticated'"
    )
    server.wait_until_succeeds(
        "journalctl -eu murmur -o cat | grep -q 'client2.\+Authenticated'"
    )

    server.sleep(5)  # wait to get screenshot
    client1.screenshot("screen1")
    client2.screenshot("screen2")

    # check if apparmor denied anything
    server.fail('journalctl -b --no-pager --grep "^audit: .*apparmor=\\"DENIED\\""')
  '';
})
