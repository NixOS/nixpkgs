import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "nodered";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ matthewcroughan ];
    };

    nodes = {
      client =
        { config, pkgs, ... }:
        {
          environment.systemPackages = [ pkgs.curl ];
        };
      nodered =
        { config, pkgs, ... }:
        {
          services.node-red = {
            enable = true;
            openFirewall = true;
          };
        };
    };

    testScript = ''
      start_all()
      nodered.wait_for_unit("node-red.service")
      nodered.wait_for_open_port(1880)

      client.wait_for_unit("multi-user.target")

      with subtest("Check that the Node-RED webserver can be reached."):
          assert "<title>Node-RED</title>" in client.succeed(
              "curl -sSf http:/nodered:1880/ | grep title"
          )
    '';
  }
)
