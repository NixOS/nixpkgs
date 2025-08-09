{ pkgs, ... }:
{
  name = "gonic";

  nodes.machine =
    { ... }:
    {
      systemd.tmpfiles.settings = {
        "10-gonic" = {
          "/tmp/music"."d" = { };
          "/tmp/podcast"."d" = { };
          "/tmp/playlists"."d" = { };
        };
      };
      services.gonic = {
        enable = true;
        settings = {
          music-path = [ "/tmp/music" ];
          podcast-path = "/tmp/podcast";
          playlists-path = "/tmp/playlists";
        };
      };
    };

  testScript = ''
    machine.wait_for_unit("gonic")
    machine.wait_for_open_port(4747)
  '';
}
