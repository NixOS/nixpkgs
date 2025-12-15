{ lib, ... }:
let
  mainPort = "5001";
in
{
  name = "docling-serve";
  meta = {
    maintainers = [ ];
  };

  nodes = {
    machine =
      { ... }:
      {
        services.docling-serve = {
          enable = true;
        };
      };
  };

  testScript = ''
    machine.start()

    machine.wait_for_unit("docling-serve.service")
    machine.wait_for_open_port(${mainPort})
    machine.succeed("curl http://127.0.0.1:${mainPort}")
  '';
}
