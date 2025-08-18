{ lib, ... }:

{
  name = "pyroscope";
  meta.maintainers = with lib.maintainers; [ kashw2 ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.pyroscope.enable = true;
    };

  testScript = ''
    machine.wait_for_unit("pyroscope.service")
    machine.wait_for_open_port(4040)
    machine.succeed("curl --fail http://localhost:4040/")
  '';
}
