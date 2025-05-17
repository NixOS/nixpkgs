{ lib, ... }:

{
  name = "chasemapper";
  meta.maintainers = with lib.maintainers; [ scd31 ];

  nodes.machine =
    { ... }:
    {
      services.chasemapper.enable = true;
    };

  testScript = ''
    machine.wait_for_unit("chasemapper.service")
    machine.wait_for_open_port(5001)
    machine.succeed("curl --fail http://localhost:5001")
  '';

}
