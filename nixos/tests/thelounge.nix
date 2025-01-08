import ./make-test-python.nix {
  name = "thelounge";

  nodes = {
    private =
      { config, pkgs, ... }:
      {
        services.thelounge = {
          enable = true;
          plugins = [ pkgs.theLoungePlugins.themes.solarized ];
        };
      };

    public =
      { config, pkgs, ... }:
      {
        services.thelounge = {
          enable = true;
          public = true;
        };
      };
  };

  testScript = ''
    start_all()

    for machine in machines:
      machine.wait_for_unit("thelounge.service")
      machine.wait_for_open_port(9000)

    private.wait_until_succeeds("journalctl -u thelounge.service | grep thelounge-theme-solarized")
    private.wait_until_succeeds("journalctl -u thelounge.service | grep 'in private mode'")
    public.wait_until_succeeds("journalctl -u thelounge.service | grep 'in public mode'")
  '';
}
