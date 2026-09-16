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
  # silently falling back to a default socket path: Doctrine DBAL's DSN
  # parser ingests query parameters verbatim (no camelCase/snake_case
  # normalization), and its PDO MySQL driver only recognizes `unix_socket`,
  # not `unixSocket`.
  #
  # database.host is deliberately left at its "localhost" default rather
  # than set to an IP: per the MySQL client library's own documented
  # behaviour, the unix_socket DSN parameter is used *only* when host is
  # NULL or the literal string "localhost" -- any other host value (e.g.
  # 127.0.0.1) makes the client use TCP unconditionally and ignore
  # unix_socket entirely, which would make this test pass or fail for
  # reasons unrelated to whether the socket parameter was honored (verified
  # empirically: with skip-networking enabled, host=127.0.0.1 fails
  # identically regardless of the fix, since TCP is unavailable either way).
  #
  # To still force the outcome to depend on the socket param actually being
  # passed through, we instead make the *default* socket path php would
  # silently fall back to (if unix_socket were dropped) point at a socket
  # that doesn't exist -- php.ini's pdo_mysql.default_socket is overridden
  # per-pool to a bogus path, while MySQL itself keeps listening on the real
  # default path. skip-networking is also enabled as a belt-and-suspenders
  # guard against any TCP fallback masking the result.
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
