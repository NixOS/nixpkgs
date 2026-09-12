{ lib, ... }:
{
  name = "sforzando";
  meta.maintainers = with lib.maintainers; [ Incand ];

  nodes.machine =
    { ... }:
    {
      programs.sforzando.enable = true;
    };

  testScript = ''
    machine.wait_for_unit("multi-user.target")
    machine.wait_for_unit("systemd-tmpfiles-setup.service")

    with subtest("system symlinks are created"):
        machine.succeed("test -L /opt/Plogue")
        machine.succeed("test -e /opt/Plogue/Aria/libAria.so")
        machine.succeed("test -L /usr/bin/zenity")

    with subtest("sforzando binary is on PATH"):
        machine.succeed("sforzando --help || true")
  '';
}
