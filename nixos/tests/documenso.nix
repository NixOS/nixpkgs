{ lib, ... }:
{
  name = "documenso";
  meta = {
    maintainers = [ lib.teams.cyberus.members ];
  };

  nodes = {
    machine = _: {
      services.documenso = {
        enable = true;
      };
    };
  };

  testScript = ''
    machine.wait_for_unit("documenso.service")
    machine.wait_for_open_port(3000)
    machine.wait_for_console_text("All migrations have been successfully applied.")
  '';
}
