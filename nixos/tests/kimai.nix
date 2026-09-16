{ lib, ... }:

{
  name = "kimai";
  meta.maintainers = with lib.maintainers; [ peat-psuwit ];

  containers.machine =
    { ... }:
    {
      services.kimai.sites."localhost" = {
        database.createLocally = true;
      };
    };

  # Regression test for `database.socket` actually being used, rather than
  # silently falling back to TCP: Doctrine DBAL's DSN parser ingests query
  # parameters verbatim (no camelCase/snake_case normalization), and its PDO
  # MySQL driver only recognizes `unix_socket`, not `unixSocket`. MySQL has
  # no TCP listener at all here, so a request only succeeds if Kimai is
  # actually connecting through the configured socket.
  containers.socketMachine =
    { ... }:
    {
      services.kimai.sites."localhost" = {
        database.createLocally = true;
        database.socket = "/run/mysqld/mysqld.sock";
      };
      services.mysql.settings.mysqld.skip-networking = true;
    };

  testScript = ''
    start_all()

    machine.wait_for_unit("phpfpm-kimai-localhost.service")
    machine.wait_for_unit("nginx.service")
    machine.wait_for_open_port(80)
    machine.succeed("curl -v --location --fail http://localhost/")
    # Make sure bundled assets are served.
    # https://github.com/NixOS/nixpkgs/issues/442208
    machine.succeed("curl -v --location --fail http://localhost/bundles/tabler/tabler.css")

    socketMachine.wait_for_unit("phpfpm-kimai-localhost.service")
    socketMachine.wait_for_unit("nginx.service")
    socketMachine.wait_for_open_port(80)
    socketMachine.succeed("curl -v --location --fail http://localhost/")
  '';
}
