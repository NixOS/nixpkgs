{ lib, ... }:
{
  name = "sshwifty";

  nodes.machine =
    { ... }:
    {
      services.sshwifty = {
        enable = true;
        settings = {
          HostName = "localhost";
          Servers = [
            {
              ListenInterface = "::1";
              ListenPort = 80;
              ServerMessage = "NixOS test";
            }
          ];
        };
      };
    };

  testScript = ''
    machine.wait_for_unit("sshwifty.service")
    machine.wait_for_open_port(80)
    machine.wait_until_succeeds("curl --fail -6 http://localhost/sshwifty/socket/verify | grep 'NixOS test'")
  '';

  meta.maintainers = [ lib.maintainers.ungeskriptet ];
}
