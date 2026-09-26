{ lib, pkgs, ... }:
let
  pythonEnv = pkgs.python3.withPackages (p: [
    p.asynch
    p.pytest
    p.pytest-asyncio
    p.pytest-random-order
    p.pytest-mock
    p.pytest-xdist
  ]);
in
{
  name = "asynch";
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

    machine.succeed("cp ${pkgs.python3Packages.asynch.src}/pyproject.toml /build/source && cp -r ${pkgs.python3Packages.asynch.src}/tests /build/source/tests")

    machine.wait_for_unit("clickhouse.service")

    machine.succeed("cd /build/source && systemd-cat -t asynch-test ${pythonEnv.interpreter} -m pytest");
  '';
}
