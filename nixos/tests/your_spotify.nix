import ./make-test-python.nix ({pkgs, ...}: {
  name = "your_spotify";
  meta = with pkgs.lib.maintainers; {
    maintainers = [patrickdag];
  };

  nodes.machine = {
    services.your_spotify = {
      enable = true;
      spotifySecretFile = pkgs.writeText "spotifySecretFile" "deadbeef";
      settings = {
        CLIENT_ENDPOINT = "http://localhost";
        API_ENDPOINT = "http://localhost:3000";
        SPOTIFY_PUBLIC = "beefdead";
      };
      enableLocalDB = true;
      nginxVirtualHost = "localhost";
    };
  };

  testScript = ''
    machine.wait_for_unit("your_spotify.service")

    machine.wait_for_open_port(3000)
    machine.wait_for_open_port(80)

    out = machine.succeed("curl --fail -X GET 'http://localhost:3000/'")
    assert "Hello !" in out

    out = machine.succeed("curl --fail -X GET 'http://localhost:80/'")
    assert "<title>Your Spotify</title>" in out
  '';
})
