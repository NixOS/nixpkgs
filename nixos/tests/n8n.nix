import ./make-test-python.nix ({ lib, ... }:

with lib;

let
  port = 5678;
in
{
  name = "n8n";
  meta.maintainers = with maintainers; [ freezeboy k900 ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.n8n = {
        enable = true;
      };
    };

  testScript = ''
    machine.wait_for_unit("n8n.service")
    machine.wait_for_open_port(${toString port})
    machine.succeed("curl --fail http://localhost:${toString port}/")
  '';
})
