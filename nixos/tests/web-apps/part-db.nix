{ lib, ... }:
{
  name = "part-db";
  meta.maintainers = with lib.maintainers; [ oddlama ];

  nodes = {
    machine = {
      services.part-db.enable = true;
    };
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("postgresql.service")
    machine.wait_for_unit("part-db-migrate.service")
    machine.wait_for_unit("phpfpm-part-db.service")
    machine.wait_for_unit("nginx.service")
    machine.wait_for_open_port(80)

    machine.succeed("curl -L --fail http://localhost | grep 'Part-DB'", timeout=10)
  '';
}
