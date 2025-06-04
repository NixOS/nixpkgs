{ lib, ... }:

{
  name = "komga";
  meta.maintainers = with lib.maintainers; [ govanify ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.komga = {
        enable = true;
        settings.server.port = 1234;
      };
    };

  testScript = ''
    machine.wait_for_unit("komga.service")
    machine.wait_for_open_port(1234)
    machine.succeed("curl --fail http://localhost:1234/")
  '';
}
