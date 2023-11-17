import ./make-test-python.nix ({ pkgs, ... }:
{

  name = "opensearch-dashboards";

  nodes = {
    dashboards = {
      # Enough memory For JVM.
      virtualisation.memorySize = 2048;
      services.opensearch.enable = true;
      services.opensearch-dashboards.enable = true;
      services.opensearch-dashboards.settings = {
        opensearch = {
          username = "admin";
          password = "admin";
        };
      };
    };
  };

  testScript = ''
    machine.start()
    machine.wait_for_unit("opensearch-dashboards.service")
    machine.wait_for_open_port(9200)
    machine.succeed("curl -f http://admin:admin@localhost:9200")
  '';
})

