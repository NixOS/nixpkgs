{ pkgs, ... }:
{
  name = "navidrome";

  nodes.machine =
    { ... }:
    {
      services.navidrome = {
        enable = true;
        package = pkgs.navidrome.override {
          plugins = with pkgs.navidromePlugins; [
            wikimedia
            coverartarchive
          ];
        };
        settings.Plugins = {
          Enabled = true;
        };
      };
    };

  testScript = ''
    machine.wait_for_unit("navidrome")
    machine.wait_for_console_text("Starting plugin manager")
    machine.wait_for_console_text("Discovered plugin")
    machine.wait_for_open_port(4533)
  '';
}
