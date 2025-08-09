{ lib, ... }:
{
  name = "actual";
  meta.maintainers = [ lib.maintainers.oddlama ];

  nodes.machine =
    { ... }:
    {
      services.actual.enable = true;
    };

  testScript = ''
    machine.wait_for_open_port(3000)
    machine.succeed("curl -fvvv -Ls http://localhost:3000/ | grep 'Actual'")
  '';
}
