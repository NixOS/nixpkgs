{ pkgs, ... }:
{
  name = "openlinkhub";
  meta.maintainers = [ ];

  nodes.machine =
    { ... }:
    {
      services.hardware.openlinkhub.enable = true;
    };

  testScript = ''
    machine.wait_for_unit("openlinkhub.service")
    machine.wait_for_open_port(27003)
    machine.succeed("curl -sfL http://127.0.0.1:27003/ >/dev/null")
    machine.succeed("test -d /var/lib/openlinkhub/database")
    machine.succeed(
        "systemctl show -p User --value openlinkhub.service | grep -x openlinkhub"
    )
  '';
}
