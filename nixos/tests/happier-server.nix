{ pkgs, lib, ... }:

{
  name = "happier-server";
  meta.maintainers = with lib.maintainers; [ imalison ];

  nodes.machine =
    { ... }:
    {
      services.happier-server = {
        enable = true;
        masterSecretFile = pkgs.writeText "happier-server-master-secret" "happier-server-test-secret";
      };

      environment.systemPackages = [ pkgs.sqlite ];
    };

  testScript = ''
    start_all()

    machine.wait_for_unit("happier-server.service")
    machine.wait_for_open_port(3000)
    machine.succeed("test -s /var/lib/happier-server/db/happier-server-light.sqlite")
    machine.succeed("sqlite3 /var/lib/happier-server/db/happier-server-light.sqlite '.tables' | grep -w _prisma_migrations")
  '';
}
