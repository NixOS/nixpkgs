{ pkgs, ... }:

let
  client =
    { pkgs, ... }:
    {
      imports = [ ./common/x11.nix ];
      environment.systemPackages = [ pkgs.mumble ];
    };
  port = 56457;
in
{
  name = "mumble";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ _3JlOy-PYCCKUi ];
  };

  nodes = {
    server =
      { ... }:
      {
        services.umurmur = {
          enable = true;
          openFirewall = true;
          settings = {
            password = "testpassword";
            channels = [
              {
                name = "root";
                parent = "";
                description = "Root channel. No entry.";
                noenter = true;
              }
              {
                name = "lobby";
                parent = "root";
                description = "Lobby channel";
              }
            ];
            default_channel = "lobby";
            bindport = port;
          };
        };
      };

    client1 = client;
    client2 = client;
  };

  testScript = ''
    start_all()

    server.wait_for_unit("umurmur.service")
    client1.wait_for_x()
    client2.wait_for_x()

    client1.execute("mumble mumble://client1:testpassword\@server:${toString port}/lobby >&2 &")
    client2.execute("mumble mumble://client2:testpassword\@server:${toString port}/lobby >&2 &")

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
        "journalctl -eu umurmur -o cat | grep -q 'User client1 authenticated'"
    )
    server.wait_until_succeeds(
        "journalctl -eu umurmur -o cat | grep -q 'User client2 authenticated'"
    )
  '';
}
