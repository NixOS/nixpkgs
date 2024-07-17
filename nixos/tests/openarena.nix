import ./make-test-python.nix (
  { pkgs, ... }:

  let
    client =
      { pkgs, ... }:

      {
        imports = [ ./common/x11.nix ];
        hardware.opengl.driSupport = true;
        environment.systemPackages = [ pkgs.openarena ];
      };

  in
  {
    name = "openarena";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ fpletz ];
    };

    nodes = {
      server = {
        services.openarena = {
          enable = true;
          extraFlags = [
            "+set g_gametype 0"
            "+map oa_dm7"
            "+addbot Angelyss"
            "+addbot Arachna"
          ];
          openPorts = true;
        };
      };

      client1 = client;
      client2 = client;
    };

    testScript = ''
      start_all()

      server.wait_for_unit("openarena")
      server.wait_until_succeeds("ss --numeric --udp --listening | grep -q 27960")

      client1.wait_for_x()
      client2.wait_for_x()

      client1.execute("openarena +set r_fullscreen 0 +set name Foo +connect server >&2 &")
      client2.execute("openarena +set r_fullscreen 0 +set name Bar +connect server >&2 &")

      server.wait_until_succeeds(
          "journalctl -u openarena -e | grep -q 'Foo.*entered the game'"
      )
      server.wait_until_succeeds(
          "journalctl -u openarena -e | grep -q 'Bar.*entered the game'"
      )

      server.sleep(10)  # wait for a while to get a nice screenshot

      client1.screenshot("screen_client1_1")
      client2.screenshot("screen_client2_1")

      client1.block()

      server.sleep(10)

      client1.screenshot("screen_client1_2")
      client2.screenshot("screen_client2_2")

      client1.unblock()

      server.sleep(10)

      client1.screenshot("screen_client1_3")
      client2.screenshot("screen_client2_3")
    '';

  }
)
