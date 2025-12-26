{
  name = "twingate";

  nodes.machine.services.twingate.enable = true;

  testScript =
    { nodes, ... }:
    ''
      machine.wait_for_unit("twingate.service")
      machine.succeed("twingate --version | grep '${nodes.machine.services.twingate.package.version}' >&2")
      machine.succeed("twingate config log-level 'debug'")
      machine.systemctl("restart twingate.service")
      machine.succeed("grep 'debug' /etc/twingate/log_level.conf >&2")
      machine.succeed("twingate config log-level | grep 'debug' >&2")
    '';
}
