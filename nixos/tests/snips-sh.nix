import ./make-test-python.nix (
  {lib, ...}: {
    name = "ships-sh";

    nodes.machine = {
      services.snips-sh = {
        enable = true;
        settings = {
          SNIPS_HTTP_INTERNAL = "http://0.0.0.0:8080";
          SNIPS_SSH_INTERNAL = "ssh://0.0.0.0:2222";
        };
      };
    };

    # Check if the web interface is reachable. Worth considering more comprehensive
    # tests should the need ever arise.
    testScript = ''
      machine.start()
      machine.wait_for_unit("ships-sh.service")
      machine.wait_for_open_port(8080)
      machine.succeed("curl --fail http://localhost:8080")
    '';

    meta.maintainers = [lib.maintainers.NotAShelf];
  }
)
