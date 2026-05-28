{ lib, ... }:
{
  name = "komodo-periphery";
  meta = {
    maintainers = with lib.maintainers; [ channinghe ];
  };

  nodes.machine =
    { config, pkgs, ... }:
    {
      virtualisation.docker.enable = true;
      services.komodo-periphery = {
        enable = true;
        bindIp = "127.0.0.1";
        port = 8120;
        ssl.enable = false;
        passkeys = [ "test-passkey" ];
      };
    };

  testScript = ''
    machine.wait_for_unit("komodo-periphery.service")
    machine.wait_for_open_port(8120)
    machine.succeed("systemctl status komodo-periphery.service")
  '';
}
