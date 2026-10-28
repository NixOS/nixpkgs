{ lib, ... }:
{
  name = "porxie";

  nodes.machine =
    { pkgs, ... }:
    {
      services.porxie = {
        enable = true;
        settings = {
          PORXIE_SERVER_ADDRESS = "ip:127.0.0.1:6453";
        };
      };
    };

  testScript = ''
    machine.wait_for_unit("porxie.service")
    machine.wait_for_open_port(6453)
    machine.succeed("curl --fail http://localhost:6453")
  '';

  meta.maintainers = [ lib.maintainers.blooym ];
}
