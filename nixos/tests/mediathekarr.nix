{ lib, ... }:

{
  name = "mediathekarr";
  meta.maintainers = with lib.maintainers; [ tmarkus ];

  nodes.machine =
    { ... }:
    {
      services.mediathekarr.enable = true;
    };

  testScript = ''
    machine.wait_for_unit("mediathekarr.target")
    machine.wait_for_unit("mediathekarr.service")

    machine.wait_for_open_port(5007)
    machine.wait_for_open_port(5008)

    machine.succeed("curl --fail http://localhost:5007/")
  '';
}
