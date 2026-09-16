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

  # Use an invalid PDO default socket so the test only passes when
  # database.socket is propagated as unix_socket.
  containers.socketMachine =
    { ... }:
    {
      services.kimai.sites."localhost" = {
        database.createLocally = true;
        database.socket = "/run/mysqld/mysqld.sock";
      };
      services.phpfpm.pools."kimai-localhost".settings."php_admin_value[pdo_mysql.default_socket]" =
        "/run/mysqld/does-not-exist.sock";
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
