{ pkgs, ... }:
{
  name = "navidrome";

  nodes.machine =
    { ... }:
    {
      services.navidrome = {
        enable = true;
        plugins = with pkgs.navidromePlugins; [
          listenbrainz-daily-playlist
        ];
      };
    };

  testScript = ''
    machine.wait_for_unit("navidrome")
    machine.wait_for_console_text("Starting plugin manager")
    # Make sure we saw at least one plugin load
    machine.wait_for_console_text("plugin=listenbrainz-daily-playlist")
    machine.wait_for_open_port(4533)
  '';
}
