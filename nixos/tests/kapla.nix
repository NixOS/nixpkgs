{ lib, ... }:
{
  name = "kapla";

  nodes.machine =
    { pkgs, ... }:
    {
      services.kapla = {
        enable = true;
        group = "users";
      };
    };

  testScript = ''
    start_all()

    machine.wait_for_unit("kapla.service")

    resource = machine.succeed('echo "Hello world!" | kapla encode -')
    assert "Hello world!" in machine.succeed(f"kapla decode {resource.strip()}")
  '';

  meta = {
    maintainers = [ lib.maintainers.sempiternal-aurora ];
    teams = [ lib.teams.ngi ];
  };
}
