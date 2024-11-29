{ pkgs, ... }:
{
  name = "rss-bridge";
  meta.maintainers = with pkgs.lib.maintainers; [ mynacol ];

  nodes.machine =
    { ... }:
    {
      services.rss-bridge = {
        enable = true;
      };
    };

  testScript = ''
    start_all()
    machine.wait_for_unit("nginx.service")
    machine.wait_for_unit("phpfpm-rss-bridge.service")

    # check for successful feed download
    machine.succeed("curl -sS -f 'http://localhost/?action=display&bridge=DemoBridge&context=testCheckbox&format=Atom'")
  '';
}
