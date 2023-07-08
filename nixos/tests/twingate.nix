{
  name = "twingate";

  nodes.machine.services.twingate.enable = true;

  testScript = { nodes, ... }: ''
    machine.wait_for_unit("twingate.service")
    machine.succeed("twingate --version | grep '${nodes.machine.services.twingate.package.version}' >&2")
  '';
}
