{ lib, ... }:
let
  port = 8080;
in
{
  name = "corteza";
  meta.maintainers = [ lib.teams.ngi.members ];

  nodes.machine = {
    services.corteza = {
      enable = true;
      inherit port;
    };
  };

  testScript = ''
    machine.start()

    machine.wait_for_unit("default.target")

    machine.wait_until_succeeds("curl http://localhost:${toString port}/auth/login | grep button-login")
  '';
}
