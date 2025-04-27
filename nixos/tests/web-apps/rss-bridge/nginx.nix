import ../../make-test-python.nix (
  { lib, pkgs, ... }:
  {
    name = "rss-bridge-nginx";
    meta.maintainers = with lib.maintainers; [ mynacol ];

    nodes.machine =
      { ... }:
      {
        services.rss-bridge = {
          enable = true;
          webserver = "nginx";
          config.system.enabled_bridges = [ "DemoBridge" ];
        };
      };

    testScript = ''
      machine.wait_for_unit("nginx.service")
      machine.wait_for_unit("phpfpm-rss-bridge.service")
      machine.wait_for_open_port(80)

      # check for successful feed download
      response = machine.succeed("curl -f 'http://localhost:80/?action=display&bridge=DemoBridge&context=testCheckbox&format=Atom'")
      assert '<title type="html">Test</title>' in response, "Feed didn't load successfully"
    '';
  }
)
