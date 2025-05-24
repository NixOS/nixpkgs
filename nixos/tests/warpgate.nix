{
  name = "warpgate";

  nodes.machine = {
    services.warpgate = {
      enable = true;
      bindOnPrivilegedPorts = true;
    };
  };

  testScript = ''
    machine.wait_for_unit("warpgate.service")
    machine.wait_for_open_port(8888)

    machine.succeed("stat /var/lib/warpgate/db/db.sqlite3")
    machine.succeed("curl -k --fail https://localhost:8888/@warpgate")

    machine.systemctl("restart warpgate.service")
    machine.wait_for_unit("warpgate.service")
    machine.succeed("curl -k --fail https://localhost:8888/@warpgate")
  '';
}
