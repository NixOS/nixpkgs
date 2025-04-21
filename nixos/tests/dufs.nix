{ lib, ... }:
{
  name = "dufs";
  meta.maintainers = with lib.maintainers; [ jackwilsdon ];

  nodes.machine =
    { ... }:
    {
      environment.etc."dufs".text = ''
        readwrite:password@/:rw
        readonly:password@/
      '';
      services.dufs = {
        enable = true;
        settings.serve-path = "/tmp";
        authFile = "/etc/dufs";
      };
    };

  testScript = ''
    machine.wait_for_unit("dufs.service")
    machine.wait_for_open_port(5000)

    machine.succeed("curl --fail --request PUT --data \"test file\" --user readwrite:password http://localhost:5000/test.txt")
    machine.succeed("curl --fail --user readonly:password http://localhost:5000/test.txt | grep \"^test file$\"")
    machine.fail("curl --fail http://localhost:5000/test.txt")
  '';
}
