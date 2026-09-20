# Integration test: TypeDB server (services.typedb) with the Console client.
# Exercises schema/insert/query through typedb-console, then reboots and
# proves the data survived (restart persistence).
{
  lib,
  pkgs,
  ...
}:
{
  name = "typedb";

  nodes.server =
    { pkgs, ... }:
    {
      services.typedb.enable = true;
      environment.systemPackages = [ pkgs.typedb-console ];
    };

  testScript = ''
    start_all()
    server.wait_for_unit("typedb.service")
    server.wait_for_open_port(1729)

    console = "typedb-console --address 127.0.0.1:1729 --tls-disabled --username admin --password password"

    # Schema + write + read through the Console client.
    server.succeed(
        f"{console}"
        ' --command "database create testdb"'
        ' --command "transaction testdb schema"'
        ' --command "define entity person, owns name; attribute name, value string;"'
        ' --command "commit"'
        ' --command "transaction testdb write"'
        " --command 'insert $p isa person, has name \"ada\";'"
        ' --command "commit"'
        ' --command "transaction testdb read"'
        ' --command "match $p isa person, has name $n; select $n;"'
        " | grep -q ada"
    )

    # Restart persistence: reboot, same query still answers.
    server.shutdown()
    server.start()
    server.wait_for_unit("typedb.service")
    server.wait_for_open_port(1729)
    server.succeed(
        f"{console}"
        ' --command "transaction testdb read"'
        ' --command "match $p isa person, has name $n; select $n;"'
        " | grep -q ada"
    )
  '';

  meta.maintainers = with lib.maintainers; [ caniko ];
}
