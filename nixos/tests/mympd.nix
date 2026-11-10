{ pkgs, lib, ... }:
{
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
    mympd.wait_for_unit("mympd.service");

    # Ensure that mympd can connect to mpd
    mympd.wait_until_succeeds(
      "journalctl -eu mympd -o cat | grep 'Connected to MPD'"
    )

    # Ensure that the web server is working
    mympd.succeed("curl http://localhost:8081 --compressed | grep -o myMPD")
  '';
}
