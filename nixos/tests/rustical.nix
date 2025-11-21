{ ... }:
{
  name = "rustical";

  nodes.machine =
    { ... }:
    {
      services.rustical = {
        enable = true;
      };
    };

  testScript = ''
    start_all()

    machine.wait_for_unit("rustical.service")
    machine.wait_for_open_port(4000)
    machine.succeed("curl --fail http://localhost:4000")
  '';
}
