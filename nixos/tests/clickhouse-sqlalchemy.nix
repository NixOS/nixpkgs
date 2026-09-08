{ lib, pkgs, ... }:
let
  pythonEnv = pkgs.python3.withPackages (p: [
    p.clickhouse-sqlalchemy
    p.pytest
    p.pytest-asyncio
    p.sqlalchemy
    p.greenlet
    p.alembic
    p.requests
    p.responses
    p.parameterized
  ]);
  testsSrc = pkgs.applyPatches {
    src = pkgs.python3Packages.clickhouse-sqlalchemy.src;
    patches = pkgs.python3Packages.clickhouse-sqlalchemy.patches or [ ];
  };
in
{
  name = "clickhouse-sqlalchemy";
  meta.maintainers = [ lib.maintainers.joaosreis ];

  nodes.machine =
    { ... }:
    {
      environment.systemPackages = [ pythonEnv ];

      services.clickhouse.enable = true;
    };

  testScript = ''
    start_all()

    machine.wait_for_unit("multi-user.target")

    machine.succeed("mkdir -p /build/source")

    machine.succeed("cp ${testsSrc}/setup.cfg /build/source/")

    machine.succeed("cp -r ${testsSrc}/tests /build/source/tests")

    machine.wait_for_unit("clickhouse.service")

    machine.succeed("cd /build/source && systemd-cat -t clickhouse-sqlalchemy-test ${pythonEnv.interpreter} -m pytest");
  '';
}
