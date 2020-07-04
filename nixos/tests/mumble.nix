import ./make-test-python.nix ({ pkgs, ...} :

let
  client = { pkgs, ... }: {
    imports = [ ./common/x11.nix ];
    environment.systemPackages = [ pkgs.mumble ];
  };
in
{
  name = "mumble";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ thoughtpolice eelco ];
  };

  nodes = {
    server = { config, ... }: {
      services.murmur.enable       = true;
      services.murmur.registerName = "NixOS tests";
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

    client1.execute("mumble mumble://client1\@server/test &")
    client2.execute("mumble mumble://client2\@server/test &")

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
    server.wait_until_succeeds("journalctl -eu murmur -o cat | grep -q client1")
    server.wait_until_succeeds("journalctl -eu murmur -o cat | grep -q client2")

    server.sleep(5)  # wait to get screenshot
    client1.screenshot("screen1")
    client2.screenshot("screen2")
  '';
})
