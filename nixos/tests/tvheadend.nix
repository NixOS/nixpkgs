{ lib, pkgs, ... }:

{
  name = "tvheadend";

  meta.maintainers = with lib.maintainers; [ juaningan ];

  nodes.machine =
    { ... }:
    {
      services.tvheadend = {
        enable = true;
        extraGroups = [ "tuners" ];
      };

      users.groups.tuners = { };

      environment.systemPackages = [ pkgs.curl ];
    };

  testScript = ''
    start_all()

    machine.wait_for_unit("tvheadend.service")
    machine.wait_for_open_port(9981)
    machine.wait_for_open_port(9982)

    # The Web UI should answer even before any setup is completed.
    machine.succeed("curl -sS -D- http://localhost:9981/ -o /dev/null | grep -qi 'HTS/tvheadend\\|Tvheadend'")

    pid = machine.succeed("systemctl show -p MainPID --value tvheadend.service").strip()
    assert pid.isdigit() and int(pid) > 0

    tuners_gid = machine.succeed("getent group tuners | cut -d: -f3").strip()
    machine.succeed(f"grep -qE '^Groups:.*(\\s|^){tuners_gid}(\\s|$)' /proc/{pid}/status")
  '';
}
