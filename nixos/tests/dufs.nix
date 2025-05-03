{ lib, ... }:
{
  name = "dufs";
  meta.maintainers = with lib.maintainers; [ jackwilsdon ];

  nodes.machine =
    { ... }:
    {
      services.dufs = {
        enable = true;
        settings.serve-path = "/tmp";
      };
    };

  testScript = ''
    machine.wait_for_unit("dufs.service")
    machine.wait_for_open_port(5000)

    machine.succeed("curl --fail --request PUT --data \"test file\" http://localhost:5000/test.txt")
    machine.succeed("curl --fail http://localhost:5000/test.txt | grep \"^test file$\"")
  '';
}
