{ lib, ... }:

{
  name = "tdarr";
  meta = with lib.maintainers; {
    maintainers = [ mistyttm ];
  };

  nodes.machine =
    { pkgs, ... }:
    {
      services.tdarr = {
        enable = true;
        nodes.main = {
          enable = true;
          workers = {
            transcodeCPU = 1;
            healthcheckCPU = 1;
          };
        };
      };
    };

  testScript = ''
    machine.wait_for_unit("tdarr-server.service")
    machine.wait_for_unit("tdarr-node-main.service")

    # Check Web UI (8265) and API (8266)
    machine.wait_for_open_port(8265)
    machine.wait_for_open_port(8266)

    machine.succeed("curl --fail http://localhost:8265/")

    # Verify the node registered with the server
    machine.wait_until_succeeds(
        "curl -s http://localhost:8266/api/v2/get-nodes | grep -q 'main'"
    )
  '';
}
