{ lib, ... }:
{
  name = "fanout";
  meta.maintainers = with lib.maintainers; [ therishidesai ];

  nodes.machine = {
    services.fanout = {
      enable = true;
      fanoutDevices = 2;
      bufferSize = 8192;
    };
  };

  testScript = ''
    start_all()

    # mDNS.
    machine.wait_for_unit("multi-user.target")

    machine.succeed("test -c /dev/fanout0")
    machine.succeed("test -c /dev/fanout1")
  '';
}
