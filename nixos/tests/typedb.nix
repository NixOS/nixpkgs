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

    # Schema + write + read through the Console client. TypeQL variables
    # stay inside single quotes so the guest shell passes `$p` and `$n`
    # through unchanged.
    out = server.succeed(
        f"{console}"
        " --command 'database create testdb'"
        " --command 'transaction schema testdb'"
        " --command 'define entity person, owns name; attribute name, value string;'"
        " --command 'commit'"
        " --command 'transaction write testdb'"
        " --command 'insert $p isa person, has name \"ada\";'"
        " --command 'commit'"
        " --command 'transaction read testdb'"
        " --command 'match $p isa person, has name $n; select $n;'"
    )
    assert "ada" in out, f"console query output should contain the inserted name: {out}"

    # Restart persistence: reboot, same query still answers.
    server.shutdown()
    server.start()
    server.wait_for_unit("typedb.service")
    server.wait_for_open_port(1729)
    out = server.succeed(
        f"{console}"
        " --command 'transaction read testdb'"
        " --command 'match $p isa person, has name $n; select $n;'"
    )
    assert "ada" in out, f"post-reboot query should still contain the inserted name: {out}"
  '';

  meta.maintainers = with lib.maintainers; [ caniko ];
}
