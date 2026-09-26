{ config, ... }:
let
  pkgs = config.node.pkgs;
  steve = pkgs.steve;
  python = pkgs.python3.withPackages (ps: [
    ps.pytest
    ps.pytest-timeout
  ]);
  testSource = pkgs.applyPatches {
    name = "steve-${steve.version}-tests";
    src = steve.src;
    patches = [ ./fix-test-path-import.patch ];
  };
in
{
  name = "steve-upstream";
  meta.maintainers = steve.meta.maintainers;

  nodes.machine = {
    boot.kernelModules = [ "cuse" ];
  };

  testScript = ''
    machine.wait_for_unit("systemd-modules-load.service")
    machine.succeed("test -c /dev/cuse")
    print(
        machine.succeed(
            "STEVE=${steve}/bin/steve ${python}/bin/python -B -m pytest -v -p no:cacheprovider ${testSource}/test",
            timeout=120,
        )
    )
  '';
}
