{ lib, ... }:
{
  name = "vnstat";
  meta.maintainers = with lib.maintainers; [ hmenke ];

  containers.machine = {
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
    machine.fail("vnstat -i dummy0")
    machine.succeed("ip link add dummy0 type dummy")
    machine.succeed("ip link set dummy0 up")
    machine.wait_until_succeeds("vnstat -i dummy0", timeout=10)
  '';
}
