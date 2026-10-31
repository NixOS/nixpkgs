# Integration test: TypeDB server (services.typedb) with the Console client.
# Exercises schema/insert/query through typedb-console, then reboots and
# proves the data survived (restart persistence).
{
  lib,
  pkgs,
  ...
}:
let
  # Console `--command` executes each string as one non-interactive command,
  # which cannot supply the empty-line terminator a transaction query needs.
  # Use script files instead; their blank lines terminate each TypeQL query.
  setupScript = pkgs.writeText "typedb-test-setup.tqls" ''
    database create testdb
    transaction schema testdb
    define entity person, owns name; attribute name, value string;

    commit
    transaction write testdb
    insert $p isa person, has name "ada";

    commit
    transaction read testdb
    match $p isa person, has name $n; select $n;

    close
  '';
  readScript = pkgs.writeText "typedb-test-read.tqls" ''
    transaction read testdb
    match $p isa person, has name $n; select $n;

    close
  '';
in
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
    out = server.succeed(f"{console} --script ${setupScript}")
    assert "Successfully committed transaction" in out, f"setup script should commit: {out}"
    assert "ada" in out, f"setup script output should contain the inserted name: {out}"

    # Restart persistence: reboot, same query still answers.
    server.shutdown()
    server.start()
    server.wait_for_unit("typedb.service")
    server.wait_for_open_port(1729)
    out = server.succeed(f"{console} --script ${readScript}")
    assert "ada" in out, f"post-reboot query should still contain the inserted name: {out}"
  '';

  meta.maintainers = with lib.maintainers; [ caniko ];
}
