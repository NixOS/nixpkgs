import ./make-test-python.nix ({pkgs, lib, ... }: {
  name = "mympd";

  nodes.mympd = {
    services.mympd = {
      enable = true;
      settings = {
        http_port = 8081;
      };
    };

    services.mpd.enable = true;
  };

  testScript = ''
    start_all();
    machine.wait_for_unit("mympd.service");

    # Ensure that mympd can connect to mpd
    machine.wait_until_succeeds(
      "journalctl -eu mympd -o cat | grep 'Connected to MPD'"
    )

    # Ensure that the web server is working
    machine.succeed("curl http://localhost:8081 --compressed | grep -o myMPD")
  '';
})
