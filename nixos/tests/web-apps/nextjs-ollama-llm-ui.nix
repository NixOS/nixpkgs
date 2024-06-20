{ lib, ... }:

{
  name = "nextjs-ollama-llm-ui";
  meta.maintainers = with lib.maintainers; [ malteneuss ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.nextjs-ollama-llm-ui = {
        enable = true;
        port = 8080;
      };
    };

  testScript = ''
    # Ensure the service is started and reachable
    machine.wait_for_unit("nextjs-ollama-llm-ui.service")
    machine.wait_for_open_port(8080)
    machine.succeed("curl --fail http://127.0.0.1:8080")
  '';
}
