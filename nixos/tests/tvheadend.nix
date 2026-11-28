{ lib, ... }:

{
  name = "tvheadend";
  meta.maintainers = with lib.maintainers; [ juaningan ];

  nodes.machine = {
    services.tvheadend = {
      enable = true;
      extraGroups = [ "tuners" ];
    };
    users.groups.tuners = { };
  };

  testScript = ''
    machine.wait_for_unit("tvheadend.service")
    for host in ("127.0.0.1", "::1"):
        machine.wait_for_open_port(9981, host)
        machine.wait_for_open_port(9982, host)

    # Enabling the service must not grant anonymous admin access.
    status = machine.succeed("curl -sS -o /dev/null -w '%{http_code}' http://localhost:9981/api/config/load")
    assert status in ("401", "403"), status

    pid = machine.succeed("systemctl show -p MainPID --value tvheadend.service").strip()
    groups = machine.succeed(f"grep '^Groups:' /proc/{pid}/status").split()[1:]
    tuners_gid = machine.succeed("getent group tuners").split(":")[2]
    assert tuners_gid in groups, groups
  '';
}
