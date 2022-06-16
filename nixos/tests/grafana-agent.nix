import ./make-test-python.nix ({ lib, pkgs, ... }:

  let
    nodes = {
      machine = {
        services.grafana-agent = {
          enable = true;
        };
      };
    };
  in
  {
    name = "grafana-agent";

    meta = with lib.maintainers; {
      maintainers = [ zimbatm ];
    };

    inherit nodes;

    testScript = ''
      start_all()

      with subtest("Grafana-agent is running"):
          machine.wait_for_unit("grafana-agent.service")
          machine.wait_for_open_port(9090)
          machine.succeed(
              "curl -sSfN http://127.0.0.1:9090/-/healthy"
          )
          machine.shutdown()
    '';
  })
