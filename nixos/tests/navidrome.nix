{ ... }:
{
  name = "navidrome";

  nodes.machine =
    { pkgs, ... }:
    {
      services.navidrome = {
        enable = true;
        plugins = with pkgs.pkgsCross.wasi32.navidromePlugins; [
          # basic go plugin
          listenbrainz-daily-playlist
          # uses bundleName instead of pname
          apple-music
          # rust plugin
          lyrics-plugin
        ];
        settings = {
          # Disables all external network connections
          EnableExternalServices = "false";
        };
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
