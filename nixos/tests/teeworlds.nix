{ pkgs, ... }:

let
  client =
    { pkgs, ... }:

    {
      imports = [ ./common/x11.nix ];
      environment.systemPackages = [ pkgs.teeworlds ];
    };

in
{
  name = "teeworlds";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ hax404 ];
  };

  nodes = {
    server = {
      services.teeworlds = {
        enable = true;
        openPorts = true;
      };
    };

    client1 = client;
    client2 = client;
  };

  testScript = ''
    start_all()

    server.wait_for_unit("teeworlds.service")
    server.wait_until_succeeds("ss --numeric --udp --listening | grep -q 8303")

    client1.wait_for_x()
    client2.wait_for_x()

    client1.execute("teeworlds 'player_name Alice;connect server' >&2 &")
    server.wait_until_succeeds(
        'journalctl -u teeworlds -e | grep --extended-regexp -q "team_join player=\'[0-9]:Alice"'
    )

    client2.execute("teeworlds 'player_name Bob;connect server' >&2 &")
    server.wait_until_succeeds(
        'journalctl -u teeworlds -e | grep --extended-regexp -q "team_join player=\'[0-9]:Bob"'
    )

    server.sleep(10)  # wait for a while to get a nice screenshot

    client1.screenshot("screen_client1")
    client2.screenshot("screen_client2")
  '';

}
