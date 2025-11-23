{ lib, pkgs, ... }:
{
  name = "gonic";

  nodes.machine =
    { config, ... }:
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
        # Wrap gonic to check that the required paths are writable.
        # This isn't necessarily checked by successful service startup.
        package = pkgs.writeShellApplication {
          name = "gonic-test-wrapper";
          runtimeInputs = [ pkgs.gonic ];
          text = ''
            touch ${config.services.gonic.settings.cache-path}/foo
            touch /tmp/podcast/foo
            touch /tmp/playlists/foo
            exec ${lib.getExe pkgs.gonic} "$@"
          '';
        };
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
