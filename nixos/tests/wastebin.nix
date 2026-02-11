{ lib, ... }:
{
  name = "wastebin";

  meta = {
    maintainers = with lib.maintainers; [ pinpox ];
  };

  nodes.machine =
    { pkgs, ... }:
    {
      services.wastebin = {
        enable = true;
      };
    };

  testScript = ''
    machine.wait_for_unit("wastebin.service")
    machine.wait_for_open_port(8088)
    machine.succeed("curl --fail http://localhost:8088/")
  '';
}
