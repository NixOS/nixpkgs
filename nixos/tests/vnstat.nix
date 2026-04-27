{ lib, ... }:
{
  name = "vnstat";
  meta.maintainers = with lib.maintainers; [ hmenke ];

  nodes.machine = {
    services.vnstat = {
      enable = true;
      settings = {
        AlwaysAddNewInterfaces = 1;
      };
    };
  };

  testScript = ''
    start_all()

    machine.wait_for_unit("vnstat.service")

    machine.succeed("vnstat --iflist")
    machine.succeed("ip link add dummy0 type dummy")
    machine.succeed("ip link set dummy0 up")
    machine.wait_until_succeeds("vnstat --iflist | grep -F dummy0", timeout=10)
  '';
}
