{ lib, ... }:
let
  mainPort = "8080";
in
{
  name = "open-webui";
  meta = with lib.maintainers; {
    maintainers = [ shivaraj-bh ];
  };

  nodes = {
    machine =
      { ... }:
      {
        services.open-webui = {
          enable = true;
          environment = {
            # Requires network connection
            RAG_EMBEDDING_MODEL = "";
          };
        };
      };
  };

  testScript = ''
    machine.start()

    machine.wait_for_unit("open-webui.service")
    machine.wait_for_open_port(${mainPort})

    machine.succeed("curl http://127.0.0.1:${mainPort}")
  '';
}
