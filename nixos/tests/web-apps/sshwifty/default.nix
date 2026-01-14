{ lib, pkgs, ... }:
{
  name = "sshwifty";

  nodes.machine =
    { ... }:
    {
      services.sshwifty = {
        enable = true;
        sharedKeyFile = pkgs.writeText "sharedkey" "rpz2E4QI6uPMLr";
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
    machine.wait_until_succeeds("curl --fail -6 http://localhost/", timeout=60)
    machine.wait_until_succeeds("${lib.getExe pkgs.nodejs} ${./sshwifty-test.js}", timeout=60)
  '';

  meta.maintainers = [ lib.maintainers.ungeskriptet ];
}
