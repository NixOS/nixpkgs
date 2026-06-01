{ lib, ... }:
{
  name = "watcharr";
  meta.maintainers = with lib.maintainers; [ miniharinn ];

  nodes.machine = {
    services.watcharr.enable = true;
  };

  testScript = ''
    machine.wait_for_unit("watcharr.service")
    machine.wait_for_open_port(3080)
    machine.wait_for_open_port(3000)

    machine.succeed("curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:3080/api/features | grep -q 401")
    machine.succeed("curl --fail --silent --show-error http://127.0.0.1:3080/ | grep -q '<title>Watcharr</title>'")

    machine.succeed("test -f /var/lib/watcharr/watcharr.db")
    machine.succeed("test -f /var/lib/watcharr/watcharr.log")
  '';
}
